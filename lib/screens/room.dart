import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinkeeper/screens/addExpense.dart';
import 'package:coinkeeper/utility/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class Room extends StatefulWidget {
  final DocumentSnapshot room;

  const Room({Key? key,required this.room}) : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {

  List users=[];
  List expense=[];
  List expenseImage=[
    medical,retail
  ];
  bool showAddExpenseImage=false;
  bool showAddExpenseName=false;
  TextEditingController expenseController=TextEditingController();
  TextEditingController amountController=TextEditingController();
  int selectIndex=-1;
  String selectImage="";
  CollectionReference rooms = FirebaseFirestore.instance.collection('Rooms');
  CollectionReference expenseList = FirebaseFirestore.instance.collection('Rooms');
  DocumentSnapshot? roomList;
  bool loading=false;


  @override
  void initState() {
    // TODO: implement initState
    loading=true;
    expenseList.doc(widget.room["roomId"]).collection("expense").snapshots().listen((event) {
      expense=event.docs;
    });
    expenseList.doc(widget.room["roomId"]).collection("users").snapshots().listen((event) {
      users=event.docs;
    });

    rooms.doc(widget.room["roomId"]).snapshots().listen((event) {
      setState(() {
        roomList=event;

      });

      print(roomList!["name"]);
    });
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        loading=false;
        timer.cancel();
      });
    });
    super.initState();
  }


  var uuid = Uuid();

  Future<void> addExpenses({required String name, required String image, required String roomId}) {
    String autoId=uuid.v1();
    DocumentReference expenseAdd = FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return expenseAdd.collection("expense").doc(autoId).set({

        "name":name,
        "image":image,
        "amount":"0",
        "id":autoId

    }).then((value) {
      setState(() {
        expenseController.text="";
      });
    })
        .catchError((error) => print("Failed to add user: $error"));
  }





  Future<void> updateBalance({required String roomId,required String amount}) {

    DocumentReference balanceAdd = FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return balanceAdd.update({
      "balance":amount,
    }).then((value) {

    }).catchError((error) => print("Failed to add user: $error"));
  }


  Future<void> updateSpent({required String roomId,required String amount}) {

    DocumentReference spentAdd = FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return spentAdd.update({
      "spent":amount,
    }).then((value) {

    }).catchError((error) => print("Failed to add user: $error"));
  }


  Future<void> updateExpenses({required String amount,required String roomId,required int index,required String docId}) {
    DocumentReference expenseUpdate = FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return expenseUpdate.collection("expense").doc(docId).update({
      "amount":amount
    })
        .then((value) {
      setState(() {
        amountController.text="";
      });
      Navigator.pop(context);
    })
        .catchError((error) => print("Failed to add user: $error"));
  }
  @override
  Widget build(BuildContext context) {
    return loading
        ?Center(child: CircularProgressIndicator())
    :Scaffold(
      body: SafeArea(child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 35.sp),
            Center(child: Image.asset("assets/images/house.png")),
            Center(
              child: Text(roomList?["name"],style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp
              ),),
            ),
            SizedBox(height: 35.sp),
            Padding(
              padding:  EdgeInsets.only(left: 20.sp,right: 20.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Draggable(
                        data: "name",
                        feedback:Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: Colors.lightBlueAccent.withOpacity(0.3)
                          ),
                          child: Center(
                            child:
                            Image.asset("assets/images/income.png",height: 40,width: 40,),
                          ),
                        ),
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: Colors.lightBlueAccent.withOpacity(0.3)
                          ),
                          child: Center(
                            child:
                            Image.asset("assets/images/income.png",height: 40,width: 40,),
                          ),
                        ),),
                      SizedBox(height: 8.sp),
                      Text("Income",style:GoogleFonts.openSans(
                          fontSize: 16.sp,fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),),
                      SizedBox(height: 6.sp),
                      Text("\u{20B9} ${roomList?["income"]}",style:GoogleFonts.openSans(
                          fontSize: 12.sp,fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent
                      ),)
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.lightBlueAccent.withOpacity(0.3)
                        ),
                        child: Center(
                          child:
                          Image.asset("assets/images/bank.png",height: 40,width: 40,),
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Text("Balance",style:GoogleFonts.openSans(
                          fontSize: 16.sp,fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),),
                      SizedBox(height: 6.sp),
                      Text("\u{20B9} ${roomList?["balance"]}",style:GoogleFonts.openSans(
                          fontSize: 12.sp,fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent
                      ),)
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.lightBlueAccent.withOpacity(0.3)
                        ),
                        child: Center(
                          child:
                          Image.asset("assets/images/expense.png",height: 40,width: 40,),
                        ),
                      ),
                      SizedBox(height: 8.sp),
                      Text("Spent",style:GoogleFonts.openSans(
                          fontSize: 16.sp,fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),),
                      SizedBox(height: 6.sp),
                      Text("\u{20B9} ${roomList?["spent"]}",style:GoogleFonts.openSans(
                          fontSize: 12.sp,fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent
                      ),)
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 17.sp,top: 20.sp),
              child: Text("Expense",style:GoogleFonts.openSans(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 4.sp,right: 20.sp),
              child: Row(
                children: [
                  Flexible(child: Wrap(
                    children: [
                      for(int i=0;i<expense.length;i++)
                        DragTarget(
                          builder:(context, data,syncData){
                            return Padding(
                              padding:  EdgeInsets.only(left: 10.sp,top: 21.sp),
                              child: Container(
                                height: 90,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.greenAccent.withOpacity(0.3)
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Image.asset(expense[i]["image"],height: 40,width: 40,),
                                      Text(expense[i]["name"],style:GoogleFonts.openSans(
                                          fontSize: 10.sp,fontWeight: FontWeight.bold,
                                          color: Colors.black
                                      ),),
                                      Text("\u{20B9} ${expense[i]["amount"]}",style:GoogleFonts.openSans(
                                          fontSize: 10.sp,fontWeight: FontWeight.bold,
                                          color: Colors.lightBlueAccent
                                      ),)

                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                          onWillAccept: (data) {
                            return true;
                          },
                          onAccept: (data){
                            print(i);
                            showDialog(context: context, builder: (context)=>AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                             content: Container(
                               height: 0.2.sh,
                               width: 0.82.sw,
                               child: Column(
                                 children: [
                                   Image.asset("assets/images/manSad.png",height: 100,width: 120,),
                                   SizedBox(height: 20.sp),
                                   Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                     children: [
                                       Container(
                                         height: 40,
                                         width: 0.5.sw,
                                         decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(12),
                                             border: Border.all(color: Colors.blueAccent.withOpacity(0.5))
                                         ),
                                         child: TextFormField(
                                           controller: amountController,
                                           decoration: InputDecoration(
                                               hintText: "Enter Amount",
                                               hintStyle: TextStyle(fontSize: 14.sp),
                                               contentPadding: EdgeInsets.only(left: 20.sp,bottom: 10.sp),
                                               border:InputBorder.none
                                           ),
                                         ),
                                       ),
                                       GestureDetector(
                                         onTap: (){
                                           if(amountController.text != ""){
                                             double expenseAmount=double.parse(expense[i]["amount"]) + double.parse(amountController.text.toString());
                                             double balanceAmount=double.parse(roomList?["balance"]) - double.parse(amountController.text.toString());
                                             double spentAmount=double.parse(roomList?["spent"]) + double.parse(amountController.text.toString());
                                             updateExpenses(amount: expenseAmount.toString(),index: i,roomId: roomList?["roomId"],docId:expense[i]["id"]
                                             );
                                             updateBalance(roomId:roomList?["roomId"], amount: balanceAmount.toString());
                                             updateSpent(roomId:roomList?["roomId"], amount: spentAmount.toString());
                                           }
                                         },
                                         child:Container(
                                           height: 40,
                                           width: 0.15.sw,
                                           decoration: BoxDecoration(
                                             borderRadius:BorderRadius.circular(9),
                                             color: Colors.greenAccent.withOpacity(0.3),
                                           ),
                                           child: Center(
                                             child: Text("Add",style: GoogleFonts.openSans(
                                                 fontSize: 10.sp,fontWeight: FontWeight.bold
                                             ),),
                                           ),
                                         ),
                                       ),
                                     ],
                                   )

                                 ],
                               ),
                             ),
                            ));
                            // updateExpenses(amount:"786", roomId: roomList?["roomId"], index: i);
                          },
                        ),

                      Padding(
                        padding:  EdgeInsets.only(left: 10.sp,top: 21.sp),
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              showAddExpenseImage=true;
                            });
                          },
                          child: Container(
                            height: 90,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.greenAccent.withOpacity(0.3)
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Add\n Expense",style: GoogleFonts.openSans(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                      color: Colors.black
                                  ),textAlign: TextAlign.center,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
                ],
              ),
            ),

            showAddExpenseImage
                ?Padding(
              padding:  EdgeInsets.only(left: 17.sp,right: 22.sp,top: 15.sp,bottom: 10.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("New Expense",style:GoogleFonts.openSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.sp,
                  ),),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        showAddExpenseName=false;
                        showAddExpenseImage=false;
                      });
                    },
                    child:Text("Close",style: GoogleFonts.openSans(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.greenAccent,
                    ),),
                  )
                ],
              ),
            )
                :SizedBox(),
            showAddExpenseImage
                ? Padding(
              padding:  EdgeInsets.only(left: 4.sp,right: 20.sp),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child:Row(
                  children: [
                    for(int i=0;i<expenseImage.length;i++)
                      Padding(
                        padding:  EdgeInsets.only(left: 10.sp,top: 21.sp,right: 20.sp),
                        child:  GestureDetector(
                            onTap: (){
                              setState(() {
                                selectIndex=i;
                                selectImage=expenseImage[i].toString();
                                showAddExpenseName=true;
                              });
                            },
                            child:Container(
                                height: 70,width: 70,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(expenseImage[i].toString()),fit:BoxFit.fill, )
                                ),
                                child:selectIndex==i? Icon(Icons.done,color:Colors.white,size: 40,):SizedBox())),
                      ),
                  ],
                ),
              ),
            )
                :SizedBox(),
            SizedBox(height: 15.sp),

            showAddExpenseName
                ?Padding(
              padding:  EdgeInsets.only(left: 15.sp,right: 20.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 0.6.sw,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.greenAccent.withOpacity(0.5))
                    ),
                    child: TextFormField(
                      controller: expenseController,
                      decoration: InputDecoration(
                          hintText: " Expense Name",
                          hintStyle: TextStyle(fontSize: 14.sp),
                          contentPadding: EdgeInsets.only(left: 20.sp),
                          border:InputBorder.none
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      if(expenseController.text != ""){
                        addExpenses(name: expenseController.text.toString(), image:selectImage , roomId: roomList?["roomId"]);
                      }
                    },
                    child:Container(
                      height: 50,
                      width: 0.2.sw,
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(12),
                        color: Colors.greenAccent.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Text("Add",style: GoogleFonts.openSans(
                            fontSize: 14.sp,fontWeight: FontWeight.bold
                        ),),
                      ),
                    ),
                  ),

                ],
              ),
            )
                :SizedBox(),
            Padding(
              padding:  EdgeInsets.only(left: 17.sp,top: 20.sp),
              child: Text("Family Members",style:GoogleFonts.openSans(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 4.sp,right: 20.sp),
              child: Row(
                children: [
                  Flexible(child: Wrap(
                    children: [
                      for(int i=0;i<users.length;i++)
                        Padding(
                          padding:  EdgeInsets.only(left: 15.sp,top: 21.sp),
                          child: Column(
                            children: [
                              Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    color: Colors.cyanAccent.withOpacity(0.3)
                                ),
                                child: Center(
                                  child: Image.asset("assets/images/manOne.png",height: 50,width: 50,),
                                ),
                              ),
                              Text(users[i]["name"],style:GoogleFonts.openSans(
                                  fontSize: 12.sp,fontWeight: FontWeight.bold,
                                  color: Colors.black
                              ),),
                            ],
                          ),
                        ),

                    ],
                  ))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
