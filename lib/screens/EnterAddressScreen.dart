import 'package:flutter/material.dart';

class EnterAddressScreen extends StatefulWidget {
  EnterAddressScreen({required this.addressController, Key? key})
      : super(key: key);
  TextEditingController addressController;
  @override
  State<EnterAddressScreen> createState() => _EnterAddressScreenState();
}

class _EnterAddressScreenState extends State<EnterAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
