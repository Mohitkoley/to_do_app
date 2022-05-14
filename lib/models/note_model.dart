class Note {
  int? id;
  String? priority;
  String? title;
  int? status;
  DateTime? date;

  Note({this.title, this.priority, this.status, this.date});

  Note.withId({this.id, this.title, this.priority, this.status, this.date});

  Map<String, dynamic> toMap() => {
        'id': id ?? null,
        "title": title,
        "date": date!.toIso8601String(),
        "priority": priority,
        "status": status
      };

  factory Note.fromMap(Map<String, dynamic> map) => Note.withId(
      id: map["id"],
      title: map["title"],
      priority: map["priority"],
      status: map["status"],
      date: DateTime.parse(map["date"]));
}
