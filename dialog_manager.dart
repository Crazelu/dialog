import 'package:flutter/material.dart';
import 'dialog_handler.dart';
import 'dialog_request.dart';
import 'error_dialog.dart';

///Add these lines to your MaterialApp to place the Dialogs
///over each page route built by the Navigator API
///
/// builder: (context, widget) => Navigator(
///          onGenerateRoute: (settings) => MaterialPageRoute(
///            builder: (context) => DialogManager(
///              child: widget!,
///            ),
///          ),
///        ),
///
///
///And you're all set!

class DialogManager extends StatefulWidget {
  final Widget child;
  const DialogManager({Key? key, required this.child}) : super(key: key);

  @override
  _DialogManagerState createState() => _DialogManagerState();
}

class _DialogManagerState extends State<DialogManager> {
  late DialogHandler _dialogHandler;

  @override
  void initState() {
    super.initState();

    ///Grab the DialogHandler and register the two important callbacks.
    ///
    ///For showing dialogs and for dismissing dialogs.
    _dialogHandler = locator<DialogHandler>();
    _dialogHandler.registerShowDialogListener(_showDialog);
    _dialogHandler.registerDismissDialogListener(_dismissDialog);
  }

  Route _showDialog(DialogRequest request) {
    final route = DialogRoute(
      context: context,
      builder: (_) => getDialogCard(request),
      barrierDismissible: true,
      barrierColor: Theme.of(context).primaryColorDark.withOpacity(.75),
    );

    Navigator.of(
      context,
      rootNavigator: true,
    ).push(route);

    //dismiss dialog after [duration]
    if (request.autoDimiss)
      Future.delayed(request.duration).then(
        (value) => _dismissDialog(request.type),
      );

    return route;
  }

  void _dismissDialog(DialogType type, [Object status = false]) {
    final route = _dialogHandler.dialogComplete(type, status);
    if (route != null) {
      Navigator.of(context).removeRoute(route);
    }
  }

  ///Modify as your [DialogType]s grow
  Widget getDialogCard(DialogRequest request) {
    switch (request.type) {
      case DialogType.error:
        //TODO: Reference your UI and pass the DialogRequest object
        //if you need to, also pass a callback for dismissing the dialog
        //if you have a dismiss button or if you need to enable tapping the
        //barrier to dismiss for which you'll need [DialogUtil]

        return ErrorDialog(
          request: request,
          dismissDialog: (status) => _dismissDialog(request.type, status),
        );

      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
