import 'package:coinkeeper/main.dart';
import 'package:coinkeeper/screens/homescreen/addexpense.dart';
import 'package:coinkeeper/screens/homescreen/addincome.dart';
import 'package:coinkeeper/screens/homescreen/expenselist.dart';
import 'package:coinkeeper/screens/homescreen/incomelist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  final bankacc;
  final updateamt;
  final date;
  final addincome;
  final addincomename;
  final addincomeamt;
  final addincomelistamt;
  final addincomedate;
  final expenselistname;
  const Homepage({
    Key? key,
    this.bankacc,
    this.updateamt,
    this.date,
    this.addincome,
    this.addincomedate,
    this.expenselistname,
    this.addincomename,
    this.addincomeamt,
    this.addincomelistamt,
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool showcustomfield = false;
  int i = 0;
  List text = ["Income"];
  String initincomeamt = "Rs 0";
  // List gridTitle = [
  //   "Groceries",
  //   "Eating outside",
  //   "Transport",
  //   "Shopping",
  //   "House",
  //   "Entertainment",
  //   "Services",
  // ];
  // List gridIcons = [
  //   const Icon(
  //     Icons.cookie,
  //     color: Colors.white,
  //   ),
  //   const Icon(
  //     Icons.fastfood_outlined,
  //     color: Colors.white,
  //   ),
  //   const Icon(
  //     Icons.emoji_transportation,
  //     color: Colors.white,
  //   ),
  //   const Icon(
  //     Icons.shopping_cart_outlined,
  //     color: Colors.white,
  //   ),
  //   const Icon(
  //     Icons.home_outlined,
  //     color: Colors.white,
  //   ),
  //   const Icon(
  //     Icons.movie_creation_outlined,
  //     color: Colors.white,
  //   ),
  //   const Icon(
  //     Icons.home_repair_service_outlined,
  //     color: Colors.white,
  //   ),
  // ];
  String incomename = '';
  String income= "";
  var walletAmt;
  var totalIncome;

  List<expenseData> expenseList = [
    expenseData("Groceries", "", Icons.cookie),
    expenseData("Eating outside", "", Icons.fastfood_outlined,),
    expenseData("Transport", "", Icons.emoji_transportation),
    expenseData("Shopping", "", Icons.shopping_cart_outlined),
    expenseData("House", "", Icons.home_outlined),
    expenseData("Entertainment", "", Icons.movie_creation_outlined),
    expenseData("Services", "", Icons.home_repair_service_outlined)
  ];

  TextEditingController name = TextEditingController();
  TextEditingController accBal = TextEditingController();

  @override
  void initState() {
  gettingdatafromLocal();
    super.initState();
  }

  gettingdatafromLocal()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    walletAmt = prefs.getStringList("wallet");
   totalIncome= prefs.getInt("totalamt");
  }

  List<incomeData> incomeList = [
    incomeData("Wallet", "", Icons.wallet),
    incomeData("Account", "", Icons.account_balance_outlined)
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder(
          future: gettingdatafromLocal() ,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) =>
              Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              Column(
                children: [
                  Text(
                    "Balance",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: "text",
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Rs ${totalIncome}",
                    style: TextStyle(
                        color: Colors.teal,
                        fontFamily: "text",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(width: 30.w),
              Column(
                children: [
                  Text(
                    "Expense",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: "text",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Rs",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: "text",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(width: 30.w),
              Column(
                children: [
                  Text(
                    "Planned",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: "text",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Rs",
                    style: TextStyle(
                        color: Colors.blueGrey,
                        fontFamily: "text",
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Spacer(),
              i == 0
                  ? IconButton(
                      icon: Icon(Icons.arrow_drop_down),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          i = 1;
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.arrow_drop_up),
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          i = 0;
                        });
                      },
                    ),
              SizedBox(width: 10.w)
            ],
          ),
      ),
      body: showcustomfield
            ? Stack(
                children: [
                  Container(
                    height: double.infinity.h,
                    width: 360.w,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(money), fit: BoxFit.cover)),
                  ),
                  Positioned(
                    bottom: 0.h,
                    child: Container(
                      height: 500.h,
                      width: 360.w,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          color: Colors.white70,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(70),
                              topRight: Radius.circular(70))),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Text(
                            "Where do you keep your money?",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "text",
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showcustomfield = false;
                                    });
                                  },
                                  icon: const Icon(Icons.close)),
                              SizedBox(
                                width: 200.w,
                              ),
                              IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (name.text.toString().isNotEmpty &&
                                          accBal.text.toString().isNotEmpty) {
                                        incomeList.add(incomeData(
                                            name.text.toString(),
                                            accBal.text.toString(),
                                            Icons.ac_unit));
                                        showcustomfield = false;
                                        name.clear();
                                        accBal.clear();
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.done)),
                            ],
                          ),
                          SizedBox(
                            height: 70.h,
                          ),
                          SizedBox(
                            width: 250.w,
                            height: 75.h,
                            child: TextField(
                              controller: name,
                              style: TextStyle(fontSize: 15.sp),
                              keyboardType: TextInputType.text,
                              cursorWidth: 1.w,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: "Enter name",
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "text",
                                      color: Colors.black)),
                            ),
                          ),
                          SizedBox(
                            height: 75.h,
                            width: 250.w,
                            child: TextField(
                              controller: accBal,
                              style: TextStyle(fontSize: 15.sp),
                              keyboardType: TextInputType.number,
                              cursorWidth: 1.w,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  hintText: "Account balance",
                                  hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: "text",
                                      color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                height: double.infinity.h, width: double.infinity.w,
                decoration: const BoxDecoration( image: DecorationImage(image: AssetImage(money), fit: BoxFit.cover)),
                child: Container(
                  height: double.infinity.h, width: double.infinity.w,
                  color: Colors.white70, child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Divider(
                        color: Colors.transparent,
                        thickness: 1.5.w,
                      ),
                      i == 0
                      ? SizedBox(
                              height: 120.h,
                              child: ListView.builder(
                                  itemCount: text.length,
                                  itemBuilder: (context, index) => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            text[index],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "text",
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Draggable(
                                            data: text[index],
                                            feedback: Container(
                                              height: 50.h,
                                              width: 50.h,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.blue.shade400,
                                              ),
                                              child: const Icon(
                                                Icons.attach_money_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                            child: InkWell(
                                              onTap: () => Navigator.push(
                                                  context,
                                                  SizeAnimatingRoute(
                                                      page: Incomelist(
                                                    whereto: incomeList[index]
                                                        .incomeName,
                                                    date: widget.addincomedate,
                                                    addincome: widget.addincome,
                                                  ))),
                                              child: Container(
                                                height: 58.h,
                                                width: 58.h,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.blue.shade400,
                                                ),
                                                child: const Icon(
                                                  Icons.attach_money_rounded,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 8.h,
                                          ),
                                          Text(
                                            widget.addincome == null
                                                ? initincomeamt
                                                : "Rs ${widget.addincome}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontFamily: "text",
                                                fontSize: 12.5.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Divider(
                                            color: Colors.black,
                                            thickness: 0.5.w,
                                          ),
                                        ],
                                      )),
                            )
                      : const SizedBox(),
                      SizedBox(
                        height: 110.h,
                        child: ListView.builder(
                            itemExtent: 90.w,
                            scrollDirection: Axis.horizontal,
                            itemCount: incomeList.length,
                            itemBuilder: (context, index) => Draggable(
                                  data: incomeList[index].incomeName,
                                  feedback: Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.orange.shade400,
                                    ),
                                    child: Icon(incomeList[index].icons),
                                  ),
                                  child: DragTarget(
                                    onAccept: (data) {
                                      income = data.toString();
                                      Navigator.push(
                                          context,
                                          SizeAnimatingRoute(
                                              page: Addincome(
                                                  initamt: walletAmt[index],
                                                  whereto: incomeList[index]
                                                      .incomeName)));
                                    },
                                    builder: (context, candidateData, rejectedData) =>
                                            Column(
                                      children: [
                                        Text(
                                          incomeList[index].incomeName,
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontFamily: "text",
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          height: 50.h,
                                          width: 50.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.orange.shade400,
                                          ),
                                          child: Icon(
                                            incomeList[index].icons,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Text(
                                          widget.addincomelistamt == null
                                              ? walletAmt[index]
                                              : widget.addincomelistamt
                                                  .toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "text",
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     setState(() {
                      //       showcustomfield = true;
                      //     });
                      //   },
                      //   child: Container(
                      //     height: 40.h,
                      //     width: 40.h,
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.black),
                      //       shape: BoxShape.circle,
                      //       color: Colors.transparent,
                      //     ),
                      //     child: const Icon(
                      //       Icons.add,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.5.w,
                      ),
                      SizedBox(
                        height: 220.h,
                        child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: expenseList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount( mainAxisExtent: 115.h, crossAxisCount: 4),
                            itemBuilder: (context, index) => DragTarget(
                                  onAccept: (data) {
                                    incomename = data.toString();
                                    Navigator.push(
                                        context,
                                        SizeAnimatingRoute(
                                            page: Addexpense(
                                          incomename: incomename,
                                          whereto: expenseList[index].expenseName,
                                        )));
                                  },
                                  builder:
                                      (context, candidateData, rejectedData) =>
                                          GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          SizeAnimatingRoute(
                                              page: Expenselist(
                                            date: widget.date,
                                            expensefrom: widget.expenselistname,
                                            expensename:
                                                expenseList[index].expenseName,
                                            expenseamt: widget.updateamt,
                                          )));
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          expenseList[index].expenseName,
                                          style: TextStyle(
                                              color: Colors.blueGrey,
                                              fontFamily: "text",
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Container(
                                          height: 50.h,
                                          width: 50.h,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.teal.shade400,
                                          ),
                                          child: Icon(
                                            expenseList[index].expicons,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8.h,
                                        ),
                                        Text(
                                          widget.updateamt == null
                                              ? "Rs 0"
                                              : "${widget.updateamt}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "text",
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                      ),
                    ],
                  ),
                ),
              ),
      drawer: const Drawer(),
    ),
        ));
  }
}

class incomeData {
  final String incomeName;
  final String incomeAmt;
  IconData icons;

  incomeData(this.incomeName, this.incomeAmt, this.icons);
}

class expenseData {
  final String expenseName;
  final String expenseAmt;
  IconData expicons;

  expenseData(this.expenseName, this.expenseAmt, this.expicons);
}
