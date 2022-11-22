import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lu_bird/models/notice_model.dart';
import '../constants/api_endpoints.dart';

class NoticeClient {
  NoticeClient() {}

  Future<bool> createNotice(NoticeModel noticeModel) async {
    var url = Uri.parse(Api_Endpoints.NOTICE);
    try {
      var response = await http.post(
        url,
        body: noticeModel.toJson(),
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

  Future<List<NoticeModel>> getNotices(int skip) async {
    var url = Uri.parse(Api_Endpoints.NOTICE + "?skip=$skip");
    try {
      var response = await http.get(url);
      var listOfNotice = jsonDecode(response.body) as List;
      if (response.statusCode == 200) {
        return listOfNotice
            .map((element) => NoticeModel.fromJson(element))
            .toList();
      } else {
        throw Exception("Fail To load");
      }
    } catch (err) {
      throw Exception(err);
    }
  }


}
