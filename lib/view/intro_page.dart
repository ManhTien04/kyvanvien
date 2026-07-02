import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kyvanvien/components/button.dart';
import 'package:kyvanvien/theme/colors.dart';

class IntroPage extends StatelessWidget {
  const IntroPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 25,),

          // shop name
          Text(
            "Kỳ Văn Viện",
            style: GoogleFonts.dmSerifDisplay(
                fontSize: 28,
                color: titleColor,
            ),
          ),

          const SizedBox(height: 25,),

          // icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Image.asset('lib/images/Untitled-1.png'),
          ),

            const SizedBox(height: 25,),

          // title
            Text(
              "TIỂU THUYẾT CỦA RIÊNG BẠN",
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 48,
                color: titleColor,
              ),
            ),

            const SizedBox(height: 10,),

          // subtible
            Text(
                "Những câu truyện hấp dẫn",
                style: TextStyle(
                  color: extracolor,
                  height: 2,
                ),
            ),

            const SizedBox(height: 25,),

          // get started button
            MyButton(
              text: "BẮT ĐẦU",
              onTap: () {
                //go to menu page
                Navigator.pushNamed(context, '/menupage');
              },
            )
        ],
        ),
      ),
    );
  }
}