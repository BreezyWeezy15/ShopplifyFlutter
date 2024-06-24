import 'package:flutter/material.dart';
import 'package:furniture_flutter_app/utils.dart';

class CustomEdit extends StatelessWidget {
  final String? hint;
  final IconData? iconData;
  final TextEditingController? textEditingController;
  const CustomEdit({super.key, required this.hint,required this.iconData,required this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
      child: TextField(
        controller: textEditingController,
        style: getArimoBold(),
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            hintText: hint,
            suffixIcon: Icon(iconData)
        ),
      ),
    );
  }
}
