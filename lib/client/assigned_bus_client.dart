import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lu_bird/models/assigned_bus_model.dart';
import '../constants/api_endpoints.dart';

class AssignedBusClient {
  AssignedBusClient() {}

  Future<bool> assignBus(AssignedBusModel busModel) async {
    var url = Uri.parse(Api_Endpoints.ASSIGN_BUS);
    try {
      var response = await http.post(
        url,
        body: busModel.toJson(),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (err) {
      throw Exception(err);
    }
  }

  Future<List<AssignedBusModel>> getAssignedBusses(String timeSlot) async {
    Future.delayed(const Duration(seconds: 1), () {
      // Do something
    });

    /*return [
      AssignedBusModel(busNumber: "674565", route: "1"),
      AssignedBusModel(busNumber: "122888", route: "1"),
      AssignedBusModel(busNumber: "125676", route: "2"),
      AssignedBusModel(busNumber: "134535", route: "2"),
      AssignedBusModel(busNumber: "134545", route: "2"),
      AssignedBusModel(busNumber: "344355", route: "3"),
      AssignedBusModel(busNumber: "123455", route: "3"),
      AssignedBusModel(busNumber: "123455", route: "3"),
      AssignedBusModel(busNumber: "122334", route: "4"),
      AssignedBusModel(busNumber: "123456", route: "4"),
    ];*/
    var url = Uri.parse("${Api_Endpoints.ASSIGN_BUS}?departureTime=$timeSlot");
    try {
      var response = await http.get(url);
      var listOfBus = jsonDecode(response.body) as List;
      if (response.statusCode == 200) {
        return listOfBus
            .map((element) => AssignedBusModel.fromJson(element))
            .toList();
      } else {
        throw Exception("Fail To load");
      }
    } catch (err) {
      throw Exception(err);
    }
  }
}
