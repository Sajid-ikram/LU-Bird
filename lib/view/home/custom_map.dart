import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../public_widgets/custom_loading.dart';

class CustomMap extends StatefulWidget {


  const CustomMap({Key? key}) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  final loc.Location location = loc.Location();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("location").snapshots(),
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
          } else {
            return GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(24.894891656253854, 91.86870006890493),
                zoom: 13,
              ),
              mapType: MapType.normal,
              markers: Set<Marker>.of(
                snapshot.data!.docs.map(
                  (element) {
                    return Marker(
                      position: LatLng(
                        element['latitude'],
                        element['longitude'],
                      ),
                      markerId: MarkerId(element.id),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueMagenta),
                    );
                  },
                ),

              ),

            );
          }
        },
      ),
    );
  }

/*Future<void> changeMyMap(AsyncSnapshot<QuerySnapshot> snapshot) async {
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
  }*/
}
