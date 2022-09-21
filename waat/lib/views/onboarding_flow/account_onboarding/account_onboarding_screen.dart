import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/additional_widgets/page_indicator.dart';
import 'package:newappc/globals/styles/colors.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/globals/widgets/custom_color_picker.dart';
import 'package:newappc/models/ColorM.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/onboarding_flow/account_onboarding/user_credentials.dart';
import 'package:newappc/views/onboarding_flow/role_onboarding/role_onboarding_screen.dart';

//TODO ADD LOCALIZATION
class AccountOnboardingScreen extends StatefulWidget {
  @override
  _AccountOnboardingScreenState createState() => _AccountOnboardingScreenState();
}

class _AccountOnboardingScreenState extends State<AccountOnboardingScreen> {
  Future<List<ColorM>> colorListFuture;
  PageController _pageController;
  TextEditingController _firstNameController;
  String _greetingsContent = ' ';
  String _infoContent = ' ';
  bool _isButtonDisabled = true;
  Widget _onboardingImage;
  ColorM _chosenColor;

  Widget _onboardingOneImage = Container(
    transform: Matrix4.translationValues(0, 100.0, 0),
    decoration: new BoxDecoration(
      image: new DecorationImage(
          image: new AssetImage('assets/images/onboarding_one.png'), fit: BoxFit.fitWidth),
    ),
  );
  Widget _onboardingTwoImage = Container(
    transform: Matrix4.translationValues(0, 100.0, 0),
    decoration: new BoxDecoration(
      image: new DecorationImage(
          image: new AssetImage('assets/images/onboarding_two.png'), fit: BoxFit.fitWidth),
    ),
  );

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _pageController = PageController();
    _onboardingImage = _onboardingOneImage;
    colorListFuture = userServices.fetchColors().then((value) => value.data);
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _updatePage(0);
        }));
  }

  void _updatePage(int index) {
    switch (index) {
      case 0:
        setState(() {
          _greetingsContent = 'Hey !';
          _infoContent = 'First, tell us your name';
          _onboardingImage = _onboardingOneImage;
        });
        break;
      case 1:
        setState(() {
          _greetingsContent = 'Hey ${_firstNameController.text} !';
          _infoContent =
              'Now let’s determine what color you want to identify with, this will help with communication in your group';
          _onboardingImage = _onboardingTwoImage;
        });
        break;
      default:
        setState(() {
          _greetingsContent = 'Hey !';
          _infoContent = 'First, tell us your name';
        });
    }
  }

  void _updateButtonState(String value) {
    setState(() {
      _isButtonDisabled = value.isEmpty;
    });
  }

  void _updateChosenColor(ColorM color) {
    setState(() {
      _chosenColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: FutureBuilder<List<ColorM>>(
              future: colorListFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator(color: primaryTeal));
                return Stack(
                  children: [
                    _onboardingImage,
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AnimatedSize(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 64,
                            ),
                            Text(
                              _greetingsContent,
                              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            PageIndicator(_pageController, 2, Colors.teal[600]),
                            Container(
                              padding: EdgeInsets.only(top: 16, bottom: 16),
                              child: Text(_infoContent),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: PageView(
                                physics: NeverScrollableScrollPhysics(),
                                onPageChanged: (index) => _updatePage(index),
                                controller: _pageController,
                                children: [
                                  UserCredentials(
                                    notifyParent: _updateButtonState,
                                    firstNameController: _firstNameController,
                                  ),
                                  CustomColorPicker(
                                    colorList: snapshot.data,
                                    chosenColor: _chosenColor,
                                    notifyParent: _updateChosenColor,
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomActionButton(
                                      color: _chosenColor == null
                                          ? null
                                          : HexColor(_chosenColor.colorHex),
                                      disabled: _isButtonDisabled,
                                      text: 'Next',
                                      onPressed: () async {
                                        if (_pageController.page.toInt() == 0) {
                                          _pageController.nextPage(
                                              duration: Duration(milliseconds: 300),
                                              curve: Curves.linear);
                                          return;
                                        }
                                        if (_pageController.page.toInt() == 1) {
                                          FocusScope.of(context).unfocus();
                                          if (await userServices
                                              .registerUser(_firstNameController.text, '',
                                                  _chosenColor.colorID)
                                              .then(
                                                  (value) => value.code == ResponseStatus.valid)) {
                                            await userServices.checkToken(
                                                await FirebaseMessaging.instance.getToken());
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => RoleOnboardingScreen()),
                                            );
                                          }
                                        }
                                      }),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 32,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              })),
    );
  }
}
