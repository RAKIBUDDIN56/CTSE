import 'package:flutter/material.dart';
import 'package:group_chat_app/components/text_field_container.dart';
import 'package:group_chat_app/constants.dart';

class RoundedInputFieldMobile extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  const RoundedInputFieldMobile({
    Key key,
    this.hintText,
    this.icon = Icons.send_to_mobile,
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
