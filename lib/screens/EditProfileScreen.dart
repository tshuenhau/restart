import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/screens/CustomScaffold.dart';
import 'package:restart/screens/EnterAddressScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:restart/env.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthController auth = Get.find();
  UserController userController = Get.find();
  String? username = "";
  String? address = "";

  //TODO: need these as well but i think maybe the model right now doesnt hav.
  String? addressDetail = "";
  String? noteToDriver = "";
  String? contactNumber = "";
  PageController pageController = PageController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    username = auth.user.value!.name;
    address = auth.user.value!.address;
    addressController.text = address ?? '';
    addressDetail = auth.user.value!.addressDetails;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      buildEditProfileScreen(context),
      // EnterAddressScreen(
      //   //TODO: Might need to add a callback here to change the state of Address from whatever EnterAddressScreen produces
      //   onPressed: () {
      //     pageController.animateToPage(0,
      //         duration: Duration(milliseconds: 500), curve: Curves.decelerate);
      //   },
      // )
    ];
    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: CustomScaffold(
            body: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                children: screens)));
  }

  Widget buildEditProfileScreen(BuildContext context) {
    return GlassCard_header(
      header: Header(
        title: "Edit Profile",
        navigateBack: true,
      ),
      height: MediaQuery.of(context).size.height * 90 / 100,
      child: SingleChildScrollView(
        child: Container(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
                createEditProfileField(
                    context: context,
                    fieldName: "Username",
                    initialValue: username!,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                      // doSubmit();
                    },
                    onChanged: (val) {
                      if (val.length > 0) {
                        setState(() {
                          username = val;
                        });
                      }
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 10 / 100,
                  width: MediaQuery.of(context).size.width * 70 / 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Address",
                          textAlign: TextAlign.start,
                        ),
                      ),
                      Stack(
                        children: [
                          Positioned(
                              right: 0,
                              bottom:
                                  MediaQuery.of(context).size.height * 3 / 100,
                              child: Icon(Icons.arrow_forward_ios,
                                  size: MediaQuery.of(context).size.height *
                                      2 /
                                      100)),
                          TextFormField(
                            onTap: () async {
                              //Shows the screen
                              Prediction? p = await PlacesAutocomplete.show(
                                context: context,
                                apiKey: GOOGLE_MAPS_API_KEY,
                                mode: Mode.overlay,
                                radius: 10000000,
                                components: [
                                  Component(Component.country, 'SG')
                                ],
                                types: [],
                                region: null,
                                language: 'en',
                                offset: 0,
                                strictbounds: false,
                                decoration: InputDecoration(
                                  hintText: 'Search Location',
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: const BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                              if (p != null) {
                                setState(() {
                                  addressController.text =
                                      p.description.toString();
                                  address = addressController.text;
                                });
                              }
                            },
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.streetAddress,
                            readOnly: true,
                            controller: addressController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Cannot be empty';
                              }
                              return null;
                              // doSubmit();
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                createEditProfileField(
                    context: context,
                    fieldName: "Address Details",
                    initialValue: addressDetail!,
                    validator: null,
                    onChanged: (val) {
                      setState(() {
                        addressDetail = val;
                      });
                    }),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width * 15 / 100,
                            child: Center(child: Text("Back")))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 12 / 100),
                    ElevatedButton(
                      onPressed: () async {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          String phone_number = "90602197";
                          await userController.updateUserProfile(username!,
                              phone_number, address!, addressDetail!);
                          Navigator.pop(context);
                        }
                      },
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 15 / 100,
                          child: Text(
                            'Save',
                            textAlign: TextAlign.center,
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox createEditProfileField(
      {required BuildContext context,
      required String fieldName,
      required String initialValue,
      required void Function(String) onChanged,
      String? Function(String?)? validator}) {
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
                  validator: validator)
            ],
          ),
        ));
  }
}
