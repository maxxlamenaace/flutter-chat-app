import 'package:chat_app/colors.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';

class ProfileUpload extends StatelessWidget {
  const ProfileUpload({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 126,
        width: 126,
        child: Material(
            color:
                isLightTheme(context) ? Color(0xFFF2F2F2) : Color(0xFFF2F2F2),
            borderRadius: BorderRadius.circular(126),
            child: InkWell(
                borderRadius: BorderRadius.circular(126),
                onTap: () {},
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.add_a_photo_outlined,
                          size: 50,
                          color:
                              isLightTheme(context) ? iconLight : Colors.black),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                            backgroundColor: isLightTheme(context)
                                ? Colors.white
                                : Colors.black,
                            child: Icon(Icons.add_circle_rounded,
                                color: appColor, size: 38)))
                  ],
                ))));
  }
}
