import 'package:coinkeeper/main.dart';
import 'package:coinkeeper/utility/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Family extends StatefulWidget {
  const Family({Key? key}) : super(key: key);

  @override
  State<Family> createState() => _FamilyState();
}

class _FamilyState extends State<Family> with CustomTextStyle{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(children:  [
        SizedBox(height:180.h),
        Center(
          child: Container(height: 180.h,width:200.w,decoration:  const BoxDecoration(color: Colors.white,
              image: DecorationImage(image: AssetImage(family),fit: BoxFit.cover)
          ),),
        ),
        SizedBox(height: 20.h),
        showTitleText("Family finance"),
        SizedBox(height: 20.h),
        showSubText("You can use coinkeeper on various devices together with the members of your family" )
      ],),
    ));
  }
}
