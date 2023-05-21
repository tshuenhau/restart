import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/screens/EditProfileScreen.dart';

class SetDetailsScreen extends StatelessWidget {
  const SetDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());
    print("SET DETAILS SCREEN");
    return EditProfileScreen(isFirstTime: true);
  }
}
