import 'package:coinkeeper/main.dart';
import 'package:coinkeeper/utility/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Flexibility extends StatefulWidget {
  const Flexibility({Key? key}) : super(key: key);

  @override
  State<Flexibility> createState() => _FlexibilityState();
}

class _FlexibilityState extends State<Flexibility> with CustomTextStyle{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(children:  [
        SizedBox(height:180.h),
        Center(
          child: Container(height: 180.h,width:200.w,decoration: const BoxDecoration(color: Colors.white,
              image: DecorationImage(image: AssetImage(flexible),fit: BoxFit.cover)
          ),),
        ),
        SizedBox(height: 20.h),
        showTitleText("Flexibility"),
        SizedBox(height: 20.h),
        showSubText("CoinKeeper is easily customizable to your needs")
      ],),
    ));
  }
}
