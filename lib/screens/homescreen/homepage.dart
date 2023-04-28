import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinkeeper/main.dart';
import 'package:coinkeeper/newRoomEdit.dart';
import 'package:coinkeeper/screens/homescreen/addexpense.dart';
import 'package:coinkeeper/screens/homescreen/addincome.dart';
import 'package:coinkeeper/screens/homescreen/expenselist.dart';
import 'package:coinkeeper/screens/homescreen/incomelist.dart';
import 'package:coinkeeper/screens/room.dart';
import 'package:coinkeeper/screens/userEdit.dart';
import 'package:coinkeeper/utility/images.dart';
import 'package:coinkeeper/utility/notification.dart';
import 'package:coinkeeper/utility/storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {

  const Homepage({Key? key,}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> with ImageUtility {



  TextEditingController userName = TextEditingController();
  TextEditingController joinCode = TextEditingController();

  String userUid="";
  DocumentSnapshot? userData;
  Future<void> getToken()async{
    final String storageToken= await StorageService().getUserId("uid");
    setState(()  {
      userUid=storageToken.toString();
      if(userUid != ""){
        users.doc(userUid).snapshots().listen((event) {
          userData=event;
        });
      }
    });

  }
  bool loading=false;
  @override
  void initState() {
    initialInfo();
    request();
  getToken();
  setState(() {
    loading=true;
  });
  Timer.periodic(Duration(milliseconds: 900), (timer) {
    setState(() {
      loading=false;
      timer.cancel();
    });
  });
  rooms.snapshots().listen((event) {
    print(event.docs[0].id);
    setState(() {
      roomList=event.docs;
    });
    print(roomList[0]["name"]);
  });
    super.initState();
  }


  CollectionReference rooms = FirebaseFirestore.instance.collection('Rooms');
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List roomList=[];
  bool showUserEdit=false;
  List userImages=[manOne,manTwo,manThree,womanOne,manFour,manFive];
  int selectRoom=0;
  String selectImage="";
  int selectIndex = -1;
  String editName="";
  List rowAction=["Change","Close"];
  List nameAction=["Close","Change"];
  List joinRow=["Close","Join"];
  List<RoomModel>roomRow=[
    RoomModel(joinTeam,"Join"),
    RoomModel(newTeam, "New")
  ];
  bool copy=false;
  bool joined=false;
  bool uploading=false;

  ScrollController scrollController=ScrollController();


  Future<void> updateUsers({required String userId,required String userName,required String image}) {
    DocumentReference user = FirebaseFirestore.instance.collection('users').doc(userId);
    return user.update({
      "userName":userName,
      "image":image,
      "uid":userId,
    }).then((value) {
      getToken();
      Navigator.pop(context);
      setState(() {
        uploading=false;
      });
    }).catchError((error) => print("Failed to add user: $error"));
  }


  Future<void> addUserToRoom({required String roomId,required String uid}) {
    DocumentReference userAdd = FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return userAdd.update({
      "uid":FieldValue.arrayUnion([
        uid
      ])
    }).then((value) {
      setState(() {
        joinCode.text="";
      });
      Navigator.pop(context);
      joined=false;
    }).catchError((error) {
      setState(() {
        joined=false;
      });
    });
  }





  String storeToken = "";




  void request() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  initialInfo() {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = DarwinInitializationSettings();
    var ini = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(ini,
        onDidReceiveNotificationResponse: (NotificationResponse noti) async {});
    FirebaseMessaging.onMessage.listen((event) async {
      print("----onmessage---");
      print("onmessage:${event.notification?.title}");
      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
          event.notification!.body.toString(),
          htmlFormatBigText: true,
          contentTitle: event.notification!.title.toString(),
          htmlFormatContentTitle: true);
      AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails("CoinKeeper", "CoinKeeper",
          importance: Importance.high,
          styleInformation: bigTextStyleInformation,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound("notification"),
          playSound: true);
      NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(0, event.notification?.title,
          event.notification?.body, notificationDetails,
          payload: event.data['title']);
    });
  }



  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          Padding(
            padding:  EdgeInsets.only(right: 9.sp,top: 15.sp),
            child: GestureDetector(
              onTap: (){
                if(showUserEdit){
                  setState(() {
                    showUserEdit=false;
                  });
                }
                else{
                  showDialog(context: context, builder: (context)=>StatefulBuilder(builder:(context,setState){
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      content: Container(
                        height: 0.22.sh,
                        width: 0.82.sw,
                        child: Column(
                          children: [
                            Text("Room",style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp
                            ),),
                            SizedBox(height: 25.sp),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for(int i=0;i<roomRow.length;i++)
                                  GestureDetector(
                                    onTap:(){
                                      switch(i){
                                        case 0:{
                                          Navigator.pop(context);
                                          showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context,setState){
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              content: Container(
                                                height: 0.22.sh,
                                                width: 0.82.sw,
                                                child: Column(
                                                  children: [
                                                    Text("Join Us",style: GoogleFonts.openSans(
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 18.sp
                                                    ),),
                                                    SizedBox(height: 25.sp),
                                                    Container(
                                                      height: 50,
                                                      width: 0.7.sw,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(color: Colors.blueAccent.withOpacity(0.5))
                                                      ),
                                                      child: TextFormField(
                                                        controller: joinCode,
                                                        decoration: InputDecoration(
                                                            hintText: "Enter code",
                                                            hintStyle: TextStyle(fontSize: 14.sp),
                                                            contentPadding: EdgeInsets.only(left: 20.sp,bottom: 10.sp),
                                                            border:InputBorder.none
                                                        ),
                                                      ),
                                                    ),
                                                    joined
                                                        ?Padding(padding: EdgeInsets.only(top: 12.sp),
                                                    child: showLoader(h: 30.sp, w:30.sp),)
                                                        :Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        for(int i=0;i<2;i++)
                                                          Padding(
                                                            padding:  EdgeInsets.only(top: 20.sp,left: 6.sp,right: 5.sp),
                                                            child: GestureDetector(
                                                              onTap: (){

                                                                switch(i){
                                                                  case 0:{
                                                                    Navigator.pop(context);
                                                                  }
                                                                  break;
                                                                  case 1:{
                                                                    if(joinCode.text != ""){
                                                                      setState(() {
                                                                        joined=true;
                                                                      });
                                                                      addUserToRoom(roomId:joinCode.text.toString(),uid:userData?["uid"]);
                                                                    }
                                                                  }
                                                                  break;
                                                                  default:
                                                                }
                                                              },
                                                              child:Container(
                                                                height: 40,
                                                                width: 0.2.sw,
                                                                decoration: BoxDecoration(
                                                                  borderRadius:BorderRadius.circular(9),
                                                                  color: Colors.greenAccent.withOpacity(0.3),
                                                                ),
                                                                child: Center(
                                                                  child: Text(joinRow[i].toString(),style: GoogleFonts.openSans(
                                                                      fontSize: 10.sp,fontWeight: FontWeight.bold
                                                                  ),),
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
                                        }
                                        break;
                                        case 1:{
                                          Navigator.pop(context);
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewRoomEdit(userData: userData,)));
                                        }
                                        break;
                                        default:
                                      }
                                    },
                                    child:Container(
                                      height: 100,
                                      width: 0.3.sw,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Colors.tealAccent.withOpacity(0.3)
                                      ),
                                      child: Column(
                                        children: [
                                          Image.asset(roomRow[i].image.toString(),height: 50,width: 50),
                                          SizedBox(height: 5.sp),
                                          Text(roomRow[i].name,style: GoogleFonts.openSans(fontSize: 14.sp,fontWeight: FontWeight.bold),)
                                        ],
                                      ),
                                    ),
                                  )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }));
                }
              },
              child: Text(showUserEdit?"Close":"Room",style: GoogleFonts.openSans(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: Colors.tealAccent
              ),),
            ),
          )
        ],
        title: Padding(
          padding:  EdgeInsets.only(left: 35.sp),
          child: Text("Coin Keeper",style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 16.sp,fontWeight: FontWeight.bold
          ),),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(),
      body:loading
          ?Center(
        child: CircularProgressIndicator(),
      )
          :Column(
            children: [
              SizedBox(
                height: 0.02.sh
              ),
              DragTarget(
                builder:(context, data,syncData){
                  return  Center(
                    child: Container(
                      height: 120,
                      width:120,
                      decoration: BoxDecoration(
                          color: Color(0xff018786).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(120
                          )
                      ),
                      child: Center(
                        child: Image.asset(userData?["image"],height: 70,width: 70,fit: BoxFit.fill,),
                      ),
                    ),
                  );
                },
                onWillAccept: (data) {
                  return true;
                },
                onAccept: (data){

                  showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context,setState){
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      content: Container(
                        height: 0.28.sh,
                        width: 0.9.sw,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(selectImage,height: 90,width: 90,),
                                Image.asset("assets/images/transfer.gif",height: 90,width: 90,),
                                Image.asset(userData?["image"],height: 90,width: 90,)
                              ],
                            ),
                            SizedBox(height: 26.sp),
                            uploading
                                ?showLoader(h: 30.sp, w: 30.sp)
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                for(int i=0;i<2;i++)
                                  Padding(
                                    padding:  EdgeInsets.only(bottom: 13.sp),
                                    child: GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          uploading=true;
                                        });
                                        switch(i){
                                          case 0:{
                                            updateUsers(userId: userData?["uid"], userName: userData?["userName"], image: selectImage);
                                          }
                                          break;
                                          case 1:{
                                            Navigator.pop(context);
                                          }
                                          break;
                                          default:
                                        }
                                      },
                                      child:Container(
                                        height: 40,
                                        width: 0.2.sw,
                                        decoration: BoxDecoration(
                                          borderRadius:BorderRadius.circular(9),
                                          color: Colors.greenAccent.withOpacity(0.3),
                                        ),
                                        child: Center(
                                          child: Text(rowAction[i].toString(),style: GoogleFonts.openSans(
                                              fontSize: 10.sp,fontWeight: FontWeight.bold
                                          ),),
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
              SizedBox(height: 0.01.sh),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userData?["userName"],style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp
                  ),),
                  SizedBox(width: 7.sp),
                  showUserEdit
                  ?GestureDetector(
                    onTap: (){
                      setState(() {
                        userName.text=userData?["userName"];
                        editName=userData?["userName"];
                      });
                      showDialog(context: context, builder: (context)=>StatefulBuilder(builder: (context,setState){
                        return StatefulBuilder(builder: (context,setState){
                          return  AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            content: Container(
                              height: 0.30.sh,
                              width: 0.82.sw,
                              child: Column(

                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(userName.text.toString(),style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp
                                      ),),
                                      Image.asset("assets/images/transfer.gif",height: 50,width: 70,),
                                      Text(userData?["userName"],style: GoogleFonts.openSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.sp
                                      ),)
                                    ],
                                  ),
                                  SizedBox(height: 22.sp),
                                  Container(
                                    height: 50,
                                    width: 0.7.sw,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.blueAccent.withOpacity(0.5))
                                    ),
                                    child: TextFormField(
                                      onChanged: (value){
                                        setState((){
                                          if(value.isEmpty){
                                            editName=userData?["userName"];
                                          }
                                          else{
                                            editName=value;
                                          }

                                        });
                                      },
                                      controller: userName,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(9)
                                      ],
                                      decoration: InputDecoration(

                                          hintText: "Edit Name",
                                          hintStyle: TextStyle(fontSize: 14.sp),
                                          contentPadding: EdgeInsets.only(left: 20.sp,bottom: 10.sp),
                                          border:InputBorder.none
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.sp),
                                  uploading
                                      ?showLoader(h: 30.sp, w: 30.sp)
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      for(int i=0;i<2;i++)
                                        Padding(
                                          padding:  EdgeInsets.only(top: 20.sp,left: 6.sp,right: 5.sp),
                                          child: GestureDetector(
                                            onTap: (){
                                              setState((){
                                                uploading=true;
                                              });
                                              switch(i){
                                                case 0:{
                                                  Navigator.pop(context);
                                                }
                                                break;
                                                case 1:{
                                                  updateUsers(userId:userData?["uid"], userName: editName, image: userData?["image"]);
                                                }
                                                break;
                                                default:
                                              }
                                            },
                                            child:Container(
                                              height: 40,
                                              width: 0.2.sw,
                                              decoration: BoxDecoration(
                                                borderRadius:BorderRadius.circular(9),
                                                color: Colors.greenAccent.withOpacity(0.3),
                                              ),
                                              child: Center(
                                                child: Text(nameAction[i].toString(),style: GoogleFonts.openSans(
                                                    fontSize: 10.sp,fontWeight: FontWeight.bold
                                                ),),
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
                        });
                      }));
                    },
                      child:Icon(Icons.edit,color: Colors.tealAccent,size: 26))
                      :SizedBox()
                ],
              ),
              SizedBox(height: 0.01.sh),
              showUserEdit
              ?SizedBox()
              :Center(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      showUserEdit=true;
                    });
                  },
                  child: Text("Edit",style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    color: Colors.tealAccent
                  ),),
                ),
              ),
              SizedBox(height: 0.01.sh),
              showUserEdit
              ?Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: 35.sp,top: 20.sp),
                    child: Text("Images",style:GoogleFonts.openSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                    ),),
                  ),
                  Row(
                    children: [
                      Flexible(child: Wrap(
                        children: [
                          for(int i=0;i<userImages.length;i++)
                            Draggable(
                              onDragStarted: (){
                                setState(() {
                                  selectImage=userImages[i].toString();
                                  selectIndex=i;
                                });
                              },feedback: Padding(
                              padding:  EdgeInsets.only(left: 21.sp,top: 21.sp,right: 10.sp),
                              child:  Container(
                                height: 80,width: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(userImages[i].toString()),fit:BoxFit.fill, )
                                ),
                                // child:selectIndex==i? Icon(Icons.done,color:Colors.white,size: 40,):SizedBox()
                              ),
                            ),data: "users",
                              child: Padding(
                              padding:  EdgeInsets.only(left: 21.sp,top: 21.sp,right: 10.sp),
                              child:  Container(
                                height: 80,width: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(userImages[i].toString()),fit:BoxFit.fill, )
                                ),
                                // child:selectIndex==i? Icon(Icons.done,color:Colors.white,size: 40,):SizedBox()
                              ),
                            ),)

                        ],
                      ))
                    ],
                  ),
                ],
              )
              :Container(
                height: 0.613.sh,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.black,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
                ),
                child:SingleChildScrollView(
                  controller: scrollController,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10.sp,),
                     Padding(
                       padding:  EdgeInsets.only(left: 25.sp,top: 15.sp),
                       child: Text("Your Rooms",style: GoogleFonts.openSans(
                           fontSize: 16.sp,fontWeight: FontWeight.w800,
                           color: Colors.white
                       ),),
                     ),

                        ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                            itemCount: roomList.length,
                            itemBuilder: (context,i){
                            List users=roomList[i]["uid"];
                          return users.contains(userData?["uid"])
                              ? Padding(
                            padding:  EdgeInsets.only(left: 25.sp,top: 20.sp,right: 17.sp),
                            child: GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>Room(room: roomList[i],userData: userData,)));
                              },
                              child: Container(
                                height: 0.35.sw,
                                width: 0.7.sw,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.tealAccent.withOpacity(0.3)
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 15.sp),
                                    Padding(
                                      padding:  EdgeInsets.only(left:20.sp,bottom: 8.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(roomList[i]["image"],height: 50,width: 50,),
                                              SizedBox(width: 15.sp),
                                              Text(roomList[i]["name"].toString(),style: GoogleFonts.openSans(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white
                                              ),),
                                            ],
                                          ),
                                          roomList[i]["admin"] == userData?["uid"]
                                         ? Padding(
                                            padding:  EdgeInsets.only(right: 10.sp),
                                            child: GestureDetector(
                                              onTap: (){
                                                setState(() {
                                                  selectRoom=i;
                                                  copy=true;
                                                });
                                                Timer.periodic(Duration(milliseconds: 100), (timer) {
                                                  setState(() {
                                                    copy=false;
                                                    timer.cancel();
                                                  });
                                                });
                                                Clipboard.setData(
                                                    ClipboardData(text: roomList[i]["roomId"]));
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 0.2.sw,
                                                decoration: BoxDecoration(
                                                    color:selectRoom==i && copy?Colors.greenAccent.withOpacity(0.3):Colors.white,
                                                    borderRadius: BorderRadius.circular(7)
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.copy,color: Colors.black,size: 14.sp,),
                                                    SizedBox(width: 2.sp),
                                                    Text("Copy",style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10.sp,
                                                      fontWeight: FontWeight.bold
                                                    ),)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ):SizedBox()
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:  EdgeInsets.only(left:25.sp,right: 25.sp),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Total",style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                              SizedBox(height: 8.sp),
                                              Text("\u{20B9} ${roomList[i]["income"].toString()}",style: GoogleFonts.openSans(
                                                  color: Colors.tealAccent,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Balance",style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                              SizedBox(height: 8.sp),
                                              Text("\u{20B9} ${roomList[i]["balance"].toString()}",style: GoogleFonts.openSans(
                                                  color: Colors.tealAccent,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("Spent",style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                              SizedBox(height: 8.sp),
                                              Text("\u{20B9} ${roomList[i]["spent"].toString()}",style: GoogleFonts.openSans(
                                                  color: Colors.tealAccent,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w600
                                              ),)
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                              :SizedBox();
                        })

                    ],
                  ),
                ),
              )

            ],
          ),
    );
  }
}


class RoomModel{
  String image;
  String name;

  RoomModel(this.image, this.name);

}


