import 'package:flutter/material.dart';

class EditProfileField extends StatefulWidget {
  EditProfileField({required this.field, Key? key}) : super(key: key);

  String field;

  @override
  State<EditProfileField> createState() => _EditProfileFieldState();
}

class _EditProfileFieldState extends State<EditProfileField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 70 / 100,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.field,
                textAlign: TextAlign.start,
              ),
            ),
            TextFormField(
              textAlign: TextAlign.start,
              keyboardType: TextInputType.name,
              initialValue: widget.field,
              onChanged: (val) {
                if (val.length > 0) {
                  setState(() {
                    widget.field = val;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Cannot be empty';
                }
                return null;
                // doSubmit();
              },
            )
          ],
        ));
  }
}
