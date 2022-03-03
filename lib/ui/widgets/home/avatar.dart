import 'package:chat_app/ui/widgets/home/online_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Avatar extends StatelessWidget {
  final String imageUrl;
  final bool isOnline;

  const Avatar({Key? key, required this.imageUrl, required this.isOnline})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Stack(fit: StackFit.expand, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(126),
              child: SvgPicture.network(imageUrl,
                  width: 126, height: 126, fit: BoxFit.fill)),
          Align(
              alignment: Alignment.topRight,
              child: isOnline ? const OnlineIndicator() : Container())
        ]));
  }
}
