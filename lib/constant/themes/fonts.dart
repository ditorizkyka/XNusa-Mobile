import 'package:xnusa_mobile/constant/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TypographyApp {
  //General

  static TextStyle headline1 = TextStyle(
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
    fontSize: 26.sp,
    fontWeight: FontWeight.bold,
    color: ColorApp.primary,
  );

  static TextStyle label = TextStyle(
    fontFamily: GoogleFonts.inter().fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorApp.primary,
  );

  static TextStyle textLight = TextStyle(
    fontFamily: GoogleFonts.inter().fontFamily,
    fontSize: 12.sp,
    fontWeight: FontWeight.w400,
    color: ColorApp.white,
  );

  // Chat
  static TextStyle chatHeadline1 = TextStyle(
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: ColorApp.primary,
  );

  static TextStyle chatHeadline2 = TextStyle(
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: ColorApp.primary,
  );

  static TextStyle chatHeadline3 = TextStyle(
    fontFamily: GoogleFonts.poppins(fontWeight: FontWeight.bold).fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: ColorApp.primary,
  );

  static TextStyle chatTextDark = TextStyle(
    fontFamily: GoogleFonts.inter().fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: ColorApp.primary,
  );
}
