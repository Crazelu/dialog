import 'dart:async';
import 'package:flutter/material.dart';
import 'dialog_request.dart';

///Register this with a service locator
///(I use GetIt hence the locator references)
///
///Then you can show dialogs from anywhere (UI, ViewModels, anywhere).

abstract class DialogHandler {
  ///Dismisses a dialog
  void dismissDialog([Route? route]);

  /// Registers a callback to show a dialog
  void registerShowDialogListener(
      Route Function(DialogRequest) showDialogListener);

  ///Registers a callback to dismiss a dialog
  void registerDismissDialogListener(Function dismissCurrentDialog);

  ///Regsiters a callback to complete the completer
  Route? dialogComplete(DialogType type, Object response);

  ///Displays a dialog on the screen
  Future<Object> showDialog({
    DialogType type = DialogType.error,
    String message = '',
    Duration duration = const Duration(seconds: 3),
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.end,
    bool autoDimiss = false,
    Object? arguments,
  });
}

class DialogHandlerImpl implements DialogHandler {
  late Route Function(DialogRequest) _showDialogListener;
  late Function _dismissCurrentDialog;

  ///Map of dialogs on screen referenced by their types
  ///along with their corresponding Completer and Route objects.
  ///
  ///This allows popping a specific dialog and removing it's route
  ///instead of removing the last dialog like was the case before.
  Map<DialogType, List> _completers = {};

  @override
  void registerShowDialogListener(
      Route Function(DialogRequest) showDialogListener) {
    _showDialogListener = showDialogListener;
  }

  @override
  void registerDismissDialogListener(Function dismissCurrentDialog) {
    _dismissCurrentDialog = dismissCurrentDialog;
  }

  @override
  void dismissDialog([Route? route]) {
    _dismissCurrentDialog(route);
  }

  ///Dismisses any visible dialog registered with DialogType-> [type].
  ///
  ///The strategy used here is straightforward but has one drawback.
  ///It allows for dialogs to be displayed on top of each other but
  ///dialogs with the same DialogType will not be shown on top of each other.
  ///The older one has to be removed for another to go on.
  ///
  ///This will rarely happen that you'll need dialogs of the same type
  ///shown on top of each other but if you will, then consider implementing
  ///a stack for [_completers] instead of Map<DialogType, List>.
  void _closeVisibleDialog(DialogType type) {
    Route? route;
    if (_completers.containsKey(type)) {
      if (!(_completers[type]!.first as Completer).isCompleted)
        _completers[type]!.first.complete(false);
      route = _completers[type]!.last;
    }

    if (route != null) {
      //use whatever you want here to retrieve the context
      //GO LEGEND!
      Navigator.of(
        locator<NavigationHandler>().navigatorKey.currentContext!,
        rootNavigator: true,
      ).removeRoute(route);
      _completers.remove(type);
    }
  }

  /// Calls the dialog listener and returns a Future
  /// that will wait for [dialogComplete].
  @override
  Future<Object> showDialog({
    DialogType type = DialogType.error,
    String message = '',
    Duration duration = const Duration(seconds: 3),
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.end,
    bool autoDimiss = false,
    Object? arguments,
  }) {
    _closeVisibleDialog(type);

    final route = _showDialogListener(
      DialogRequest(
        message: message,
        type: type,
        duration: duration,
        mainAxisAlignment: mainAxisAlignment,
        autoDimiss: autoDimiss,
        arguments: arguments,
      ),
    );

    _completers[type] = [Completer<Object>(), route];

    return _completers[type]!.first.future;
  }

  /// Completes the _dialogCompleter to resume the Future's execution call
  /// and returns the route bound to this dialog to be remove by Navigator
  @override
  Route? dialogComplete(DialogType type, Object response) {
    try {
      Route? route;
      if (_completers.containsKey(type)) {
        if (!(_completers[type]!.first as Completer).isCompleted)
          _completers[type]!.first.complete(response);
        route = _completers[type]!.last;
        _completers.remove(type);
      }
      return route;
    } catch (e) {}
  }
}
