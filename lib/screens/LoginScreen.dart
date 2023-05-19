import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/App.dart';
import 'package:restart/screens/SetDetailsScreen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController auth = Get.put(AuthController());
    return CustomScaffold(
        body: GlassCard(
            height: MediaQuery.of(context).size.height * 85 / 100,
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
                          colorFilter:
                              ColorFilter.mode(Colors.black, BlendMode.srcATop),
                          child: Image.asset("assets/images/logo_white.png",
                              fit: BoxFit.cover,
                              height:
                                  MediaQuery.of(context).size.height * 18 / 100,
                              width:
                                  MediaQuery.of(context).size.width * 30 / 100),
                        ),
                        Text("RE:start",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 8 / 100,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 5 / 100),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      await auth.loginWithGoogle();
                      if (auth.state.value == AuthState.LOGGEDIN) {
                        if (auth.setDetails.value) {
                          Get.to(const SetDetailsScreen());
                        } else {
                          Get.to(const App());
                        }
                      }
                    },
                  ),
                  SignInButton(
                    Buttons.Apple,
                    onPressed: () async {
                      await auth.loginWithApple();
                    },
                  ),
                  // SignInButton(
                  //   Buttons.FacebookNew,
                  //   onPressed: () async {
                  //     await auth.loginWithFacebook();
                  //   },
                  // ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 10 / 100),
                  Text("Recycling made Fun, Easy, and Rewarding",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 5 / 100,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 8 / 100),
                ])));
  }
}
