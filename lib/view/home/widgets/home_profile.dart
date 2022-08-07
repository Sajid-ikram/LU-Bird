import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

import '../../../providers/profile_provider.dart';

Positioned buildHomeProfile(ProfileProvider pro) {
  return Positioned(
    top: -57.h,
    right: -100.w,
    child: Container(
      padding: EdgeInsets.all(30.sp),
      decoration: buildBoxDecoration(0.4),
      child: Container(
        padding: EdgeInsets.all(30.sp),
        decoration: buildBoxDecoration(0.5),
        child: Container(
          padding: EdgeInsets.all(30.sp),
          decoration: buildBoxDecoration(0.7),
          child: Container(
            padding: EdgeInsets.all(30.sp),
            decoration: buildBoxDecoration(0.9),
            child: giveImage(pro.profileUrl),
          ),
        ),
      ),
    ),
  );
}

BoxDecoration buildBoxDecoration(double value) {
  return BoxDecoration(
    border: Border.all(color: primaryColor.withOpacity(value)),
    shape: BoxShape.circle,
  );
}

giveImage(String text) {
  return text != ""
      ? GestureDetector(
          onTap: () {},
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 23,
            backgroundImage: NetworkImage(
              text,
            ),
          ),
        )
      : GestureDetector(
          onTap: () {},
          child: const CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 23,
            backgroundImage: AssetImage("assets/profile.jpg"),
          ),
        );
}
