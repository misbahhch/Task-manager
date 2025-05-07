class Task {
  String title;
  bool isComplete;

  Task({required this.title, this.isComplete = false});

  
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isComplete': isComplete,
    };
  }

  
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      isComplete: map['isComplete'],
    );
  }
}
