import 'package:coinkeeper/screens/homescreen/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'package:intl/intl.dart';

class Addexpense extends StatefulWidget {
  final incomename;
  final whereto;
  final constamt;
  const Addexpense({Key? key, this.incomename, this.whereto,  this.constamt}) : super(key: key);

  @override
  State<Addexpense> createState() => _AddexpenseState();
}

class _AddexpenseState extends State<Addexpense> {
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

  DateTime dateTime = DateTime.now();

  TextEditingController amount = TextEditingController();
  var walletAmt;
  gettingdatafromLocal()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    walletAmt = prefs.getStringList("wallet");
    print("list : ${walletAmt}");
  }
  @override
  void initState() {
    gettingdatafromLocal();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.incomename);
    String format = DateFormat.MMMMEEEEd().format(dateTime);
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          "${widget.incomename} -) ${widget.whereto}",
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
          //     amount.text.isNotEmpty
          //         ? Navigator.pushReplacement(
          //             context,
          //             SizeAnimatingRoute(
          //                 page: Homepage(
          //                   expenselistname:widget.incomename,
          //               date: format.toString(),
          //               updateamt: amount.text,
          //              // walletamt: "10",
          //             )))
          //         : showDialog(
          //             context: context,
          //             builder: (context) => AlertDialog(
          //                 title: const Text("Enter your amount"),
          //                 actions: [
          //                   TextButton(
          //                       onPressed: () => Navigator.pop(context),
          //                       child: const Text("Ok"))
          //                 ]),
          //           );},
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
                    )
                  ],
                ))),
      ),
    ));
  }
}
