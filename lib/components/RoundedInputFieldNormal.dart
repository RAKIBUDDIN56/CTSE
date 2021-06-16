import 'package:flutter/material.dart';
import 'package:group_chat_app/components/text_field_container.dart';
import 'package:group_chat_app/constants.dart';

class RoundedInputFieldNormal extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputFieldNormal({
    Key key,
    this.hintText,
    this.icon = Icons.child_care_rounded,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
