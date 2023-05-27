import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/screens/EditProfileScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/widgets/layout/VerticalSpacing.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController auth = Get.find();

  UserController user = Get.find();
  String? username = "";
  String? address = "";
  String? addressDetail = "";
  String? noteToDriver = "";
  String? contactNumber = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    print(auth.user.value!.email);
    print(auth.user.value!.name);
    return CustomScaffold(
      body: ListView(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 1.5 / 100,
            bottom: MediaQuery.of(context).size.height * 3 / 100),
        children: [
          OpenContainer(
            tappable: false,
            closedElevation: 0,
            openElevation: 0,
            middleColor: Colors.transparent,
            closedColor: Colors.transparent,
            transitionType: ContainerTransitionType.fadeThrough,
            closedBuilder: (BuildContext _, VoidCallback openContainer) {
              return GlassCard_header(
                header: Header(
                  title: "Profile",
                  trailing: IconButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: openContainer,
                      icon: const Icon(Icons.edit)),
                  navigateBack: true,
                ),
                height: MediaQuery.of(context).size.height * 75 / 100,
                child: Obx(
                  () => SingleChildScrollView(
                    child: SizedBox(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 2 / 100),
                          createEditProfileField(
                            context: context,
                            fieldName: "Name",
                            initialValue: auth.user.value!.name,
                            readOnly: true,
                          ),
                          createEditProfileField(
                            context: context,
                            fieldName: "Email",
                            initialValue: auth.user.value!.email,
                            readOnly: true,
                          ),
                          createEditProfileField(
                            context: context,
                            fieldName: "Contact",
                            initialValue: auth.user.value!.hp,
                            readOnly: true,
                          ),
                          createEditProfileField(
                            context: context,
                            fieldName: "Address",
                            initialValue: auth.user.value!.address,
                            readOnly: true,
                          ),
                          createEditProfileField(
                            context: context,
                            fieldName: "Address Details",
                            initialValue: auth.user.value!.addressDetails,
                            readOnly: true,
                          ),
                        ])),
                  ),
                ),
              );
            },
            openBuilder: (BuildContext _, VoidCallback openContainer) {
              return EditProfileScreen(isFirstTime: false);
            },
          ),
          VerticalSpacing(),
          Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 45 / 100,
              child: ElevatedButton(
                onPressed: () async {
                  await auth.signOut();
                },
                child: Text(
                  "Log Out",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Align(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 45 / 100,
              child: OutlinedButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    backgroundColor: Colors.white.withOpacity(0.95),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 45 / 100,
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: MediaQuery.of(context).size.height *
                                    4 /
                                    100,
                                horizontal: MediaQuery.of(context).size.width *
                                    10 /
                                    100),
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        60 /
                                        100,
                                    child: Text("Now just a minute.",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              2 /
                                              100),
                                  AutoSizeText(
                                    "Are you sure you want to delete your whole account?",
                                  ),
                                  AutoSizeText(
                                    "You'll lose everything. All your progress will be gone.",
                                  ),
                                  AutoSizeText(
                                    "If you're sure, then we're sorry to see you go, but don't stop recycling!",
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width *
                                        2 /
                                        100,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () async {
                                            EasyLoading.show(
                                                maskType:
                                                    EasyLoadingMaskType.black,
                                                status: "Loading");
                                            //TODO: Zq put the function here. Dont forget to navigate to login screen/log them off.
                                            await Future.delayed(
                                                Duration(milliseconds: 1500));
                                            EasyLoading.dismiss();
                                          },
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                35 /
                                                100,
                                            child: Center(
                                                child: AutoSizeText(
                                              'Delete Everything',
                                              maxLines: 1,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                35 /
                                                100,
                                            child: Center(
                                              child: const AutoSizeText(
                                                'Nevermind',
                                                maxLines: 1,
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              10 /
                                              100,
                                        ),
                                      ],
                                    ),
                                  )
                                ]))),
                  ),
                ),
                child: Text(
                  "Delete Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          VerticalSpacing(),
        ],
      ),
    );
  }

  SizedBox createEditProfileField({
    required BuildContext context,
    required String fieldName,
    required String initialValue,
    void Function(String)? onChanged,
    required bool readOnly,
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
                  enabled: false,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  initialValue: initialValue,
                  onChanged: onChanged,
                  readOnly: readOnly,
                  validator: validator)
            ],
          ),
        ));
  }
}
