class LaunchObj {
  final String? id;
  final String? mission_name;
  final String? details;

  LaunchObj({this.id, this.mission_name, this.details});

  factory LaunchObj.fromJson(Map<String, dynamic> json) {
    return new LaunchObj(
      id: json["id"],
      mission_name: json["mission_name"],
      details: json["details"],
    );
  }
}
