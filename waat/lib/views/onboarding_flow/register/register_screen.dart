import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/globals/widgets/custom_input_field_elevated.dart';

import '../../../screens/MainScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            Center(child: Consumer(builder: (context, ref, child) {
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
                    text: 'REGISTER', //TODO ADD LOCALIZATION
                    onPressed: () async {
                      if (await authVM.signUp(emailController.text, passwordController.text)) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Already have an account? Log in',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }))
          ],
        ),
      )),
    );
  }
}
