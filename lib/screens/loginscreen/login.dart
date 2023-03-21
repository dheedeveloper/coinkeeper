import 'package:coinkeeper/screens/homescreen/landingpage.dart';
import 'package:coinkeeper/screens/loginscreen/coinkeeper.dart';
import 'package:flutter/material.dart';
import 'package:coinkeeper/screens/loginscreen/family.dart';
import 'package:coinkeeper/screens/loginscreen/flexibility.dart';
import 'package:coinkeeper/screens/loginscreen/reliability.dart';
import 'package:coinkeeper/screens/loginscreen/transparent.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../main.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({Key? key}) : super(key: key);

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  PageController controller = PageController();
  int initialIndex = 0;
  dotChange() {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(
                  height: 500.h,
                  child: PageView(
                    controller: controller,
                    children: const [
                      Coinkeeper(),
                      Transperant(),
                      Family(),
                      Flexibility(),
                      Reliability()
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                SmoothPageIndicator(
                    onDotClicked: (index) {
                      print("object");
                      setState(() {
                        initialIndex = index;
                      });
                    },
                    effect: const JumpingDotEffect(),
                    controller: controller,
                    count: 5),
                const Spacer(),
                TextButton(
                  child: Text(
                    "SKIP",
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontFamily: "text",
                        color: Colors.teal,
                        letterSpacing: 3.w),
                  ),
                  onPressed: ()  {
                    Navigator.push(context,
                        SizeAnimatingRoute(page: const Landingpage(currency: "",)));
                  },
                ),
                SizedBox(
                  height: 40.h,
                )
              ],
            )));
  }
}

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3))
        .then((value) => Navigator.pushReplacement(context,SizeAnimatingRoute(
      page: const Loginpage(),
    )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      decoration:
          const BoxDecoration(image: DecorationImage(image: AssetImage(logo))),
    )));
  }
}
