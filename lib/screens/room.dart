import 'dart:async';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinkeeper/screens/addExpense.dart';
import 'package:coinkeeper/screens/userDebit.dart';
import 'package:coinkeeper/utility/images.dart';
import 'package:coinkeeper/utility/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Room extends StatefulWidget {
  final DocumentSnapshot room;
  final DocumentSnapshot? userData;

  const Room({Key? key, required this.room, required this.userData})
      : super(key: key);

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> with ImageUtility {
  List users = [];
  List userUid=[];
  List expense = [];
  List expenseImage = [medical, retail,hotel,tomato,onion,water,cylinder,curd,vegetable,idly];
  bool showAddExpenseImage = false;
  bool showAddExpenseName = false;
  TextEditingController expenseController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  int selectIndex = -1;
  String selectImage = "";
  CollectionReference rooms = FirebaseFirestore.instance.collection('Rooms');
  CollectionReference expenseList = FirebaseFirestore.instance.collection('Rooms');
  CollectionReference userList = FirebaseFirestore.instance.collection('users');
  DocumentSnapshot? roomList;
  bool loading = false;

  ///expense add control

  bool expenseLoad = false;






  @override
  void initState() {
    // TODO: implement initState
    loading = true;
    expenseList
        .doc(widget.room["roomId"])
        .collection("expense")
        .snapshots()
        .listen((event) {
      setState(() {
        expense = event.docs;
      });
    });
    userList.snapshots()
        .listen((event) {
      setState(() {
        users = event.docs;
      });
    });

    rooms.doc(widget.room["roomId"]).snapshots().listen((event) {
      setState(() {
        roomList = event;
        userUid=roomList?["uid"];
      });

      print(roomList!["name"]);
    });
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      setState(() {
        loading = false;
        timer.cancel();
      });
    });
    super.initState();
  }

  var uuid = Uuid();

  Future<void> addExpenses({required String name, required String image, required String roomId}) {
    String autoId = uuid.v1();
    DocumentReference expenseAdd =
        FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return expenseAdd
        .collection("expense")
        .doc(autoId)
        .set({"name": name, "image": image, "amount": "0", "id": autoId}).then(
            (value) {
      setState(() {
        expenseController.text = "";
        expenseLoad = false;
      });
    }).catchError((error) {
      setState(() {
        expenseLoad = false;
      });
    });
  }

  Future<void> updateBalance({required String roomId, required String amount}) {
    DocumentReference balanceAdd =
        FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return balanceAdd
        .update({
          "balance": amount,
        })
        .then((value) {
         setState(() {
           expenseAddLoading=false;
         });
    })
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateSpent({required String roomId, required String amount}) {
    DocumentReference spentAdd =
        FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return spentAdd
        .update({
          "spent": amount,
        })
        .then((value) {})
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<void> updateExpenses({required String amount, required String roomId, required int index, required String docId,required String title}) {
    DocumentReference expenseUpdate =
        FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return expenseUpdate
        .collection("expense")
        .doc(docId)
        .update({"amount": amount}).then((value) {
          addExpensesDetails(roomId: roomId, index: index, docId: docId,title: title);
    }).catchError((error) {
      Navigator.pop(context);
    });
  }

  Future<void> addExpensesDetails({ required String roomId, required int index, required String docId, required String title}) {
    String autoId = uuid.v1();
    DocumentReference expenseUpdate =
    FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return expenseUpdate
        .collection("expense")
        .doc(docId).collection("userAmount").doc(autoId)
        .set({
      "id":autoId,
      "amount":amountController.text.toString(),
      "name":widget.userData?["userName"],
      "Date":DateFormat("dd'th' MMM,yyyy").format(DateTime.now()).toString(),
      "time":DateFormat('kk:mm:ss').format(DateTime.now())
    }).then((value) {
      setState(() {
        amountController.text = "";
      });
      Navigator.pop(context);
    }).catchError((error){
      Navigator.pop(context);
    });
  }



  Future<void> removeUserFromRoom({required String roomId, required String uid}) {
    DocumentReference userAdd =
        FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return userAdd.update({
      "uid": FieldValue.arrayRemove([uid])
    }).then((value) {
      removeUserFromUserList(roomId: roomId, uid: uid);
    }).catchError((error) => print("Failed to add user: $error"));
  }



  Future<void> removeUserFromUserList({required String roomId,required String uid}) {
    DocumentReference userAdd = FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return userAdd.collection("users").doc(uid).delete().then((value) {
    }).catchError((error) => print("Failed to add user: $error"));
  }

  sendNotification({required String amount,required String title}){
    for(int i=0;i<users.length;i++){
      pushNotification(
        {
          "to": users[i]["messageToken"],
          "notification": {
            "title": title,
            "body": "your room member ${widget.userData?["userName"]} spent for $title to $amount",
          },},
      );
    }
    setState(() {
      expenseAddLoading=false;
    });
  }

  bool expenseAddLoading=false;


  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 35.sp),
                  Center(child: Image.asset("assets/images/house.png")),
                  Center(
                    child: Text(
                      roomList?["name"],
                      style: GoogleFonts.openSans(
                          fontWeight: FontWeight.bold, fontSize: 16.sp),
                    ),
                  ),
                  SizedBox(height: 35.sp),
                  Padding(
                    padding: EdgeInsets.only(left: 20.sp, right: 20.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Draggable(
                              data: "name",
                              feedback: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    color: Colors.lightBlueAccent
                                        .withOpacity(0.3)),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/income.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                              child: Container(
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(70),
                                    color: Colors.lightBlueAccent
                                        .withOpacity(0.3)),
                                child: Center(
                                  child: Image.asset(
                                    "assets/images/income.png",
                                    height: 40,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8.sp),
                            Text(
                              "Income",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 6.sp),
                            Text(
                              "\u{20B9} ${roomList?["income"]}",
                              style: GoogleFonts.openSans(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70),
                                  color:
                                      Colors.lightBlueAccent.withOpacity(0.3)),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/bank.png",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.sp),
                            Text(
                              "Balance",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 6.sp),
                            Text(
                              "\u{20B9} ${roomList?["balance"]}",
                              style: GoogleFonts.openSans(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              height: 70,
                              width: 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(70),
                                  color:
                                      Colors.lightBlueAccent.withOpacity(0.3)),
                              child: Center(
                                child: Image.asset(
                                  "assets/images/expense.png",
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.sp),
                            Text(
                              "Spent",
                              style: GoogleFonts.openSans(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 6.sp),
                            Text(
                              "\u{20B9} ${roomList?["spent"]}",
                              style: GoogleFonts.openSans(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 17.sp, top: 20.sp),
                    child: Text(
                      "Expense",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.sp, right: 20.sp),
                    child: Row(
                      children: [
                        Flexible(
                            child: Wrap(
                          children: [
                            for (int i = 0; i < expense.length; i++)
                              DragTarget(
                                builder: (context, data, syncData) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.sp, top: 21.sp),
                                    child: GestureDetector(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>UserBasedAmountDebit(
                                          title: expense[i]["name"]
                                          ,amount:expense[i]["name"],
                                           roomId: roomList?[
                                            "roomId"],
                                          docId: expense[i]["id"],
                                        )));
                                      },
                                      child: Container(
                                        height: 100,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: Colors.greenAccent
                                                .withOpacity(0.3)),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              SizedBox(height: 6.sp),
                                              Image.asset(
                                                expense[i]["image"],
                                                height: 40,
                                                width: 40,
                                              ),
                                              Text(
                                                expense[i]["name"],
                                                style: GoogleFonts.openSans(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              Text(
                                                "\u{20B9} ${expense[i]["amount"]}",
                                                style: GoogleFonts.openSans(
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Colors.lightBlueAccent),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onWillAccept: (data) {
                                  return true;
                                },
                                onAccept: (data) {
                                  print(i);
                                  showDialog(
                                      context: context,
                                      builder: (context) => StatefulBuilder(builder: (context,setState){
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20),
                                          ),
                                          content: Container(
                                            height: 0.2.sh,
                                            width: 0.82.sw,
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "assets/images/manSad.png",
                                                  height: 100,
                                                  width: 120,
                                                ),
                                                SizedBox(height: 20.sp),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 0.5.sw,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              12),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .blueAccent
                                                                  .withOpacity(
                                                                  0.5))),
                                                      child: TextFormField(
                                                        controller:
                                                        amountController,
                                                        decoration: InputDecoration(
                                                            hintText:
                                                            "Enter Amount",
                                                            hintStyle:
                                                            TextStyle(
                                                                fontSize: 14
                                                                    .sp),
                                                            contentPadding:
                                                            EdgeInsets.only(
                                                                left:
                                                                20.sp,
                                                                bottom: 10
                                                                    .sp),
                                                            border:
                                                            InputBorder
                                                                .none),
                                                      ),
                                                    ),
                                                    expenseAddLoading
                                                        ?showLoader(h: 35, w:35)
                                                        :GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          expenseAddLoading=true;
                                                        });
                                                        if (amountController
                                                            .text !=
                                                            "") {
                                                          ///expense amount calculation
                                                          double expenseAmount = double
                                                              .parse(expense[
                                                          i][
                                                          "amount"]) +
                                                              double.parse(
                                                                  amountController
                                                                      .text
                                                                      .toString());
                                                          ///balance amount calculation
                                                          double balanceAmount = double
                                                              .parse(roomList?[
                                                          "balance"]) -
                                                              double.parse(
                                                                  amountController
                                                                      .text
                                                                      .toString());

                                                          ///spent Amount calculation
                                                          double spentAmount = double
                                                              .parse(roomList?[
                                                          "spent"]) +
                                                              double.parse(
                                                                  amountController
                                                                      .text
                                                                      .toString());

                                                          ///expense update
                                                          updateExpenses(
                                                              amount: expenseAmount
                                                                  .toString(),
                                                              index: i,
                                                              roomId: roomList?[
                                                              "roomId"],
                                                              docId:
                                                              expense[i]
                                                              ["id"],
                                                              title: expense[i]["name"]);

                                                          ///balance update
                                                          updateBalance(
                                                              roomId: roomList?[
                                                              "roomId"],
                                                              amount: balanceAmount
                                                                  .toString());
                                                          updateSpent(
                                                              roomId: roomList?[
                                                              "roomId"],
                                                              amount: spentAmount
                                                                  .toString());

                                                          sendNotification(amount: amountController.text.toString(), title: expense[i]["name"]);
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 0.15.sw,
                                                        decoration:
                                                        BoxDecoration(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              9),
                                                          color: Colors
                                                              .greenAccent
                                                              .withOpacity(
                                                              0.3),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            "Add",
                                                            style: GoogleFonts
                                                                .openSans(
                                                                fontSize:
                                                                10.sp,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }));
                                  // updateExpenses(amount:"786", roomId: roomList?["roomId"], index: i);
                                },
                              ),
                            Padding(
                              padding: EdgeInsets.only(left: 10.sp, top: 21.sp),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAddExpenseImage = true;
                                  });
                                },
                                child: Container(
                                  height: 90,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Colors.greenAccent.withOpacity(0.3)),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add\n Expense",
                                          style: GoogleFonts.openSans(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10.sp,
                                              color: Colors.black),
                                          textAlign: TextAlign.center,
                                        )
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
                      ? Padding(
                          padding: EdgeInsets.only(
                              left: 17.sp,
                              right: 22.sp,
                              top: 15.sp,
                              bottom: 10.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "New Expense",
                                style: GoogleFonts.openSans(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16.sp,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showAddExpenseName = false;
                                    showAddExpenseImage = false;
                                  });
                                },
                                child: Text(
                                  "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                  showAddExpenseImage
                      ? Padding(
                          padding: EdgeInsets.only(left: 4.sp, right: 20.sp),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                for (int i = 0; i < expenseImage.length; i++)
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.sp, top: 21.sp, right: 20.sp),
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectIndex = i;
                                            selectImage =
                                                expenseImage[i].toString();
                                            showAddExpenseName = true;
                                          });
                                        },
                                        child: Container(
                                            height: 70,
                                            width: 70,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                              image: AssetImage(
                                                  expenseImage[i].toString()),
                                              fit: BoxFit.fill,
                                            )),
                                            child: selectIndex == i
                                                ? Icon(
                                                    Icons.done,
                                                    color: Colors.white,
                                                    size: 40,
                                                  )
                                                : SizedBox())),
                                  ),
                              ],
                            ),
                          ),
                        )
                      : SizedBox(),
                  SizedBox(height: 15.sp),
                  showAddExpenseName
                      ? Padding(
                          padding: EdgeInsets.only(left: 15.sp, right: 20.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 50,
                                width: 0.6.sw,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.greenAccent
                                            .withOpacity(0.5))),
                                child: TextFormField(
                                  controller: expenseController,
                                  decoration: InputDecoration(
                                      hintText: " Expense Name",
                                      hintStyle: TextStyle(fontSize: 14.sp),
                                      contentPadding:
                                          EdgeInsets.only(left: 20.sp),
                                      border: InputBorder.none),
                                ),
                              ),
                              expenseLoad
                                  ? showLoader(h: 40.sp, w: 40.sp)
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (expenseController.text != "") {
                                            expenseLoad = true;

                                            addExpenses(
                                                name: expenseController.text
                                                    .toString(),
                                                image: selectImage,
                                                roomId: roomList?["roomId"]);
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 0.2.sw,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: Colors.greenAccent
                                              .withOpacity(0.3),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Add",
                                            style: GoogleFonts.openSans(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(left: 17.sp, top: 20.sp),
                    child: Text(
                      "Family Members",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 4.sp, right: 20.sp, bottom: 30.sp),
                    child: Row(
                      children: [
                        Flexible(
                            child: Wrap(
                          children: [
                            for (int i = 0; i < users.length; i++)
                              userUid.contains(users[i]["uid"])
                             ? Padding(
                                padding:
                                    EdgeInsets.only(left: 15.sp, top: 21.sp),
                                child: Column(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(70),
                                          color: Colors.cyanAccent
                                              .withOpacity(0.3)),
                                      child: Center(
                                        child: Image.asset(
                                          users[i]["image"],
                                          height: 50,
                                          width: 50,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      users[i]["userName"],
                                      style: GoogleFonts.openSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    SizedBox(height: 10.sp),
                                    users[i]["uid"] == widget.userData?["uid"]
                                        ? GestureDetector(
                                           onTap: (){
                                             removeUserFromRoom(roomId: roomList?["roomId"], uid: users[i]["uid"]);
                                           },
                                          child:Image.asset(
                                              "assets/images/exit.png",
                                              height: 25,
                                              width: 25,
                                            ),
                                        )
                                        : SizedBox()
                                  ],
                                ),
                              )
                                  :SizedBox(),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          );
  }
}
