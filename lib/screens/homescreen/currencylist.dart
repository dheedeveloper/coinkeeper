import 'package:coinkeeper/main.dart';
import 'package:coinkeeper/screens/homescreen/newincome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'landingpage.dart';

class Currencylist extends StatefulWidget {
  final name ;
  const Currencylist({Key? key,required this.name}) : super(key: key);

  @override
  State<Currencylist> createState() => _CurrencylistState();
}

class _CurrencylistState extends State<Currencylist> {

  List country = ["INR", "USD", "EUR", "BTC", "SGD","RUB","AED","ALL","AUD"];
  List name = [
    "Indian rupee",
    "United states doller",
    "Euro",
    "Bitcoin",
    "Singapore doller",
    "Russian ruble",
    "United arab emirates dirham",
    "Albenian lek",
    "Australian doller",
  ];
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 400.h,
      width: 300.w,
      child: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              name[index],
              style: TextStyle(
                  fontSize: 17.sp, fontFamily: "text", color: Colors.black),
            ),
            trailing: Text(
              country[index],
              style: TextStyle(
                  fontSize: 17.sp, fontFamily: "text", color: Colors.black),
            ),
            onTap: () =>widget.name == "" ?Navigator.pushReplacement(
                context,
                SizeAnimatingRoute(page: Landingpage(
                  currency: country[index],
                ))):Navigator.pushReplacement(
                context,SizeAnimatingRoute(page: Newincome(
             // currency: country[index],
            )))
          );
        },
      ),
    );
  }
}
