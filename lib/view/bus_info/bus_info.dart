import 'package:flutter/material.dart';

class BusInfo extends StatelessWidget {
  const BusInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bus Info",style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text("Coming Soon"),
      ),
    );
  }
}
