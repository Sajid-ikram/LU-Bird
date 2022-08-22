
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

Widget profileImage(Size size) {
  return SizedBox(
    height: size.height * 0.18,
    width: size.height * 0.155,
    child: Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 4.0,
            ),
          ),
          height: size.height * 0.155,
          width: size.height * 0.155,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Image.asset(
              "assets/profile.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 5.sp,
          bottom: 22.sp,
          child: InkWell(
            onTap: () {},
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 3,
                      offset: const Offset(3, 3), // Shadow position
                    ),
                  ]),
              child: const Icon(
                Icons.camera_alt_outlined,
                size: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
