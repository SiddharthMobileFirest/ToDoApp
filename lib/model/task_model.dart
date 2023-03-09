class TaskDetailModel {
  final String? id;
  final String title;
  final String time;
  final String description;

  TaskDetailModel(
      {required this.title,
      required this.time,
      required this.description,
      this.id});

  factory TaskDetailModel.fromJson(Map<String, dynamic> json) {
    return TaskDetailModel(
      title: json['title'],
      description: json['description'],
      time: json['time'],
      id: json['id'],
    );
  }
}
