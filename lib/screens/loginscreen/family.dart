import 'package:coinkeeper/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Family extends StatefulWidget {
  const Family({Key? key}) : super(key: key);

  @override
  State<Family> createState() => _FamilyState();
}

class _FamilyState extends State<Family> {
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
        Text(
          "Family finance",
          style: TextStyle(fontSize: 25.sp, fontFamily: "style"),
        ),
        SizedBox(height: 20.h),
        Text(
          "You can use coinkeeper on various devices together with",
          style: TextStyle(fontSize: 13.5.sp, fontFamily: "style"),
        ),
        Text(
          "the members of your family",
          style: TextStyle(fontSize: 13.5.sp, fontFamily: "style"),
        )
      ],),
    ));
  }
}
