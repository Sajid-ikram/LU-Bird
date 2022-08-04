import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_bird/view/home/widgets/home_map.dart';
import 'package:lu_bird/view/home/widgets/home_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom_map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<IconData> icons = [
    FontAwesomeIcons.busSimple,
    FontAwesomeIcons.calendarDays,
    FontAwesomeIcons.spinner,
    FontAwesomeIcons.spinner,
    FontAwesomeIcons.spinner,
    FontAwesomeIcons.spinner,

  ];

  List<String> names = [
    "Bus Notice",
    "Bus Routine",
    "Upcoming",
    "Upcoming",
    "Upcoming",
    "Upcoming",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(
            height: 150.h,
            child: homeUserInfo(context),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CustomMap("user1")));
            },
            child: homeMap(),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: GridView.builder(
                padding: EdgeInsets.only(top: 15.h),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1.3),
                itemCount: 6,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.only(
                      right: index % 2 == 0 ? 10.w : 0,
                      bottom: 10.h,
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.2),
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.sp)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.sp),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.sp),
                              color: Colors.greenAccent.withOpacity(0.1),
                            ),
                            child:  Icon(icons[index],size: 18.sp,),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            names[index],
                            style: TextStyle(
                                fontSize: 13.sp, fontWeight: FontWeight.w600),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
