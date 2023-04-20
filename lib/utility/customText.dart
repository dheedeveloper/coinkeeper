import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';



mixin CustomTextStyle{


  showSubText(String text){
    return Text(text,style: GoogleFonts.openSans(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
    ),textAlign: TextAlign.center,);
  }

  showTitleText(String text){
    return Text(text,style: GoogleFonts.openSans(
      fontSize: 24.sp,
      fontWeight: FontWeight.bold,
    ),textAlign: TextAlign.center,);
  }


}