import 'package:flutter/material.dart';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:restart/env.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'dart:async';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/widgets/layout/CustomSearchScaffold.dart';

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
