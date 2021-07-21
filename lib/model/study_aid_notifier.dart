import 'package:flutter/material.dart';
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

  bool get isCompleted => state.isCompleted ?? false;

  void markCompleted() {
    // for (int i = 0; i < state.checklist!.length; i++) {
    //   state.checklist![i].isChecked = true;
    // }
    state = state.copyWith(isCompleted: true);
  }

  void markIncompleted() {
    // for (int i = 0; i < state.checklist!.length; i++) {
    //   state.checklist![i].isChecked = false;
    // }
    state = state.copyWith(isCompleted: false);
  }

  String itemTitle(index) => state.checklist?[index].title ?? '';

  bool itemIsChecked(index) => state.checklist?[index].isChecked ?? false;
}
