import 'package:flutter_academy_capstone/Network/study_aid_api.dart';
import 'package:flutter_academy_capstone/model/study_aid.dart';

class StudyListViewModel {
  List<StudyAid> studyAids = [];

  Future getStudyAids() {
    return StudyAidApi().getStudyAids().then((value) => studyAids = value);
  }
}
