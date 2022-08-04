import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Container homeMap() {
  return Container(
    height: 190.h,
    width: double.infinity,
    margin: EdgeInsets.fromLTRB(25.w, 0, 25.w, 25.h),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.23),
              offset: Offset(1, 1),
              spreadRadius: 3,
              blurRadius: 10)
        ]),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
        child: Image.asset(
      "assets/map.JPG",
      fit: BoxFit.fill,
    )),
  );
}
