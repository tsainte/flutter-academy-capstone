import 'package:flutter/material.dart';
import 'package:flutter_academy_capstone/Network/study_aid_api.dart';
import 'package:flutter_academy_capstone/model/study_aid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedStudyAidProvider = Provider((ref) => Selected());

class Selected extends ChangeNotifier {
  StudyAid? studyAid;
  Selected();
}

final studyAidProvider = StateNotifierProvider<StudyAidNotifier, StudyAid>(
  (ref) {
    StudyAid studyAid = ref.watch(selectedStudyAidProvider).studyAid!;
    return StudyAidNotifier(studyAid);
  },
);

class StudyAidNotifier extends StateNotifier<StudyAid> {
  StudyAidNotifier(StudyAid studyAid) : super(studyAid);

  Future fetchStudyAidDetails(int id) {
    return StudyAidApi().getStudyAid(id).then((value) => state = value);
  }

  String get title => state.title;
  String get content => state.content ?? '';
  // ----- checklist -----

  int get checklistCount => state.checklist?.length ?? 0;

  String itemTitle(index) => state.checklist?[index].title ?? '';

  bool itemIsChecked(index) => state.checklist?[index].isChecked ?? false;

  void setIsChecked(index, isCheckedValue) {
    bool willComplete =
        isCheckedValue && _countChecked() == _checklistLength() - 1;
    bool willIncomplete =
        !isCheckedValue && _countChecked() == _checklistLength();

    if (willComplete) {
      state.isCompleted = true;
    } else if (willIncomplete) {
      state.isCompleted = false;
    }
    state.checklist?[index].isChecked = isCheckedValue;
    state = state.copyWith();
  }

  String checklistText() {
    if (state.checklist != null) {
      int checked = _countChecked();
      int total = _checklistLength();
      return '$checked/$total';
    } else {
      return '';
    }
  }

  int _countChecked() {
    return state.checklist!.fold(
        0,
        (previousValue, element) =>
            previousValue + (element.isChecked ? 1 : 0));
  }

  int _checklistLength() =>
      state.checklist != null ? state.checklist!.length : 0;

  // ----- complete banner ----

  bool get isCompleted => state.isCompleted ?? false;

  void markCompleted() {
    for (int i = 0; i < state.checklist!.length; i++) {
      state.checklist![i].isChecked = true;
    }
    state = state.copyWith(isCompleted: true);
  }

  void markIncompleted() {
    for (int i = 0; i < state.checklist!.length; i++) {
      state.checklist![i].isChecked = false;
    }
    state = state.copyWith(isCompleted: false);
  }
}
