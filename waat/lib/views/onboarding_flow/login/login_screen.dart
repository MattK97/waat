import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/globals/widgets/custom_input_field_elevated.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/onboarding_flow/login/provider_wiget.dart';
import 'package:newappc/views/onboarding_flow/register/register_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController;
  TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          body: Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              alignment: Alignment.bottomCenter,
              image: new AssetImage('assets/images/login_register_background.png'),
              fit: BoxFit.fitWidth),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 80,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 8,
              child: Image.asset('assets/images/waat_logo_400.png'),
            ),
            SizedBox(
              height: 60,
            ),
            Consumer(builder: (context, ref, child) {
              final authVM = ref.watch(authServiceViewModel);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomInputFieldElevated(
                    textEditingController: emailController,
                    fieldName: 'Email',
                    obscureText: false,
                    maxLines: 1,
                    icon: CupertinoIcons.person_alt,
                  ),
                  CustomInputFieldElevated(
                      textEditingController: passwordController,
                      fieldName: 'Password',
                      obscureText: true,
                      maxLines: 1,
                      icon: CupertinoIcons.lock),
                  CustomActionButton(
                    text: 'LOGIN', //TODO ADD LOCALIZATION
                    onPressed: () {
                      authVM.signIn(emailController.text, passwordController.text);
                    },
                  ),
                  Center(
                    child: Text(
                      'Forgot your password ?',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ProviderWidget(
                        fileName: 'logo_google.png',
                      ),
                      ProviderWidget(
                        fileName: 'logo_facebook.png',
                      ),
                      ProviderWidget(
                        fileName: 'logo_apple.png',
                      )
                    ],
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(CupertinoPageRoute(builder: (context) => RegisterScreen()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No account? Create one',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      )),
    );
  }
}
