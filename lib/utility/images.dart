import 'package:flutter/material.dart';





/// expense


const retail="assets/images/retail.png";
const medical="assets/images/medical.png";
const hotel="assets/images/hotel.png";
const onion="assets/images/onion.png";
const tomato="assets/images/tomato.png";
const water="assets/images/water.png";
const vegetable="assets/images/vegetable.png";
const idly="assets/images/idly.png";
const cylinder="assets/images/cylinder.png";
const curd="assets/images/curd.png";


///house


const houseOne="assets/images/houseOne.png";
const houseTwo="assets/images/houseTwo.png";
const houseThree="assets/images/houseThree.png";
const houseFour="assets/images/houseFour.png";
const houseFive="assets/images/houseFive.png";


///user images

const manOne="assets/images/manOne.png";
const manTwo="assets/images/manTwo.png";
const manThree="assets/images/manThree.png";
const manFour="assets/images/manFour.png";
const manFive ="assets/images/manFive.png";


const womanOne="assets/images/womanOne.png";


///teams

const joinTeam="assets/images/joinTeam.png";
const newTeam="assets/images/newTeam.png";


mixin ImageUtility{
  showLoader({required double h,required double w}){
    return Center(child:Image.asset("assets/images/loader.gif",height:h,width:w,),);
  }
}