import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/ForgotPasswordConfirmationScreen.dart';
import 'package:restart/screens/LoginScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  AuthController auth = Get.find();
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Center(
      child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.5 / 100,
              bottom: MediaQuery.of(context).size.height * 3 / 100),
          child: GlassCard_header(
            header: Header(navigateBack: true, title: "Forgot your password?"),
            height: MediaQuery.of(context).size.height * 85 / 100,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 28 / 100,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                HexColor("92b2ff"), BlendMode.srcATop),
                            child: Image.asset("assets/icons/logo_white.png",
                                fit: BoxFit.cover,
                                height: MediaQuery.of(context).size.height *
                                    14 /
                                    100,
                                width: MediaQuery.of(context).size.width *
                                    30 /
                                    100),
                          ),
                          Text("RE:start",
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 6 / 100,
                                color: HexColor("92b2ff"),
                                fontWeight: FontWeight.bold,
                              )),
                        ]),
                  ),
                  createLoginField(
                    context: context,
                    controller: email,
                    fieldName: "Email",
                    initialValue: '',
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 100),
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 45 / 100,
                      child: ElevatedButton(
                          onPressed: () async {
                            await auth.sendResetPasswordEmail(email.text);
                            Get.offAll(ForgotPasswordConfirmationScreen(
                              email: email.text,
                            ));
                          },
                          child: AutoSizeText("Submit")),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 8 / 100),
                ],
              ),
            ),
          )),
    ));
  }

  SizedBox createLoginField({
    required BuildContext context,
    required TextEditingController controller,
    required String fieldName,
    required String initialValue,
    required bool obscureText,
    required TextInputType keyboardType,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 10 / 100,
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
                  validator: validator)
            ],
          ),
        ));
  }
}
