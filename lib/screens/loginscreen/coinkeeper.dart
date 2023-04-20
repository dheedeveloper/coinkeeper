import 'package:coinkeeper/main.dart';
import 'package:coinkeeper/utility/customText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Coinkeeper extends StatefulWidget {
  const Coinkeeper({Key? key}) : super(key: key);

  @override
  State<Coinkeeper> createState() => _CoinkeeperState();
}

class _CoinkeeperState extends State<Coinkeeper> with CustomTextStyle{
  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Column(children:  [
        SizedBox(height:0.26.sh),
        Center(
          child: Container(height: 180.h,width:200.w,decoration: const BoxDecoration(color: Colors.white,
            image: DecorationImage(image: AssetImage(coinkeeper),fit: BoxFit.fill)
          ),),
        ),
        SizedBox(height: 20.h),
        showTitleText("CoinKeeper"),
        SizedBox(height: 20.h),
        showSubText("CoinKeeper is the most simple and fast way to take care of your finance")
      ],),
    ));
  }
}
