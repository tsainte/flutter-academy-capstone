import 'package:flutter_academy_capstone/Network/study_aid_api.dart';
import 'package:flutter_academy_capstone/model/study_aid.dart';

class StudyAidViewModel {
  StudyAidViewModel(int id, String title)
      : _studyAid = StudyAid(id: id, title: title);

  StudyAid _studyAid;

  Future getStudyAid() {
    return StudyAidApi()
        .getStudyAid(_studyAid.id)
        .then((value) => _studyAid = value);
  }

  String get title => _studyAid.title;
  String get content => _studyAid.content ?? '';
  int get checklistCount => _studyAid.checklist?.length ?? 0;

  String itemTitle(index) => _studyAid.checklist?[index].title ?? '';

  bool itemIsChecked(index) => _studyAid.checklist?[index].isChecked ?? false;

  void setIsChecked(index, value) =>
      _studyAid.checklist?[index].isChecked = value;

  String checklistText() {
    if (_studyAid.checklist != null) {
      int checked = _studyAid.checklist!.fold(
          0,
          (previousValue, element) =>
              previousValue + (element.isChecked ? 1 : 0));
      int total = _studyAid.checklist!.length;
      return '$checked/$total';
    } else {
      return '';
    }
  }

  void markComplete() {
    if (_studyAid.checklist != null) {
      for (int i = 0; i < _studyAid.checklist!.length; i++) {
        _studyAid.checklist![i].isChecked = true;
      }
    }
  }
}
