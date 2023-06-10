import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:restart/App.dart';
import 'package:restart/Builders/BuilldAuthField.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:restart/screens/SetDetailsScreen.dart';
import 'package:restart/screens/SignUpScreen.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';

import 'ForgotPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthController auth = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Center(
        child: GlassCard(
          height: MediaQuery.of(context).size.height * 85 / 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 30 / 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                            HexColor("92b2ff"), BlendMode.srcATop),
                        child: Image.asset("assets/icons/logo_white.png",
                            fit: BoxFit.cover,
                            height:
                                MediaQuery.of(context).size.height * 12 / 100,
                            width:
                                MediaQuery.of(context).size.width * 18 / 100),
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
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              BuildAuthField(
                  context: context,
                  controller: email,
                  fieldName: "Email",
                  initialValue: '',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  keyboardInputAction: TextInputAction.next),
              BuildAuthField(
                  context: context,
                  controller: password,
                  fieldName: "Password",
                  initialValue: '',
                  obscureText: true,
                  keyboardType: TextInputType.text,
                  keyboardInputAction: TextInputAction.done),

              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              Align(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 45 / 100,
                  child: OutlinedButton(
                    onPressed: () async {
                      await auth.signInWithEmailAndPw(
                          email.text, password.text);
                      if (auth.state.value == AuthState.LOGGEDIN &&
                          auth.setDetails.value) {
                        Get.to(const SetDetailsScreen());
                      } else if (auth.state.value == AuthState.LOGGEDOUT) {
                      } else {
                        Get.to(App());
                      }
                    },
                    child: Text(
                      "Log In",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
              InkWell(
                  onTap: () async {
                    Get.to(ForgotPasswordScreen());
                  },
                  child: Text('Forgot your password?',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor))),
              SizedBox(height: MediaQuery.of(context).size.height * 3 / 100),
              Text("Don't have an account?"),
              InkWell(
                  onTap: () {
                    Get.to(SignUpScreen());
                  },
                  child: Text('Sign up!',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Theme.of(context).primaryColor))),
              SizedBox(
                  height: MediaQuery.of(context).size.height *
                      2 /
                      100), // SignInButton(
              //   Buttons.Google,
              //   onPressed: () async {
              //     await auth.loginWithGoogle();
              //     if (auth.state.value == AuthState.LOGGEDIN) {
              // if (auth.setDetails.value) {
              //   Get.to(const SetDetailsScreen());
              // } else {
              //   Get.to(const App());
              // }
              //     }
              //   },
              // ),
              // SignInButton(
              //   Buttons.Apple,
              //   onPressed: () async {
              //     await auth.loginWithApple();
              //   },
              // ),
              // SignInButton(
              //   Buttons.FacebookNew,
              //   onPressed: () async {
              //     await auth.loginWithFacebook();
              //   },
              // ),

              SizedBox(height: MediaQuery.of(context).size.height * 6 / 100),
            ],
          ),
        ),
      ),
    );
  }
}
