import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/models/MissionModel.dart';

class MissionCard extends StatelessWidget {
  MissionCard({
    required this.pageController,
    required this.exp,
    required this.weight,
    Key? key,
  }) : super(key: key);
  int exp;
  double weight;

  late PageController pageController;

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    UserController user = Get.find();

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 3.5 / 100,
          vertical: MediaQuery.of(context).size.height * 1 / 100),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DEFAULT_RADIUS),
        clipBehavior: Clip.hardEdge,
        child: Container(
            height: MediaQuery.of(context).size.height * 7 / 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              // borderRadius: BorderRadius.circular(20),
              color: Colors.transparent,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  color: Colors.white.withOpacity(0.72),
                  height: double.infinity,
                  width: double.infinity,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 8 / 100,
                      right: MediaQuery.of(context).size.width * 2 / 100),
                  child: AutoSizeText.rich(
                    TextSpan(
                      text: "Recycle ",
                      children: [
                        TextSpan(
                            text: weight.toString() + " kg",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: " in a sinle collection.",
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ],
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.7)),
                    ),
                  ),
                )),
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Theme.of(context).primaryColorDark,
                      onTap: () async {},
                      child: Container(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          width: MediaQuery.of(context).size.width * 18 / 100,
                          padding: EdgeInsets.only(
                              right:
                                  MediaQuery.of(context).size.width * 1 / 100),
                          alignment: Alignment.center,
                          height: double.infinity,
                          child: Text(
                            exp.toString() + " exp",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
