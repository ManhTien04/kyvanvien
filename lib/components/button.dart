import 'package:flutter/material.dart';
import 'package:kyvanvien/theme/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: titleColor,
            borderRadius: BorderRadius.circular(60),
        ),
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //text
            Text(
                text,
                style: TextStyle(color: primaryColor),
            ),
      
            const SizedBox(width: 10),
      
            //icon
            Icon(Icons.arrow_forward, color: primaryColor,)
          ],
        ),
      ),
    );
  }
}
