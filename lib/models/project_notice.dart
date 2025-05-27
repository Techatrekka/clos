class ProjectNotice {
  String title;
  String description;
  DateTime dateTime;

  ProjectNotice(this.title, this.description, this.dateTime);

  factory ProjectNotice.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'title': String title,
        'notice': String description,
        'time': DateTime dateTime,
      } =>
        ProjectNotice (title, description, dateTime),
      _ => throw const FormatException('Failed to parse Updates.'),
    };
  }
}