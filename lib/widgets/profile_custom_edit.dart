import 'package:flutter/material.dart';
import 'package:furniture_flutter_app/utils.dart';

class ProfileCustomEdit extends StatelessWidget {
  final bool? isEnabled;
  final String? hint;
  final IconData? iconData;
  final TextEditingController? textEditingController;
  const ProfileCustomEdit({super.key,required this.isEnabled, required this.hint,
    required this.iconData,required this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      child: TextField(
        controller: textEditingController,
        style: getArimoBold(),
        enabled: isEnabled,
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            contentPadding: const EdgeInsets.symmetric(vertical: 15,horizontal: 15),
            hintText: hint,
            suffixIcon: Icon(iconData)
        ),
      ),
    );
  }
}
