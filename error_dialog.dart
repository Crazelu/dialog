import 'package:flutter/material.dart';
import 'dialog_request.dart';
import 'dialog_util.dart';

GlobalKey dialogContainerKey = GlobalKey();
double dialogMargin = 20;

class ErrorDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(Object) dismissDialog;

  const ErrorDialog({
    Key? key,
    required this.request,
    required this.dismissDialog,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).sizeidth;

    return GestureDetector(
      onTapDown: (details) {
        //if user taps on any area outside the space the dialog
        //takes on the screen, you can dismiss the dialog
        //to simulate the native dialog dismissal with Flutter dialogs
        if (DialogUtil.canDismissDialog(
          tapDetails: details,
          dialogKey: dialogContainerKey,
          dialogMargin: dialogMargin,
        )) {
          dismissDialog(false);
        }
      },
      child: Material(
        color: Colors.transparent,
        elevation: 10,
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 400,
                  key: dialogContainerKey,
                  margin: EdgeInsets.symmetric(horizontal: dialogMargin),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () => dismissDialog(false),
                            child: Icon(
                              Icons.close,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 73,
                        width: 88,
                       child: Icon(
                         Icons.close,
                          color: Colors.red, 
                       size:50,
                       ),
                      ),
                      SizedBox(height:20),
                      Text("Error message")
                      
                      SizedBox(height:30),
                    ],
                  ),
                ),
          
            ],
          ),
        ),
      ),
    );
  }
}
