import 'package:coinkeeper/screens/homescreen/homepage.dart';
import 'package:coinkeeper/screens/loginscreen/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  var loginStatus = prefs.getStringList("wallet");
  var totalamt = prefs.getInt("totalamt");
  runApp(MyApp(
    totalamt: totalamt,
    isLogin: loginStatus,
  ));
}

class MyApp extends StatelessWidget {
  final isLogin;
  final totalamt;
  const MyApp({Key? key, this.isLogin, this.totalamt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return  MaterialApp(
         // home:Splashscreen(),
            home: isLogin != null ?  const Homepage() : const Splashscreen(),
            debugShowCheckedModeBanner: false);
      },
    );
  }
}

// ----Asset Images----

const String logo = "assets/images/logo.png";
const String family = "assets/images/familyfinance.webp";
const String flexible = "assets/images/flexibility.jpg";
const String reliable = "assets/images/reliability.jpg";
const String transparent = "assets/images/transper.webp";
const String coinkeeper = "assets/images/coinkeeper.jpg";
const String money = "assets/images/money.jpg";
const String walletimage = "assets/images/wallet.webp";
const String coin = "assets/images/coin.webp";
const String dragndrop = "assets/images/dragndrop.jpg";


class FadeAnimatingRoute extends PageRouteBuilder {
  final Widget? page;
  final Widget route;

  FadeAnimatingRoute({this.page, required this.route})
      : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page!,
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) =>
        FadeTransition(
          opacity: animation,
          child: route,
        ),
  );
}

class SizeAnimatingRoute extends PageRouteBuilder {
  final Widget page;

  SizeAnimatingRoute({required this.page})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
      transitionDuration: (const Duration(milliseconds: 1000)),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn);
        return Align(
          alignment: Alignment.bottomCenter,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: 0,
            child: page,
          ),
        );
      });
}

class ScaleAnimatingRoute extends PageRouteBuilder {
  final Widget page;

  ScaleAnimatingRoute({required this.page})
      : super(
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
      transitionDuration: (const Duration(milliseconds: 1000)),
      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
        animation = CurvedAnimation(parent: animation, curve: Curves.fastLinearToSlowEaseIn);
        return Align(
          alignment: Alignment.bottomCenter,
          child: ScaleTransition(
            scale: animation,
            child: page,
          ),
        );
      });
}

class SlideAnimationRoute extends PageRouteBuilder {
  final Widget page;
  final Widget route;

  SlideAnimationRoute({required this.page, required this.route})
      : super(
    pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) => page,
    transitionDuration: (const Duration(milliseconds: 400)),
    transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
      animation = CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn);
      return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0)).animate(animation),
        child: route,
      );
    },
  );
}