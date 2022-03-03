import 'package:chat_app/colors.dart';
import 'package:chat_app/theme.dart';
import 'package:chat_app/ui/widgets/home/avatar.dart';
import 'package:flutter/material.dart';

class Chats extends StatefulWidget {
  Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  _chatItem() => ListTile(
      leading: const Avatar(
          imageUrl: "https://avatars.dicebear.com/api/human/dihgdldf.svg",
          isOnline: true),
      title: Text('Lisa',
          style: Theme.of(context).textTheme.subtitle2?.copyWith(
              fontWeight: FontWeight.bold,
              color: isLightTheme(context) ? Colors.black : Colors.white)),
      subtitle: Text(
          'This is a message very long which will fill my entire container.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: Theme.of(context).textTheme.overline?.copyWith(
              color: isLightTheme(context) ? Colors.black54 : Colors.white70)),
      trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('12pm',
                style: Theme.of(context).textTheme.overline?.copyWith(
                    color: isLightTheme(context)
                        ? Colors.black54
                        : Colors.white70)),
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                        height: 20,
                        width: 20,
                        color: appColor,
                        alignment: Alignment.center,
                        child: Text('2',
                            style: Theme.of(context)
                                .textTheme
                                .overline
                                ?.copyWith(color: Colors.white)))))
          ]));

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (_, index) => _chatItem(),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: 3);
  }
}
