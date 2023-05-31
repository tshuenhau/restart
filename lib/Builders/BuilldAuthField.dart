import 'package:flutter/material.dart';

SizedBox BuildAuthField({
  required BuildContext context,
  required TextEditingController controller,
  required String fieldName,
  required String initialValue,
  required bool obscureText,
  required TextInputType keyboardType,
  required TextInputAction keyboardInputAction,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
}) {
  return SizedBox(
      height: MediaQuery.of(context).size.height * 12 / 100,
      width: MediaQuery.of(context).size.width * 70 / 100,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                fieldName,
                textAlign: TextAlign.start,
              ),
            ),
            TextFormField(
              autofocus: false,
              textAlign: TextAlign.start,
              controller: controller,
              keyboardType: keyboardType,
              obscureText: obscureText,
              onChanged: onChanged,
              validator: validator,
              textInputAction: keyboardInputAction,
            ),
          ],
        ),
      ));
}
