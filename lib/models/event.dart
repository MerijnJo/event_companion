class Event {
  final String id;
  final String title;
  final String time;
  final String location;
  final String description;
  final String tag;
  final String iconName;

  const Event({
    required this.id,
    required this.title,
    required this.time,
    required this.location,
    required this.description,
    required this.tag,
    required this.iconName,
  });
}