import 'dart:async';
import 'package:location/location.dart';
import 'package:lu_bird/providers/profile_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

import '../auth/widgets/snackBar.dart';

class GPSSetting extends StatefulWidget {
  const GPSSetting({Key? key}) : super(key: key);

  @override
  State<GPSSetting> createState() => _GPSSettingState();
}

class _GPSSettingState extends State<GPSSetting> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "GPS Setting",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  _getLocation();
                },
                child: const Text("Add My Location")),
            TextButton(
                onPressed: () {
                  _listLocation();
                },
                child: const Text("Enable Live Location")),
            TextButton(
                onPressed: () {
                  _stopListening();
                },
                child: const Text("Stop Live Location")),
            IconButton(
              onPressed: () {
                Provider.of<Authentication>(context, listen: false).signOut();
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      var pro = Provider.of<ProfileProvider>(context, listen: false);

      bool isAllowed = await requestLocationPermission();
      loc.LocationData? locationResult;
      //final loc.LocationData? locationResult = await _checkPermission();

      if(isAllowed){
        locationResult = await location.getLocation();
      }

      if (locationResult != null) {
        await FirebaseFirestore.instance
            .collection('location')
            .doc(pro.currentUserUid)
            .set({
          'latitude': locationResult.latitude,
          'longitude': locationResult.longitude,
          'name': pro.profileName,
        });


      }else{
        snackBar(context, "Location is not granted");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listLocation() async {
    _locationSub = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSub!.cancel();
      setState(() {
        _locationSub = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      var pro = Provider.of<ProfileProvider>(context, listen: false);
      await Future.delayed(const Duration(seconds: 2));
      await FirebaseFirestore.instance
          .collection('location')
          .doc(pro.currentUserUid)
          .set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'name': pro.profileName,
      });
    });
  }

  _stopListening() {
    _locationSub?.cancel();
    setState(() {
      _locationSub = null;
    });
  }

  /* _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }*/

  Future<bool> requestLocationPermission() async {
    /// status can either be: granted, denied, restricted or permanentlyDenied
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
      if (await Permission.location.request().isGranted) {
        // Either the permission was already granted before or the user just granted it.
        return true;
      }
    }
    return false;
  }
}
