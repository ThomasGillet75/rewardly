import 'package:flutter/material.dart';
import '../../../Data/models/user.dart';
import '../../../core/color.dart';

class FriendCard extends StatefulWidget {
  const FriendCard({Key? key, required this.user}) : super(key: key);
  final Users user;

  @override
  State<FriendCard> createState() => _FriendCardState();
}
/*
* This is the state class for the FriendCard widget
 */
class _FriendCardState extends State<FriendCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.user.pseudo,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Add your delete logic here
            },
          ),
        ],
      ),
    );
  }
}