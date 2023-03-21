import 'package:coinkeeper/screens/homescreen/currencylist.dart';
import 'package:coinkeeper/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class Newincome extends StatefulWidget {
  const Newincome({Key? key,}) : super(key: key);

  @override
  State<Newincome> createState() => _NewincomeState();
}

class _NewincomeState extends State<Newincome> {
  TextEditingController name = TextEditingController();
  TextEditingController accBal = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity.h,
            width: 360.w,
           decoration: const BoxDecoration(
             image: DecorationImage(image: AssetImage(money),fit: BoxFit.cover)
           ),
          ),
          Positioned(
             bottom: 0.h,
            child: Container(
              height: 500.h,
              width: 360.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                  color: Colors.white70,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(70), topRight: Radius.circular(70))),
              child: Column(
                children: [
                  SizedBox(height:20.h),
                  Text(
                    "Where do you keep your money?",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: "text",
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height:10.h),
                  Row(mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close)),
                      SizedBox(width: 200.w,),
                      IconButton(
                          onPressed: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Homepage(
                                    addincomename:name.text,addincomeamt:accBal.text,
                                  ))),
                          icon: const Icon(Icons.done)),
                    ],
                  ),
                  SizedBox(height: 70.h,),
                  SizedBox(
                    width: 250.w,
                    height: 75.h,
                    child: TextField(
                      controller: name,
                      style: TextStyle(fontSize: 15.sp),
                      keyboardType: TextInputType.text,
                      cursorWidth: 1.w,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Enter name",
                          hintStyle: TextStyle(fontSize: 14.sp, fontFamily: "text",color: Colors.black)),
                    ),
                  ),
                  SizedBox(
                    height: 75.h,
                    width: 250.w,
                    child: TextField(
                      controller: accBal,
                      style: TextStyle(fontSize: 15.sp),
                      keyboardType: TextInputType.number,
                      cursorWidth: 1.w,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                          hintText: "Account balance",
                          hintStyle: TextStyle(fontSize: 14.sp, fontFamily: "text",color: Colors.black)),
                    ),
                  ),
                ],),
            ),
          ),
        ],
      ),

    ));
  }
}
