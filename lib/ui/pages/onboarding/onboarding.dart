import 'package:chat_app/ui/widgets/common/custom_text_field.dart';
import 'package:chat_app/ui/widgets/onboarding/logo.dart';
import 'package:chat_app/ui/widgets/onboarding/profile_upload.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/colors.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  _logo() {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Logo(),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
              _logo(),
              Spacer(),
              ProfileUpload(),
              Spacer(flex: 1),
              Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: CustomTextField(
                    hint: 'What is your name?',
                    height: 45.0,
                    onChanged: (value) {},
                    inputAction: TextInputAction.done,
                  )),
              SizedBox(height: 30),
              Padding(
                  padding: EdgeInsets.only(left: 25, right: 25),
                  child: ElevatedButton(
                      onPressed: () {},
                      child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          child: Text('Let\'s chat!',
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  ?.copyWith(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))),
                      style: ElevatedButton.styleFrom(
                          primary: appColor,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45))))),
              Spacer(flex: 2)

              // CustomTextField()
            ])));
  }
}
