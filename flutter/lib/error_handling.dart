import 'package:flutter/material.dart';
import 'package:sign_app/main.dart';

enum ErrorLevel { success, warning, error }

class ErrorHandling {
  void showError(String errorMessage, ErrorLevel errorLevel) {
    var snackBar = SnackBar(
      content: Center(child: Text(errorMessage, style: const TextStyle(fontWeight: FontWeight.bold),)),
      backgroundColor: _showErrorColor(errorLevel),
      behavior: SnackBarBehavior.floating,
    );

    MyApp.scaffoldKey.currentState?.showSnackBar(snackBar);
  }

 Color _showErrorColor(ErrorLevel errorLevel) {
    switch(errorLevel){
      case ErrorLevel.success:
        return Colors.green;
      case ErrorLevel.warning:
        return Colors.orange;
      case ErrorLevel.error:
        return Colors.red;
    }
 }
}
