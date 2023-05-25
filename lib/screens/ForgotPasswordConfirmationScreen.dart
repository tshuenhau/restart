import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/LoginScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard_header.dart';
import 'package:restart/widgets/Glasscards/Header.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';

class ForgotPasswordConfirmationScreen extends StatelessWidget {
  ForgotPasswordConfirmationScreen({required this.email, Key? key})
      : super(key: key);
  AuthController auth = Get.find();
  late String email;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Center(
      child: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 1.5 / 100,
              bottom: MediaQuery.of(context).size.height * 3 / 100),
          child: GlassCard_header(
            header: Header(title: "Forgot your password?"),
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
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 15 / 100,
                    child: Center(
                      child: AutoSizeText(
                          "Check your email to reset your password.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 100),
                  Align(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 45 / 100,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.offAll(LoginScreen());
                          },
                          child: AutoSizeText("Continue")),
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 2 / 100),
                  Text("Didn't receive the reset password link?"),
                  InkWell(
                    onTap: () async {
                      await auth.sendResetPasswordEmail(email);
                    },
                    child: Text("Click here to resend.",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor)),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 8 / 100),
                ],
              ),
            ),
          )),
    ));
  }
}
