import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/models/assigned_bus_model.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:lu_bird/repository/assigned_bus_repo.dart';
import 'package:lu_bird/view/assigned_bus/assign_bus.dart';
import 'package:provider/provider.dart';

import '../auth/widgets/snackBar.dart';
import '../public_widgets/app_colors.dart';
import '../public_widgets/custom_loading.dart';

class AssignedBus extends StatefulWidget {
  const AssignedBus({Key? key}) : super(key: key);

  @override
  State<AssignedBus> createState() => _AssignedBusState();
}

class _AssignedBusState extends State<AssignedBus> {
  List<String> busTime = ["12 pm", "1 pm", "2 pm", "2.45 pm", "4 pm"];
  late int selectedIndex;
  bool isLoading = true;
  List<String> route1 = [];
  List<String> route2 = [];
  List<String> route3 = [];
  List<String> route4 = [];

  late ScrollController scrollController;

  @override
  void initState() {
    setIndex();
    getBusses();

    scrollController = ScrollController(
      initialScrollOffset: selectedIndex * 110.0, // or whatever offset you wish
      keepScrollOffset: true,
    );
    super.initState();
  }

  Future<void> getBusses() async {
    setState(() {
      isLoading = true;
    });

    List<AssignedBusModel> response = [];
    try {
      response =
          await AssignedBusRepo().getAssignedBusses(busTime[selectedIndex]);
    } catch (err) {
      snackBar(context, "Something Went Wrong");
    }

    route1.clear();
    route2.clear();
    route3.clear();
    route4.clear();

    for (var e in response) {
      if (e.route == '1' && e.busNumber != null) {
        route1.add(e.busNumber!);
      } else if (e.route == '2' && e.busNumber != null) {
        route2.add(e.busNumber!);
      } else if (e.route == '3' && e.busNumber != null) {
        route3.add(e.busNumber!);
      } else if (e.route == '4' && e.busNumber != null) {
        route4.add(e.busNumber!);
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProfileProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Assigned Bus",
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w500,
            color: primaryColor,
          ),
        ),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.only(left: 22.w),
            height: 50.h,
            width: double.infinity,
            child: ListView.builder(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    selectedIndex = index;
                    pro.refreshAssignBusPage();
                    getBusses();
                  },
                  child: Container(
                    height: 40.h,
                    width: 100.w,
                    margin: EdgeInsets.symmetric(horizontal: 5.w),
                    decoration: BoxDecoration(
                        color: selectedIndex == index
                            ? primaryColor.withOpacity(0.8)
                            : Colors.grey.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.sp)),
                    child: Center(
                        child: Text(
                      busTime[index],
                      style: TextStyle(
                          color: selectedIndex == index
                              ? Colors.white
                              : primaryColor,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                );
              },
              itemCount: busTime.length,
            ),
          ),
          SizedBox(height: 10.h),
          isLoading
              ? SizedBox(height: 580.h, child: buildThreeInOutLoadingWidget())
              : Selector<ProfileProvider, bool>(
                  selector: (context, provider) => provider.refreshAssignBus,
                  builder: (context, provider, child) {
                    return SizedBox(
                      height: 580.h,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        children: [
                          buildContainer(1, route1),
                          buildContainer(2, route2),
                          buildContainer(3, route3),
                          buildContainer(4, route4),
                        ],
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  ConstrainedBox buildContainer(int route, List<String> busses) {
    int rowNum = ((busses.length + 1) / 3).ceil();
    var pro = Provider.of<ProfileProvider>(context, listen: false);

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: (rowNum * 40.h) + 45.h,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 25.w),
        //height: 130.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10.sp),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 13.h),
              child: Text(
                "Bus assigned to route $route",
                style: const TextStyle(
                    color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: rowNum * 60.h,
              child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: busses.isEmpty ? 1 : 3,
                    childAspectRatio: busses.isEmpty ? 6 : 2,
                  ),
                  itemCount: busses.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (busses.isEmpty && pro.role != "admin") {
                      return Container(
                        padding: EdgeInsets.only(bottom: 12.h),
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: const Center(
                            child: Text(
                          "Not Assigned",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      );
                    }
                    if (index == busses.length) {
                      return pro.role == "admin"
                          ? InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AssignBus(
                                      route: route.toString(),
                                      departureTime: busTime[selectedIndex],
                                    );
                                  },
                                ).then((value) {
                                  getBusses();
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(6.sp),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(child: Icon(Icons.add)),
                              ),
                            )
                          : const SizedBox();
                    }
                    return Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(6.sp),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(child: Text(busses[index])),
                        ),
                        if (pro.role == "admin")
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Center(
                              child: Icon(
                                Icons.cancel,
                                size: 18.sp,
                                color: Colors.red,
                              ),
                            ),
                          ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  setIndex() {
    switch (DateTime.now().hour) {
      case 11:
        {
          selectedIndex = 0;
        }
        break;

      case 12:
        {
          selectedIndex = 1;
        }
        break;
      case 13:
        {
          selectedIndex = 2;
        }
        break;
      case 14:
        {
          selectedIndex = 3;
        }
        break;

      case 15:
        {
          selectedIndex = 4;
        }
        break;
      default:
        {
          selectedIndex = 0;
        }
        break;
    }
  }
}
