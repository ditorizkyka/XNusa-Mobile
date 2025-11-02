import 'package:xnusa_mobile/constant/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypographyApp {
  static TextStyle headline1 = TextStyle(
    fontFamily: GoogleFonts.nunito().fontFamily,
    fontSize: 26.sp,
    fontWeight: FontWeight.w700,
    color: ColorApp.black,
  );

  static TextStyle text1 = TextStyle(
    fontFamily: GoogleFonts.rubik().fontFamily,
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: ColorApp.darkGrey,
  );
}
