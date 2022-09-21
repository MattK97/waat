class Event {
  final String name;
  final String info;

  Event({this.name, this.info});

  factory Event.fromJson(Map<String, dynamic> map) {
    return Event(
      name: map['name'] as String,
      info: map['info'] as String,
    );
  }
}
