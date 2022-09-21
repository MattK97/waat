import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:newappc/globals/widgets/custom_action_button.dart';
import 'package:newappc/rest/response/response_status.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/onboarding_flow/role_onboarding/choose_type.dart';

import 'create_team.dart';
import 'join_team.dart';

//TODO ADD LOCALIZATION

class RoleOnboardingScreen extends ConsumerStatefulWidget {
  @override
  _RoleOnboardingScreenState createState() => _RoleOnboardingScreenState();
}

class _RoleOnboardingScreenState extends ConsumerState<RoleOnboardingScreen> {
  PageController _pageController;
  TextEditingController _teamNameController = TextEditingController();
  TextEditingController _teamCodeController = TextEditingController();
  ChosenRole _chosenRole;

  Widget _onboardingImage;

  Widget _onboardingOneImage = Container(
    transform: Matrix4.translationValues(0, 100.0, 0),
    decoration: new BoxDecoration(
      image: new DecorationImage(
          image: new AssetImage('assets/images/onboarding_three.png'), fit: BoxFit.fitWidth),
    ),
  );
  Widget _onboardingTwoImage = Container(
    transform: Matrix4.translationValues(0, 100.0, 0),
    decoration: new BoxDecoration(
      image: new DecorationImage(
          image: new AssetImage('assets/images/onboarding_four.png'), fit: BoxFit.fitWidth),
    ),
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _onboardingImage = _onboardingOneImage;
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _updatePage(0);
        }));
  }

  bool _isButtonDisabled = true;

  void _updatePage(int index) {
    switch (index) {
      case 0:
        setState(() {
          _onboardingImage = _onboardingOneImage;
          _isButtonDisabled = _chosenRole == null;
        });
        break;
      case 1:
        setState(() {
          _onboardingImage = _onboardingTwoImage;
          _isButtonDisabled = _teamCodeController.text.isEmpty;
        });
        break;
      case 2:
        setState(() {
          _onboardingImage = _onboardingTwoImage;
          _isButtonDisabled = _teamNameController.text.isEmpty;
        });
        break;
      default:
        setState(() {
          _onboardingImage = _onboardingOneImage;
          _isButtonDisabled = _chosenRole == null;
        });
    }
  }

  void _chooseTypeCallbackHandler(ChosenRole value) {
    _chosenRole = value;
  }

  void _choseType() {
    if (_chosenRole == ChosenRole.joinTeam) {
      _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
    if (_chosenRole == ChosenRole.createTeam) {
      _pageController.animateToPage(2, duration: Duration(milliseconds: 300), curve: Curves.linear);
    }
  }

  Future<void> _joinTeam() async {
    if (await teamServices
        .joinTeam(_teamCodeController.text)
        .then((value) => value.code == ResponseStatus.valid)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  Future<void> _createFirestoreEntry() async {
    final databaseReference = FirebaseFirestore.instance;
    final chatsRef = await databaseReference.collection('chats').add({});
    await databaseReference.collection('chat_info').doc(chatsRef.id).set({
      'last_message': '',
      'last_message_id': '',
      'last_message_sender_id': '',
      'last_message_timestamp': null,
      'last_message_type': null,
      'read': [],
      'typing': [],
      'users': []..add(ref.read(authServiceViewModel).user.uid)
    });
  }

  Future<void> _createTeam() async {
    final response = await teamServices.createTeam(_teamNameController.text);
    if (response.status.code == ResponseStatus.valid) {
      await _createFirestoreEntry();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) => _updatePage(index),
                          controller: _pageController,
                          children: [
                            ChooseType(
                              chooseTypeCallback: _chooseTypeCallbackHandler,
                              notifyParent: _updatePage,
                              chosenRole: _chosenRole,
                            ),
                            JoinTeam(
                              pageController: _pageController,
                              controller: _teamCodeController,
                              notifyParent: _updatePage,
                            ),
                            CreateTeam(
                              pageController: _pageController,
                              controller: _teamNameController,
                              notifyParent: _updatePage,
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: CustomActionButton(
                                color: null,
                                disabled: _isButtonDisabled,
                                text: 'Next',
                                onPressed: () async {
                                  if (_pageController.page.toInt() == 0)
                                    _choseType();
                                  else if (_pageController.page.toInt() == 1)
                                    _joinTeam();
                                  else if (_pageController.page.toInt() == 2) _createTeam();
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
          )),
    );
  }
}
