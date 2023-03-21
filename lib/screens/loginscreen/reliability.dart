import 'package:coinkeeper/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Reliability extends StatefulWidget {
  const Reliability({Key? key}) : super(key: key);

  @override
  State<Reliability> createState() => _ReliabilityState();
}

class _ReliabilityState extends State<Reliability> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(children:  [
        SizedBox(height:180.h),
        Center(
          child: Container(height: 180.h,width:200.w,decoration: const BoxDecoration(color: Colors.white,
              image: DecorationImage(image: AssetImage(reliable),fit: BoxFit.cover)
          ),),
        ),
        SizedBox(height: 20.h),
        Text(
          "Reliability",
          style: TextStyle(fontSize: 25.sp, fontFamily: "style"),
        ),
        SizedBox(height: 20.h),
        Text(
          "CoinKeeper encrypts your data and protects them",
          style: TextStyle(fontSize: 13.5.sp, fontFamily: "style"),
        ),
        Text(
          "from being lost",
          style: TextStyle(fontSize: 13.5.sp, fontFamily: "style"),
        )
      ],),
    ));
  }
}
