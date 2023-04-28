import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class UserBasedAmountDebit extends StatefulWidget {
  final String title;
  final String roomId;
  final String amount;
  final String docId;
  const UserBasedAmountDebit({Key? key,required this.title,required this.amount,required this.roomId,required this.docId}) : super(key: key);

  @override
  State<UserBasedAmountDebit> createState() => _UserBasedAmountDebitState();
}

class _UserBasedAmountDebitState extends State<UserBasedAmountDebit> {
  CollectionReference userAmountDebit = FirebaseFirestore.instance.collection('Rooms');


  List expenseList=[];
  @override
  void initState() {
    // TODO: implement initState
    userAmountDebit
        .doc(widget.roomId)
        .collection("expense").doc(widget.docId).collection("userAmount")
        .snapshots()
        .listen((event) {
      setState(() {
        expenseList = event.docs;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    List expenseTitle=["Date","User","Amount"];
    List<Expense>expense=[Expense("23", "arun", "34566", "25 Mar,2023"),Expense("21", "vinoth", "346566", "25 Nov,2023"),];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: Colors.black,size: 28.sp,)),
        title: Text("${widget.title} Expense",style: GoogleFonts.openSans(
            color: Colors.black,
            fontWeight: FontWeight.w800,fontSize: 20.sp
        ),),
      ),
     body: SafeArea(child: Column(
       children: [
         SizedBox(height: 20.sp),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
             for(int i=0;i<expenseTitle.length;i++)
               Container(
                 height: 60,
                 width: 0.33.sw,
                 color: Colors.greenAccent.withOpacity(0.6),
                 child: Center(
                   child: Text(expenseTitle[i].toString(),style: GoogleFonts.openSans(
                     fontWeight: FontWeight.w800,fontSize: 14.sp
                   ),),
                 ),
               )
           ],
         ),
         for(int i=0;i<expenseList.length;i++)
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceAround,
           children: [
               Container(
                 height: 60,
                 width: 0.33.sw,
                 child: Center(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Text(expenseList[i]["Date"],style: GoogleFonts.openSans(
                           fontWeight: FontWeight.w800,fontSize: 10.sp.sp
                       ),),
                       Text("Time : ${expenseList[i]["time"]}",style: GoogleFonts.openSans(
                           fontWeight: FontWeight.w800,fontSize: 10.sp.sp,
                         color: Colors.greenAccent.withOpacity(0.8)
                       ),),

                     ],
                   ),
                 ),
               ),
             Container(
               height: 60,
               width: 0.33.sw,
               child: Center(
                 child: Text(expenseList[i]["name"],style: GoogleFonts.openSans(
                     fontWeight: FontWeight.w800,fontSize: 10.sp
                 ),),
               ),
             ),
             Container(
               height: 60,
               width: 0.33.sw,
               child: Center(
                 child: Text("\u{20B9}${expenseList[i]["amount"]}",style: GoogleFonts.openSans(
                     fontWeight: FontWeight.w800,fontSize: 10.sp
                 ),),
               ),
             )
           ],
         )
       ],
     )),
    );
  }
}
class Expense{
  String id;
  String name;
  String amount;
  String date;

  Expense(this.id, this.name, this.amount, this.date);
}
