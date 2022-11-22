import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart' as loc;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lu_bird/constants/api_endpoints.dart';
import 'package:lu_bird/constants/route_coordinate.dart';
import 'package:lu_bird/providers/map_provider.dart';
import 'package:provider/provider.dart';
import '../auth/widgets/snackBar.dart';
import '../public_widgets/custom_loading.dart';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CustomMap extends StatefulWidget {
  const CustomMap({Key? key}) : super(key: key);

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  final loc.Location location = loc.Location();
  bool isIconSelected = false;
  bool _added = false;
  StreamSubscription<loc.LocationData>? _locationSub;
  late GoogleMapController _controller;

  Uint8List? userLocationIcon;
  Uint8List? busLocationIcon;
  CameraPosition? userCameraPosition;

  List<Map> locationList = [];
  final Set<Polyline> _polyline = {};

  List<LatLng> latLen = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getMarkers();
    initSocket();



    _polyline.addAll([
      Polyline(
        polylineId: const PolylineId('2'),
        points: RoutesCoordinate().route1,
        color: const Color(0xff4C3575),
      ),
      Polyline(
        polylineId: const PolylineId('2'),
        points: RoutesCoordinate().route2,
        color: const Color(0xffB2B2B2),
      ),
      Polyline(
        polylineId: const PolylineId('2'),
        points: RoutesCoordinate().route3,
        color: const Color(0xffF96666),
      ),
      Polyline(
        polylineId: const PolylineId('2'),
        points: RoutesCoordinate().route4,
        color: Color(0xffA5F1E9),
      ),
      Polyline(
        polylineId: const PolylineId('1'),
        points: RoutesCoordinate().commonLetLng,
        color: const Color(0xff6D9886),
      )
    ]);
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _locationSub!.cancel();
  }

  late IO.Socket socket;
  var result = {};

  Future<void> initSocket() async {
    try {
      socket = IO.io(Api_Endpoints.baseUrl, {
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connected;
      socket.on("locationChange", (data) {
        int index =
            locationList.indexWhere((element) => element['id'] == data['id']);
        if (index >= 0) {
          locationList[index]["latitude"] = data["latitude"];
          locationList[index]["longitude"] = data["longitude"];
        } else {
          locationList.add(data);
        }
        print("------------------------------------- changing");

        Provider.of<MapProvider>(context, listen: false).onLocationChange();
      });
    } catch (err) {
      print(err);
      print("------------------------------------- err");
    }
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<MapProvider>(context, listen: false);
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
            return isIconSelected
                ? Consumer<MapProvider>(
                    builder: (BuildContext context, value, Widget? child) {
                      return buildGoogleMap(pro);
                    },
                  )
                : buildLoadingWidget();
          }
        },
      ),
    );
  }

  GoogleMap buildGoogleMap(MapProvider pro) {
    print("----------------------------------");
    return GoogleMap(
      zoomGesturesEnabled: true,
      zoomControlsEnabled: true,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,

      onCameraMove: (CameraPosition cameraPosition) {
        userCameraPosition = cameraPosition;
      },
      polylines: _polyline,
      initialCameraPosition: CameraPosition(
        target: pro.userLocation == null
            ? const LatLng(24.89502182528581, 91.86866700677376)
            : LatLng(pro.userLocation!.latitude!, pro.userLocation!.longitude!),
        zoom: 15,
      ),
      mapType: MapType.normal,
      markers: Set<Marker>.of(
        locationList.map(
          (element) {
            return Marker(
              position: LatLng(element['latitude'], element['longitude']),
              markerId: MarkerId(element["id"]),
              infoWindow: const InfoWindow(
                title: "Route 1",
              ),
              icon: BitmapDescriptor.fromBytes(busLocationIcon!),
            );
          },
        ),
      ),
      onMapCreated: (GoogleMapController controller) async {
        if (!_added) {
          _controller = controller;
          _added = true;
          _onUserLocationChange(pro);
        }
      },
    );
  }

  Future<void> changeMyMap(MapProvider pro) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: userCameraPosition == null
              ? pro.userLocation == null
                  ? const LatLng(24.89489077447926, 91.86879280019157)
                  : LatLng(
                      pro.userLocation!.latitude!, pro.userLocation!.longitude!)
              : userCameraPosition!.target,
          zoom: userCameraPosition == null ? 15 : userCameraPosition!.zoom,
          tilt: userCameraPosition == null ? 0 : userCameraPosition!.tilt,
          bearing: userCameraPosition == null ? 0 : userCameraPosition!.bearing,
        ),
      ),
    );
  }

  getMarkers() async {
    userLocationIcon = await getBytesFromAssets("assets/user.png", 100);
    busLocationIcon = await getBytesFromAssets("assets/bus.png", 80);

    if (userLocationIcon != null && busLocationIcon != null) {
      setState(() {
        isIconSelected = true;
      });
    } else {
      return snackBar(context, "Something Went Wrong");
    }
  }

  Future<void> _onUserLocationChange(MapProvider pro) async {
    _locationSub = location.onLocationChanged.handleError((onError) {
      _locationSub!.cancel();
      setState(() {
        _locationSub = null;
      });
    }).listen((loc.LocationData currentLocation) async {
      pro.userLocation = currentLocation;
      print("---------------------------------- user location change");

      if (mounted) {
        Provider.of<MapProvider>(context, listen: false).onLocationChange();
      }

      changeMyMap(pro);
    });
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
