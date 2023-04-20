import 'package:coinkeeper/main.dart';
import 'package:coinkeeper/utility/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Transperant extends StatefulWidget {
  const Transperant({Key? key}) : super(key: key);

  @override
  State<Transperant> createState() => _TransperantState();
}

class _TransperantState extends State<Transperant> with CustomTextStyle{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height:180.h),
          Center(
            child: Container(
              height: 0.24.sh,
              width: 200.w,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      image: AssetImage(transparent), fit: BoxFit.cover)),
            ),
          ),
          SizedBox(height: 20.h),
          showTitleText("Transparent"),
          SizedBox(height: 20.h),
          showSubText("CoinKeeper will show you what you spend money on and will teach you to set them apart")
        ],
      ),
    ));
  }
}
