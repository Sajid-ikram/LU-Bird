import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/view/home/widgets/home_explore.dart';
import 'package:lu_bird/view/home/widgets/home_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/public_widgets/app_colors.dart';
import 'package:provider/provider.dart';

import 'custom_map.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomNavIndex = 0;

  List<IconData> icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.busSimple,
    FontAwesomeIcons.comment,
    FontAwesomeIcons.gear,
  ];

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const CustomMap()));
              },
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: SizedBox(
                  height: 430.h,
                  width: 360.w,
                  child: Image.asset(
                    "assets/map.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          buildExplore(),
          buildHomeProfile(pro),
        ],
      ),
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
