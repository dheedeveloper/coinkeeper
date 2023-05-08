import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coinkeeper/utility/images.dart';
import 'package:coinkeeper/utility/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:uuid/uuid.dart';

class NewRoomEdit extends StatefulWidget {
  final DocumentSnapshot? userData;
  const NewRoomEdit({Key? key,required this.userData}) : super(key: key);

  @override
  State<NewRoomEdit> createState() => _NewRoomEditState();
}

class _NewRoomEditState extends State<NewRoomEdit> with ImageUtility {

  List houses=[houseOne,houseTwo,houseThree,houseFour,houseFive];
  String selectImage="";
  int selectIndex=-1;
  List action=["Close","Add"];
  TextEditingController houseName=TextEditingController();
  TextEditingController income=TextEditingController();
  TextEditingController validity=TextEditingController();
  final CalendarController controller = CalendarController();


  String month="";
  String year="";


  ///room add controller

  bool roomAdd=false;


  var uuid = Uuid();
  String autoId="";
  Future<void> addRooms({required String name, required String image,required String income,required String roomId,}) {

    DocumentReference rooms = FirebaseFirestore.instance.collection('Rooms').doc(roomId);
    return rooms.set({
      "name":name,
      "image":image,
      "income":income,
      "balance":income,
      "spent":"0",
      "validity":selectDate,
      "validityDate":validityDate,
      "admin":widget.userData?["uid"],
      "roomId":roomId,
      "uid":FieldValue.arrayUnion([
        widget.userData?["uid"]
      ])
    }).then((value) {
      setState(() {
        roomAdd=false;
      });
      Navigator.pop(context);
    }).catchError((error) {
      setState(() {
        roomAdd=false;
      });
    });
  }



  String userMessageToken="";
  Future<void> getUserToken()async{
    final String storageToken= await StorageService().getUserId("token");
    setState(()  {
      userMessageToken=storageToken.toString();
    });

  }

  @override
  void initState() {
    getUserToken();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                title: Text("New Room",style: GoogleFonts.openSans(
          color: Colors.black,
          fontWeight: FontWeight.w800,fontSize: 20.sp
        ),),
      ),
      body: SafeArea(child:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: 23.sp,top: 20.sp),
              child: Text("House",style:GoogleFonts.openSans(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),),
            ),
            Row(
              children: [
                Flexible(child: Wrap(
                  children: [
                    for(int i=0;i<houses.length;i++)
                      Padding(
                        padding:  EdgeInsets.only(left: 21.sp,top: 21.sp,right: 10.sp),
                        child:  GestureDetector(
                            onTap: (){
                              setState(() {
                                selectImage=houses[i].toString();
                                selectIndex=i;
                              });
                            },
                            child:Container(
                                height: 80,width: 80,
                                decoration: BoxDecoration(
                                    image: DecorationImage(image: AssetImage(houses[i].toString()),fit:BoxFit.fill, )
                                ),
                                child:selectIndex==i? Icon(Icons.done,color:Colors.white,size: 40,):SizedBox())),
                      ),
                  ],
                ))
              ],
            ),
            Padding(
              padding:  EdgeInsets.only(left: 23.sp,top: 27.sp),
              child: Text("House Name",style:GoogleFonts.openSans(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 23.sp,top: 13.sp),
              child: Container(
                height: 50,
                width: 0.8.sw,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.5),width: 3)
                ),
                child: TextFormField(
                  controller: houseName,
                  decoration: InputDecoration(
                      hintText: " Enter House Name",
                      hintStyle: TextStyle(fontSize: 14.sp),
                      contentPadding: EdgeInsets.only(left: 20.sp),
                      border:InputBorder.none
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 23.sp,top: 27.sp),
              child: Text("Income",style:GoogleFonts.openSans(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 23.sp,top: 13.sp),
              child: Container(
                height: 50,
                width: 0.8.sw,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.5),width: 3)
                ),
                child: TextFormField(
                  controller: income,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: " Enter Income ",
                      hintStyle: TextStyle(fontSize: 14.sp),
                      contentPadding: EdgeInsets.only(left: 20.sp),
                      border:InputBorder.none
                  ),
                ),
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 23.sp,top: 27.sp),
              child: Text("Validity",style:GoogleFonts.openSans(
                fontWeight: FontWeight.w800,
                fontSize: 16.sp,
              ),),
            ),
            Padding(
              padding:  EdgeInsets.only(left: 23.sp,top: 13.sp),
              child: Container(
                height: 50,
                width: 0.8.sw,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.greenAccent.withOpacity(0.5),width: 3)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:  EdgeInsets.only(left: 18.sp),
                      child: Text(selectDate.isEmpty?"Pick Validity date":selectDate,style:GoogleFonts.openSans(
                        fontSize: 14.sp,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w500
                      ),),
                    ),
                    Padding(
                      padding:  EdgeInsets.only(right: 10.sp),
                      child: GestureDetector(
                        onTap: (){
                          showCalenderDialogue();
                        },
                          child: Icon(Icons.calendar_month,color: Colors.cyanAccent,)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 50.sp,),
            roomAdd?SizedBox()
            :Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for(int i=0;i<action.length;i++)
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        autoId=uuid.v1();
                      });
                      switch(i){
                        case 0:{
                          Navigator.pop(context);
                        }
                          break;
                        case 1:{
                          setState(() {
                            if(houseName.text != ""  && income.text !="" && selectImage != "" && selectDate != ""){
                              roomAdd=true;
                              addRooms(name: houseName.text.toString(), image: selectImage, income: income.text.toString(),roomId: autoId);
                            }
                          });
                        }
                          break;
                        default:
                      }
                    },
                    child:Container(
                      height: 60,
                      width: 0.35.sw,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.tealAccent.withOpacity(0.3)
                      ),
                      child: Center(
                        child: Text(action[i].toString(),style: GoogleFonts.openSans(fontSize: 14.sp,fontWeight: FontWeight.w700),),
                      ),
                    ),
                  )
              ],
            ),
            SizedBox(height: 25.sp),
            roomAdd
                ?showLoader(h: 60.sp, w: 60.sp)
                :SizedBox()
          ],
        ),
      )),
    );
  }
  String selectDate="";
  String validityDate="";

  void selectionChanged(CalendarSelectionDetails args) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        selectDate=DateFormat("dd'th' MMM,yyyy").format(args.date!).toString();
        validityDate=args.date!.toString();
        print(args.date);
        Navigator.pop(context);
      });
    });
  }

  void viewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      setState(() {
        month = DateFormat('MMMM').format(viewChangedDetails
            .visibleDates[viewChangedDetails.visibleDates.length ~/ 2]).toString();
        year = DateFormat('yyyy').format(viewChangedDetails
            .visibleDates[viewChangedDetails.visibleDates.length ~/ 2]).toString();
      });
    });
  }


  showCalenderDialogue(){
    return showDialog(context: context, builder: (context)
    =>StatefulBuilder(builder: (context,setState){
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        backgroundColor: Colors.black,
        content: Container(
          height: 0.4.sh,
          width: 0.8.sw,

          child: SfCalendar(
            selectionDecoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.tealAccent.withOpacity(0.2),
              border: Border.all(color: Colors.tealAccent),
            ) ,
            initialDisplayDate: DateTime.now(),
            controller: controller,
            onSelectionChanged: selectionChanged,
            todayHighlightColor: Color(0xff018786),
            onViewChanged: viewChanged,
            cellBorderColor: Colors.black,
            allowAppointmentResize: true,
            headerStyle: CalendarHeaderStyle(textStyle: TextStyle(color: Colors.white)),
            viewHeaderStyle: ViewHeaderStyle(dayTextStyle: TextStyle(color: Colors.white)),
            view: CalendarView.month,
            monthViewSettings: const MonthViewSettings(
                monthCellStyle: MonthCellStyle(
                  textStyle: TextStyle(color: Colors.white)
                ),
                showTrailingAndLeadingDates: false,
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),

          ),
        ),
      );
    }));
  }
}
