//
// import 'package:coinkeeper/main.dart';
// import 'package:coinkeeper/screens/homescreen/currencylist.dart';
// import 'package:coinkeeper/screens/homescreen/homepage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class Landingpage extends StatefulWidget {
//   final currency;
//   const Landingpage({Key? key, this.currency}) : super(key: key);
//
//   @override
//   State<Landingpage> createState() => _LandingpageState();
// }
//
// class _LandingpageState extends State<Landingpage> {
//
//   TextEditingController wallet = TextEditingController();
//   TextEditingController bankacc = TextEditingController();
//   List dummyList = ["0","0","0","0","0","0","0",];
//
//   settingdatatoLocal(data1,data2)async{
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setStringList("wallet",data1);
//     prefs.setInt("totalamt",data2);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(resizeToAvoidBottomInset: false,
//         body:
//             InkWell(onTap: () => FocusScope.of(context).unfocus(),
//               child: Container(
//                 height: double.infinity.h,
//                 width: double.infinity.w,
//                 decoration: const BoxDecoration(
//                     image: DecorationImage(
//                         image: AssetImage(money), fit: BoxFit.cover)),
//                 child: Column(children: [
//                   Spacer(),
//                   Container(
//                     height: 550.h,
//                     width: 360.w,
//                     decoration:  BoxDecoration(
//                         border: Border.all(),
//                         //  image: DecorationImage(image: AssetImage(coin),fit: BoxFit.cover),
//                         color: Colors.white70,
//                         borderRadius: const BorderRadius.only(
//                             topRight: Radius.circular(50),
//                             topLeft: Radius.circular(50))),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 30.h,
//                         ),
//                         Text(
//                           "ENTER THE AMOUNT OF MONEY",
//                           style: TextStyle(
//                               fontFamily: "text",
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w700),
//                         ),
//                         Text(
//                           "YOU HAVE NOW",
//                           style: TextStyle(
//                               fontFamily: "text",
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w700),
//                         ),
//                         SizedBox(
//                           height: 30.h,
//                         ),
//                         GestureDetector(
//                             onTap: () => showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return AlertDialog(
//                                   shape: RoundedRectangleBorder(
//                                       side: BorderSide(
//                                           color: Colors.teal, width: 2.w),
//                                       borderRadius: BorderRadius.circular(30)),
//                                   title: Center(
//                                     child: Text(
//                                       "CHOOSE CURRENCY",
//                                       style: TextStyle(
//                                           fontFamily: "text",
//                                           fontSize: 15.sp,
//                                           fontWeight: FontWeight.w700),
//                                     ),
//                                   ),
//                                   content: const Currencylist(
//                                     name: "",
//                                   ),
//                                 );
//                               },
//                             ),
//                             child: Container(
//                               height: 50.h,
//                               width: 170.h,
//                               decoration: BoxDecoration(
//                                   color: Colors.teal,
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all()),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     "Select Currency",
//                                     style: TextStyle(
//                                         fontFamily: "text",
//                                         color: Colors.white,
//                                         fontSize: 14.sp,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   Text(
//                                     widget.currency == ""
//                                         ? "(INR)"
//                                         : "(${widget.currency})",
//                                     style: TextStyle(
//                                         fontFamily: "text",
//                                         color: Colors.white,
//                                         fontSize: 17.sp,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                 ],
//                               ),
//                             )),
//                         SizedBox(
//                           height: 50.h,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 26.w),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: 56.h,
//                                 width: 56.h,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.teal.shade400,
//                                     border: Border.all()),
//                                 child: const Icon(
//                                   Icons.wallet,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(width: 20.w),
//                               Text(
//                                 "Wallet",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontFamily: "text",
//                                     fontSize: 17.sp,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                               Spacer(),
//                               SizedBox(
//                                 width: 50.w,
//                                 child: TextField(
//                                   controller: wallet,
//                                   style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600),
//                                   keyboardType: TextInputType.number,
//                                   cursorWidth: 1.w,
//                                   cursorColor: Colors.black,
//                                   decoration: InputDecoration(
//                                       focusedBorder: InputBorder.none,
//                                       enabledBorder: InputBorder.none,
//                                       hintText: "0",
//                                       hintStyle: TextStyle(
//                                           fontSize: 16.sp, fontFamily: "text")),
//                                 ),
//                               ),
//                               Text(
//                                 widget.currency == "" ? "INR" : widget.currency,
//                                 style: TextStyle(
//                                     color: Colors.blueGrey,
//                                     fontFamily: "text",
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 30.h),
//                         Padding(
//                           padding: EdgeInsets.symmetric(horizontal: 26.w),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: 56.h,
//                                 width: 56.h,
//                                 decoration: BoxDecoration(
//                                     shape: BoxShape.circle,
//                                     color: Colors.teal.shade400,
//                                     border: Border.all()),
//                                 child: const Icon(
//                                   Icons.account_balance_outlined,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               SizedBox(width: 20.w),
//                               Text(
//                                 "Bank account",
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontFamily: "text",
//                                     fontSize: 17.sp,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                               const Spacer(),
//                               SizedBox(
//                                 width: 50.w,
//                                 child: TextField(
//                                   style: TextStyle(fontSize: 16.sp,fontWeight: FontWeight.w600),
//                                   controller: bankacc,
//                                   keyboardType: TextInputType.number,
//                                   cursorWidth: 1.w,
//                                   cursorColor: Colors.black,
//                                   decoration: InputDecoration(
//                                       focusedBorder: InputBorder.none,
//                                       enabledBorder: InputBorder.none,
//                                       hintText: "0",
//                                       hintStyle: TextStyle(
//                                           fontSize: 15.sp, fontFamily: "text")),
//                                 ),
//                               ),
//                               Text(
//                                 widget.currency == "" ? "INR" : widget.currency,
//                                 style: TextStyle(
//                                     color: Colors.blueGrey,
//                                     fontFamily: "text",
//                                     fontSize: 15.sp,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Spacer(),
//                         ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.teal,
//                               fixedSize: Size(150.w, 37.h),
//                               shape: RoundedRectangleBorder(
//                                   side: BorderSide(color: Colors.black),
//                                   borderRadius: BorderRadius.circular(10))),
//                           onPressed: ()async{
//                             if (wallet.text.isEmpty || bankacc.text.isEmpty) {
//                               showDialog(context: context, builder: (context) => AlertDialog(
//                                 title: Center(
//                                   child: Text(
//                                   "NOTE",
//                                   style: TextStyle(
//                                       color: Colors.blueGrey,
//                                       fontFamily: "text",
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.w500),
//                               ),
//                                 ),
//                                 content: Text(
//                                   "Kindly enter the amount of Wallet & Bank account",
//                                   style: TextStyle(
//                                     height: 1.5.w,
//                                       color: Colors.black,
//                                       fontFamily: "text",
//                                       fontSize: 15.sp,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ),);
//                             } else {
//                               settingdatatoLocal([wallet.text,bankacc.text], (int.parse(wallet.text)+int.parse(bankacc.text)));
//                               Navigator.pushReplacement(
//                                   context, SizeAnimatingRoute(page:const Homepage(
//                                 // walletamt:[wallet.text,bankacc.text],
//                                 // totalincome: (int.parse(wallet.text)+int.parse(bankacc.text)),
//                               ) ));
//                             }
//                           },
//                           child: Text(
//                             "NEXT",
//                             style: TextStyle(
//                                 fontFamily: "text",
//                                 fontSize: 15.sp,
//                                 letterSpacing: 2.w,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                         ),
//                         SizedBox(height: 100.h)
//                       ],
//                     ),
//                   )
//                 ],),
//               ),
//             ),
//
//
//       ),
//     );
//   }
//
//   //  CurrencyList() {
//   //   return SizedBox(
//   //     height: 300.h,
//   //     width: 300.w,
//   //     child: ListView.builder(
//   //       itemCount: name.length,
//   //       itemBuilder: (context, index) {
//   //         return ListTile(
//   //           title: Text(
//   //             name[index],
//   //             style: TextStyle(
//   //                 fontSize: 17.sp, fontFamily: "text", color: Colors.black),
//   //           ),
//   //           trailing: Text(
//   //             country[index],
//   //             style: TextStyle(
//   //                 fontSize: 17.sp, fontFamily: "text", color: Colors.black),
//   //           ),
//   //           onTap: () => Navigator.pushReplacement(
//   //               context,
//   //               MaterialPageRoute(
//   //                   builder: (context) => Landingpage(
//   //                         currency: country[index],
//   //                       ))),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }
// }
