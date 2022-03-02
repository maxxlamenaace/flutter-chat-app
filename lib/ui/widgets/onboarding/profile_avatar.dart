import 'package:chat_app/colors.dart';
import 'package:chat_app/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileAvatar extends StatelessWidget {
  final VoidCallback onUpdateAvatar;
  final String imageUrl;

  const ProfileAvatar({required this.onUpdateAvatar, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 126,
        width: 126,
        child: Material(
            color: isLightTheme(context) ? Colors.white : Colors.black,
            borderRadius: BorderRadius.circular(126),
            child: InkWell(
                borderRadius: BorderRadius.circular(126),
                onTap: () => onUpdateAvatar(),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipOval(
                        child: SvgPicture.network(
                      imageUrl,
                      height: 100,
                    )),
                    Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                            backgroundColor: isLightTheme(context)
                                ? Colors.white
                                : Colors.black,
                            child: Icon(Icons.refresh_rounded,
                                color: appColor, size: 38)))
                  ],
                ))));
  }
}
