import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/App.dart';
import 'package:restart/screens/SetDetailsScreen.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController reenterpw = TextEditingController();
  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.put(AuthController());

    return CustomScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.5 / 100,
              bottom: MediaQuery.of(context).size.height * 3 / 100),
          child: GlassCard_header(
            header: Header(navigateBack: true, title: "Sign Up"),
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
                              height:
                                  MediaQuery.of(context).size.height * 14 / 100,
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100),
                        ),
                        Text("RE:start",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 6 / 100,
                              color: HexColor("92b2ff"),
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  createLoginField(
                    context: context,
                    controller: email,
                    fieldName: "Email",
                    initialValue: '',
                    obscureText: false,
                  ),
                  createLoginField(
                    context: context,
                    controller: password,
                    fieldName: "Password",
                    initialValue: '',
                    obscureText: true,
                  ),
                  createLoginField(
                    context: context,
                    controller: reenterpw,
                    fieldName: "Re-enter Password",
                    initialValue: '',
                    obscureText: true,
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 100),
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 45 / 100,
                      child: OutlinedButton(
                        onPressed: () async {
                          await auth.signUpWithEmailAndPw(
                              email.text, password.text, reenterpw.text);
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 8 / 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox createLoginField({
    required BuildContext context,
    required TextEditingController controller,
    required String fieldName,
    required String initialValue,
    required bool obscureText,
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
                  keyboardType: TextInputType.name,
                  obscureText: obscureText,
                  onChanged: onChanged,
                  validator: validator)
            ],
          ),
        ));
  }
}
