import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_bird/view/auth/widgets/flat_button.dart';
import 'package:lu_bird/view/auth/widgets/text_field.dart';

class CustomDialogBox extends StatefulWidget {
  const CustomDialogBox({Key? key}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      margin: EdgeInsets.only(top: 10.sp),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0, 10), blurRadius: 10),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.h),
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(FontAwesomeIcons.circleXmark)),
          SizedBox(height: 30.h),
          Text(
            "Enter your email",
            style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          Text(
            "to receive a reset link",
            style: TextStyle(
                fontSize: 10.sp, color: Colors.black.withOpacity(0.5)),
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: customTextField(
              TextEditingController(),
              "Enter your email",
              context,
              Icons.email_outlined,
            ),
          ),
          SizedBox(height: 30.h),
          Text(
            "Didn’t receive any link?",
            style: TextStyle(
                fontSize: 13.sp,
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 7.h),
          Text(
            "Please check in spam or send again",
            style: TextStyle(
                fontSize: 12.sp, color: Colors.black.withOpacity(0.5)),
          ),
          SizedBox(height: 30.h),
          flatButton(name: 'SEND'),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }
}
