class NoteModel {
  int? id;
  String title;
  String? body;
  String createdAt;

  NoteModel({this.id,required this.title, this.body,required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'createdAt': createdAt,
    };
  }
}