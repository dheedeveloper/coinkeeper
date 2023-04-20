import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import 'homepage.dart';

class Addincome extends StatefulWidget {
  final whereto;
  final initamt;
  const Addincome({Key? key, this.whereto, this.initamt}) : super(key: key);

  @override
  State<Addincome> createState() => _AddincomeState();
}

class _AddincomeState extends State<Addincome> {
  TextEditingController amount = TextEditingController();
  DateTime dateTime = DateTime.now();
  void date() {
    showDatePicker(
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime(2050),
            context: context)
        .then((value) => setState(() {
              dateTime = value!;
            }));
  }

  @override
  Widget build(BuildContext context) {
    String format = DateFormat.MMMMEEEEd().format(dateTime);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          "Income -) ${widget.whereto}",
          style: TextStyle(
              color: Colors.white,
              fontFamily: "text",
              fontSize: 15.sp,
              fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close)),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       amount.text.isNotEmpty
          //           ? Navigator.pushReplacement(
          //               context, SizeAnimatingRoute(page: Homepage(
          //         addincomelistamt: int.parse(widget.initamt)+int.parse(amount.text),
          //         addincome: amount.text,addincomedate: format.toString(),
          //       )))
          //           : showDialog(
          //               context: context,
          //               builder: (context) => AlertDialog(
          //                   title: const Text("Enter your amount"),
          //                   actions: [
          //                     TextButton(
          //                         onPressed: () => Navigator.pop(context),
          //                         child: const Text("Ok"))
          //                   ]),
          //             );
          //     },
          //     //ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter the amount"))),
          //     icon: const Icon(Icons.done))
        ],
      ),
      body: InkWell(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            height: double.infinity.h,
            width: double.infinity.w,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(money), fit: BoxFit.cover)),
            child: Container(
                height: double.infinity.h,
                width: double.infinity.w,
                color: Colors.white70,
                child: Column(
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "text",
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500),
                        autofocus: true,
                        cursorColor: Colors.black,
                        controller: amount,
                        decoration: InputDecoration(
                            hintText: "Enter amount",
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: "text",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                    SizedBox(height: 60.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                fixedSize: Size(120.w, 30.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: BorderSide(color: Colors.black))),
                            onPressed: () {},
                            child: Text(
                              "Today",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "text",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                fixedSize: Size(90.w, 30.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side:
                                        const BorderSide(color: Colors.black))),
                            onPressed: () => date(),
                            child: const Icon(Icons.date_range)),
                      ],
                    ),
                  ],
                ))),
      ),
    ));
  }
}
