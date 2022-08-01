import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lu_bird/view/home/custom_map.dart';
import 'package:provider/provider.dart';
import '../../providers/authentication.dart';
import 'package:location/location.dart' as loc;

import '../public_widgets/custom_loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSub;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200.h,
            ),
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
            const Text("Home"),
            IconButton(
              onPressed: () {
                Provider.of<Authentication>(context, listen: false).signOut();
              },
              icon: const Icon(Icons.logout),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("location")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return buildLoadingWidget();
                  }

                  final data = snapshot.data;

                  if (data != null && data.docs.isEmpty) {
                    return const SizedBox();
                  }

                  return ListView.builder(
                    itemBuilder: (context, index) => ListTile(
                      title: Text(data?.docs[index]['name']),
                      subtitle: Row(
                        children: [
                          Text(data!.docs[index]['latitude'].toString()),
                          const SizedBox(height: 20),
                          Text(data.docs[index]['longitude'].toString())
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.map),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  CustomMap(data.docs[index].id)));
                        },
                      ),
                    ),
                    itemCount: data?.docs.length,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': locationResult.latitude,
        'longitude': locationResult.longitude,
        'name': "Ikram",
      });
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
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentLocation.latitude,
        'longitude': currentLocation.longitude,
        'name': "Ikram",
      });
    });
  }

  _stopListening() {
    _locationSub?.cancel();
    setState(() {
      _locationSub = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

}
