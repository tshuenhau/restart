import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:restart/controllers/AuthController.dart';
import 'package:get/get.dart';
import 'package:restart/controllers/UserController.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';
import 'package:restart/widgets/layout/CustomScaffold.dart';
import 'package:restart/App.dart';
import 'package:restart/screens/SetDetailsScreen.dart';
import 'package:restart/screens/SignUpScreen.dart';

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
              height: MediaQuery.of(context).size.height * 35 / 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ColorFiltered(
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).primaryColor, BlendMode.srcATop),
                    child: Image.asset("assets/images/logo_white.png",
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 18 / 100,
                        width: MediaQuery.of(context).size.width * 30 / 100),
                  ),
                  Text("RE:start",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 8 / 100,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                  // SizedBox(
                  //     height: MediaQuery.of(context).size.height * 2 / 100),
                  // Text("Recycling made Fun, Easy, and Rewarding",
                  //     textAlign: TextAlign.center,
                  //     style: TextStyle(
                  //       fontSize: MediaQuery.of(context).size.width * 4 / 100,
                  //       color: Colors.black,
                  //       fontWeight: FontWeight.bold,
                  //     )),
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
            SizedBox(height: MediaQuery.of(context).size.height * 2 / 100),
            Align(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 45 / 100,
                child: OutlinedButton(
                  onPressed: () async {
                    await auth.signInWithEmailAndPw(email.text, password.text);
                    if (auth.state.value == AuthState.LOGGEDIN &&
                        auth.setDetails.value) {
                      Get.to(const SetDetailsScreen());
                    } else if (auth.state.value == AuthState.LOGGEDOUT) {
                    } else {
                      Get.to(const App());
                    }
                  },
                  child: Text(
                    "Log In",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 5 / 100),
            Text("Don't have an account?"),
            InkWell(
                onTap: () {
                  Get.to(SignUpScreen());
                },
                child: Text('Sign up!',
                    style: TextStyle(decoration: TextDecoration.underline))),
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

            SizedBox(height: MediaQuery.of(context).size.height * 8 / 100),
          ],
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
                  autofocus: true,
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
