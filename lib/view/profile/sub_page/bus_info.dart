import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

class BusInfo extends StatelessWidget {
  const BusInfo({Key? key}) : super(key: key);

  static const List<Color> colors = [
    Color(0xff6D9886),
    Color(0xff625757),
    Color(0xff30475E),
    Color(0xffF96666),
    Color(0xff999B84),
  ];

  static const List<String> text = [
    "This color line in the map represent the common route.",
    "This color line in the map represent route 1.",
    "This color line in the map represent route 2.",
    "This color line in the map represent route 3.",
    "This color line in the map represent route 4.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Info", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20.h),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [buildContainer(colors[index]), buildText(text[index])],
          );
        },
        itemCount: colors.length,
      ),
    );
  }

  Padding buildText(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30.w, 6.h, 30.w, 20.h),
      child: Text(
        text,
        style: TextStyle(
          color: primaryColor,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Container buildContainer(Color color) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
      height: 20.h,
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(10.sp)),
    );
  }
}
