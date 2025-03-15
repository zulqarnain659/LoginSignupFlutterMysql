import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loginsignupapp/login.dart';

class InputField extends StatelessWidget {
  final String? HintText, LabelText, ErrorText;
  final VoidCallback? callbackAction;
  final ValueChanged? ErrorValidation;
  final TextEditingController? InputController;
  final Icon? Endicon;
  final bool? Secure;

  const InputField({
    required this.InputController,
    required this.HintText,
    required this.LabelText,
    this.callbackAction,
    this.Endicon,
    this.ErrorValidation,
    this.ErrorText,
    this.Secure=false,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return TextField(
      controller: InputController,
      obscureText: Secure!,
      decoration: InputDecoration(
        hintText: HintText,
        hintStyle: TextStyle(color: Colors.green[900]),
        label: Text(LabelText!),
        labelStyle: TextStyle(color: Colors.green[900]),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green),
        ),
        suffixIcon: IconButton(
            onPressed: () {
              callbackAction!();
            },
            icon: Endicon!),
        errorText: ErrorText,

      ),
      onChanged: ErrorValidation,
    );
  }
}
