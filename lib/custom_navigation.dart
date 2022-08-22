import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_bird/view/bus_info/bus_info.dart';
import 'package:lu_bird/view/chat/chat.dart';
import 'package:lu_bird/view/home/gps_settings.dart';
import 'package:lu_bird/view/home/home.dart';
import 'package:lu_bird/view/profile/profile.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';

class CustomNavigation extends StatefulWidget {
  const CustomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomNavigation> createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  int _bottomNavIndex = 0;

  List<IconData> icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.busSimple,
    FontAwesomeIcons.comment,
    FontAwesomeIcons.gear,
  ];

  List<Widget> pages = [
    const Home(),
    const BusInfo(),
    const Chat(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: pages[_bottomNavIndex],
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: icons,
        notchSmoothness: NotchSmoothness.softEdge,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.none,
        iconSize: 19.sp,
        inactiveColor: Colors.grey,
        activeColor: primaryColor,
        leftCornerRadius: 40.sp,
        rightCornerRadius: 40.sp,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        //other params
      ),
    );
  }
}
