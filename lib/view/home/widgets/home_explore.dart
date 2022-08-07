import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

Padding buildExplore() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 30.w),
    child: Column(
      children: [
        SizedBox(height: 70.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: const Icon(FontAwesomeIcons.bars),
                ),
                SizedBox(height: 130.h),
                Text(
                  "Explore",
                  style:
                      TextStyle(fontSize: 36.sp, fontWeight: FontWeight.w800),
                )
              ],
            ),
            const Spacer(),
          ],
        ),
        Container(
          margin: EdgeInsets.only(top: 20.h),
          height: 160.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(25.sp),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                "assets/notice.jpg",
              ),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 4,
                  offset: const Offset(0, 7))
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 30.h,vertical: 20.sp),
                child: Text(
                  "Notices",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
