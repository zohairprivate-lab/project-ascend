class Skill {
  String id;
  String name;
  int cd; // Cooldown in seconds
  String desc;
  int lastUsed; // Timestamp in milliseconds

  Skill({
    required this.id,
    required this.name,
    required this.cd,
    required this.desc,
    this.lastUsed = 0,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cd': cd,
    'desc': desc,
    'lastUsed': lastUsed,
  };

  factory Skill.fromJson(Map<String, dynamic> json) => Skill(
    id: json['id'],
    name: json['name'],
    cd: json['cd'],
    desc: json['desc'],
    lastUsed: json['lastUsed'] ?? 0,
  );
}
