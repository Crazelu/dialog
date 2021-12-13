import 'package:flutter/material.dart';

class DialogRequest {
  DialogRequest({
    this.message = "",
    this.type = DialogType.error,
    this.duration = const Duration(seconds: 3),
    this.mainAxisAlignment = MainAxisAlignment.end,
    this.autoDimiss = true,
    this.arguments,
  });

  ///Type of dialog
  ///
  ///This is typically looked at to determine what kind of dialog to return.
  ///You can write different UI implementations for different dialogs and reference
  ///them using [type] just like you'd do with named routes.
  final DialogType type;

  ///For simple dialogs, [message] can be set for display
  final String message;

  ///If [autoDimiss] is true, dialog will be displayed for [duration]
  ///before being auto dismissed.
  final Duration duration;

  ///Alignment for dialog in the vertical axis.
  ///
  ///Can be taken out depending on your implementation.
  final MainAxisAlignment mainAxisAlignment;

  ///Specifies whether or not dialogs should be auto dismissed.
  final bool autoDimiss;

  ///Optional arguments just like you have with the Navigator API.
  ///
  ///Fun story, I really needed this as I started building complex dialogs
  ///with more than one purpose. E.g using one dialog with form for creating
  ///and updating some record. For updating, you might want to prefill the fields.
  ///
  ///Those values can be pulled from [arguments].
  final Object? arguments;
}

enum DialogType {
  error,
}
