import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../main.dart';

class Incomelist extends StatefulWidget {
  final whereto;
  final date;
  final addincome;
  const Incomelist({Key? key, this.whereto, this.date,this.addincome}) : super(key: key);

  @override
  State<Incomelist> createState() => _IncomelistState();
}

class _IncomelistState extends State<Incomelist> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            centerTitle: true,
            title: Text(
              "Income",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "text",
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700),
            ),
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close)),
          ),
          body: Container(
              height: double.infinity.h,
              width: double.infinity.w,
              decoration:  const BoxDecoration(
                  image:
                  DecorationImage(image: AssetImage(money), fit: BoxFit.cover)),
              child: Container(
                  height: double.infinity.h,
                  width: double.infinity.w,
                  color: Colors.white70,
                  child: widget.addincome == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      Text(
                        "To add an income, drag the coin",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "text",
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 90.h,
                      ),
                      Container(
                        height: 180.h,
                        width: 180.h,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(),
                            image: const DecorationImage(
                                image: AssetImage(dragndrop))),
                      ),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        child: Container(height:80.h,width:300.w,decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),border:Border.all()
                        ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widget.date,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "text",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              Divider(color: Colors.black,thickness: 1.w,),
                              ListTile(
                                title: Text(
                                  "${widget.whereto}",
                                  style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontFamily: "text",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                                trailing: Text(
                                  "Rs ${widget.addincome}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: "text",
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],),
                        ),
                      ),

                    ],
                  ))),
        ));
  }
}

class showincomeList{
  final String date;
  final String incometype;
  final String amount;

  showincomeList(this.date, this.incometype, this.amount);
}