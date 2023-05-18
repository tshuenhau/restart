import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/screens/EditProfileScreen.dart';
import 'package:restart/widgets/ExperienceSection.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/GlassCard.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/ProfileFieldCard.dart';
import 'package:restart/widgets/layout/VerticalSpacing.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:get/get.dart';

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
    username = auth.user.value!.name;
    address = auth.user.value!.address;
    // addressController.text = address ?? '';
    addressDetail = auth.user.value!.addressDetails;
  }

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.find();
    return CustomScaffold(
      body: ListView(
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
                  child: SingleChildScrollView(
                    child: SizedBox(
                        child: Column(children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 2 / 100),
                      createEditProfileField(
                        context: context,
                        fieldName: "Username",
                        initialValue: username!,
                        readOnly: true,
                      ),
                      createEditProfileField(
                        context: context,
                        fieldName: "Contact",
                        initialValue: contactNumber!,
                        readOnly: true,
                      ),
                      createEditProfileField(
                        context: context,
                        fieldName: "Address",
                        initialValue: address!,
                        readOnly: true,
                      ),
                      createEditProfileField(
                        context: context,
                        fieldName: "Address Details",
                        initialValue: addressDetail!,
                        readOnly: true,
                      ),
                    ])),
                  ));
            },
            openBuilder: (BuildContext _, VoidCallback openContainer) {
              return EditProfileScreen();
            },
          ),
          VerticalSpacing(),
          Align(
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 45 / 100,
                child: OutlinedButton(
                    onPressed: () async {
                      await auth.signOutFromGoogle();
                    },
                    child: Text(
                      "Log Out",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
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
