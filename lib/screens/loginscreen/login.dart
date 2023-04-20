import 'package:coinkeeper/screens/homescreen/homepage.dart';
import 'package:coinkeeper/screens/homescreen/landingpage.dart';
import 'package:coinkeeper/screens/loginscreen/coinkeeper.dart';
import 'package:coinkeeper/screens/loginscreen/sign_in_screen.dart';
import 'package:coinkeeper/utility/google_auth.dart';
import 'package:coinkeeper/utility/storage_service.dart';
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

  String userUid="";
  Future<void> getToken()async{
    final String storageToken= await StorageService().getUserId("uid");
    setState(()  {
      userUid=storageToken.toString();
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                SizedBox(
                  height: 0.72.sh,
                  child: PageView(
                    onPageChanged: (value){
                      setState(() {
                        initialIndex=value;
                      });
                    },
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
                initialIndex < 4?
                GestureDetector(
                  onTap: (){
                    if(initialIndex < 4){
                      controller.nextPage(duration: Duration(milliseconds: 330), curve: Curves.linear);
                    }

                  },
                  child:Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      color: Colors.tealAccent
                    ),
                    child:Icon(Icons.arrow_forward_ios,color: Colors.white,)
                  ),
                )
                :GestureDetector(
                  onTap: (){
                    if(userUid==""){
                      Authentication.signInWithGoogle(
                          context: context);
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Homepage()));
                    }

                  },
                    child:Image.asset("assets/images/google.png",height: 50,width: 50,)),
                // TextButton(
                //   child: Text(
                 //     "Go",
                //     style: TextStyle(
                //         fontSize: 16.sp,
                //         color: Colors.teal,
                //         letterSpacing: 3.w),
                //   ),
                //   onPressed: ()  {
                //     controller.nextPage(duration: Duration(seconds: 1), curve: Curves.linear);
                //   },
                // ),
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
