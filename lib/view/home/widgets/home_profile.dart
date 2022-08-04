import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../providers/profile_provider.dart';

Padding homeUserInfo(BuildContext context) {
  return Padding(
    padding: EdgeInsets.fromLTRB(25.w, 43.h, 25.w, 10.h),
    child: Consumer<ProfileProvider>(
      builder: (context, provider, child) {
        return Row(
          children: [
            provider.profileUrl != ""
                ? GestureDetector(
                    onTap: () {
                      /*Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ;
                  }),
                );*/
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 21,
                      backgroundImage: NetworkImage(
                        provider.profileUrl,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 21,
                      backgroundImage: AssetImage("assets/profile.jpg"),
                    ),
                  ),
            Padding(
              padding: EdgeInsets.only(left: 20.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome  👋",
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.black.withOpacity(0.6)),
                  ),
                  Text(
                    provider.profileName.isEmpty
                        ? "Unknown"
                        : provider.profileName,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: (){
                Navigator.of(context).pushNamed("GPSSetting");
              },
              child: Icon(
                FontAwesomeIcons.gear,
                size: 18.sp,
              ),
            )
          ],
        );
      },
    ),
  );
}
