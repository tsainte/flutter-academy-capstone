import 'dart:convert';

import 'package:flutter_academy_capstone/model/study_aid.dart';
import 'package:http/http.dart' as http;

class StudyAidApi {
  static const bool _isProd = true;
  static const baseURI = _isProd
      ? 'https://flutteracademycapstoneapi-zt77jxkv3a-uc.a.run.app/'
      : 'http://localhost:8080';
  var client = http.Client();
  Future<List<StudyAid>> getStudyAids() async {
    final url = Uri.parse(baseURI + '/study_aids');

    final response = await client.get(url);

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson.map((e) => StudyAid.fromJson(e)).toList();
  }

  Future<StudyAid> getStudyAid(int id) async {
    final url = Uri.parse(baseURI + '/study_aids/$id');
    final response = await client.get(url);

    final dynamic decodedJson = jsonDecode(response.body);
    return StudyAid.fromJson(decodedJson);
  }
}
