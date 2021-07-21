class StudyAid {
  int id;
  String title;
  String? content;
  List<ChecklistItem>? checklist;
  bool? isCompleted;

  StudyAid({
    required this.id,
    required this.title,
    this.content,
    this.checklist,
    this.isCompleted,
  });

  @override
  String toString() =>
      "id: $id, title: $title, content: $content, checklist: $checklist, isCompleted: $isCompleted";

  factory StudyAid.fromJson(Map<String, dynamic> json) {
    return StudyAid(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      checklist: _items(json['checklist'] ?? []),
      isCompleted: json['completed'],
    );
  }

  StudyAid copyWith({
    int? id,
    String? title,
    String? content,
    List<ChecklistItem>? checklist,
    bool? isCompleted,
  }) {
    return StudyAid(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      checklist: checklist ?? this.checklist,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static List<ChecklistItem> _items(List<dynamic> json) =>
      json.map((e) => ChecklistItem.fromJson(e)).toList();
}

class ChecklistItem {
  String title;
  bool isChecked;

  ChecklistItem(this.title, this.isChecked);

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      json['title'],
      json['checked'],
    );
  }
}
