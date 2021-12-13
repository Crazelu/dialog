import 'package:flutter/material.dart';

class DialogUtil {
  ///BuildContext is typically retrieved from
  ///the navigator key's currentContext.
  static late BuildContext _context;

  ///Returns `true` if [tapDetails] contains any offset
  ///in screen area where a dialog with GlobalKey [dialogKey]
  ///is not rendered.
  ///
  ///Otherwise, returns `false`.
  static bool canDismissDialog({
    required TapDownDetails tapDetails,
    required GlobalKey dialogKey,
    double dialogMargin = 20,
  }) {
    try {
      final size = _context.size!;
      final height = size.height;
      final width = size.width;

      final screenOffset = tapDetails.localPosition;
      final dialogHeight = dialogKey.currentContext!.size!.height;
      final dialogWidth = dialogKey.currentContext!.size!.width;

      return screenOffset.dy < (height - dialogHeight) / 2 ||
          screenOffset.dy > (height + dialogHeight) / 2 ||
          screenOffset.dx < ((width / 2) - (dialogWidth / 2) - dialogMargin) ||
          screenOffset.dx > ((width / 2) + (dialogWidth / 2) + dialogMargin);
    } catch (e) {
      print(e);
      return false;
    }
  }
}
