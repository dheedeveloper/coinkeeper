import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../main.dart';

class Expenselist extends StatefulWidget {
  final expensename;
  final expenseamt;
  final expensefrom;
  final date;
  const Expenselist(
      {Key? key,
      this.expenseamt,
      this.expensename,
      this.expensefrom,
      this.date})
      : super(key: key);

  @override
  State<Expenselist> createState() => _ExpenselistState();
}

class _ExpenselistState extends State<Expenselist> {
  @override
  Widget build(BuildContext context) {
    print(widget.expensefrom);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text(
          "${widget.expensename}",
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
          decoration: const BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(money), fit: BoxFit.cover)),
          child: Container(
              height: double.infinity.h,
              width: double.infinity.w,
              color: Colors.white70,
              child: widget.expenseamt == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100.h,
                        ),
                        Text(
                          "To add an expense, drag the coin",
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
                          child: Container(height:90.h,width:300.w,decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(20),border:Border.all()
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h,),
                            Text(
                              widget.date,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: "text",
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700),
                            ),
                              SizedBox(height: 3.h,),
                            Divider(color: Colors.black,thickness: 1.w,),
                            ListTile(
                              title: Text(
                                "${widget.expensefrom}",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: "text",
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700),
                              ),
                              trailing: Text(
                                "Rs ${widget.expenseamt}",
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
