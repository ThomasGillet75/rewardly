import 'package:flutter/material.dart';
import 'package:rewardly/core/color.dart';


class IconFriendButtonWidget extends StatefulWidget {
  const IconFriendButtonWidget({Key? key}) : super(key: key);

  @override
  State<IconFriendButtonWidget> createState() => _AddButtonWidgetState();
}

class _AddButtonWidgetState extends State<IconFriendButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        shadowColor: AppColors.primary.withOpacity(0),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/friends');
      },
      child: const Icon(Icons.person_search  , color: Colors.black),
    );
  }
}