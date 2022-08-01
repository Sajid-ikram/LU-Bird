import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../public_widgets/custom_loading.dart';

class CustomMap extends StatefulWidget {
  final String userId;

  const CustomMap(this.userId, {Key? key}) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("location").snapshots(),
        builder: (context, snapshot) {
          if (_added) {
            changeMyMap(snapshot);
          }

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

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.userId)['latitude'],
                snapshot.data!.docs.singleWhere(
                    (element) => element.id == widget.userId)['longitude'],
              ),
              zoom: 14.47,
            ),
            mapType: MapType.normal,
            markers: {
              Marker(
                position: LatLng(
                  snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.userId)['latitude'],
                  snapshot.data!.docs.singleWhere(
                      (element) => element.id == widget.userId)['longitude'],
                ),
                markerId: const MarkerId('id'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
              ),
            },
            onMapCreated: (GoogleMapController controller) async {
              if (!_added) {
                setState(() {
                  _controller = controller;
                  _added = true;
                });
              }
            },
          );
        },
      ),
    );
  }

  Future<void> changeMyMap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.userId)['latitude'],
              snapshot.data!.docs.singleWhere(
                  (element) => element.id == widget.userId)['longitude'],
            ),
            zoom: 14.47),
      ),
    );
  }
}
