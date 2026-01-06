import 'item.dart';
import 'skill.dart';

class PlayerStats {
  int str;
  int vit;
  int agi;
  int intStat;
  int sen;

  PlayerStats({
    this.str = 10,
    this.vit = 10,
    this.agi = 10,
    this.intStat = 10,
    this.sen = 10,
  });

  Map<String, dynamic> toJson() => {
    'str': str,
    'vit': vit,
    'agi': agi,
    'int': intStat,
    'sen': sen,
  };

  factory PlayerStats.fromJson(Map<String, dynamic> json) => PlayerStats(
    str: json['str'] ?? 10,
    vit: json['vit'] ?? 10,
    agi: json['agi'] ?? 10,
    intStat: json['int'] ?? 10,
    sen: json['sen'] ?? 10,
  );
}

class ShadowSoldier {
  String name;
  String rank;
  String img; // Icon name

  ShadowSoldier({required this.name, required this.rank, required this.img});

  Map<String, dynamic> toJson() => {'name': name, 'rank': rank, 'img': img};

  factory ShadowSoldier.fromJson(Map<String, dynamic> json) =>
      ShadowSoldier(name: json['name'], rank: json['rank'], img: json['img']);
}

class Quest {
  String id;
  String desc;
  int exp;
  bool done;

  Quest({
    required this.id,
    required this.desc,
    required this.exp,
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'desc': desc,
    'exp': exp,
    'done': done,
  };
  factory Quest.fromJson(Map<String, dynamic> json) => Quest(
    id: json['id'],
    desc: json['desc'],
    exp: json['exp'],
    done: json['done'],
  );
}

class Player {
  int level;
  int exp;
  int expNext;
  int credits;
  int traces;
  int keys;
  String rank;
  String job;
  String title;
  PlayerStats stats;
  int statPoints;
  List<Skill> skills;
  List<Item> inventory;
  List<ShadowSoldier> army;
  List<Quest> dailyQuests;
  List<Quest> mainQuests;
  String lastDailyDate;
  String name;
  String avatarPath;
  bool soundEnabled;

  Player({
    this.level = 1,
    this.exp = 0,
    this.expNext = 100,
    this.credits = 500,
    this.traces = 0,
    this.keys = 1,
    this.rank = 'E-Rank',
    this.job = 'None',
    this.title = '[The Awakened One]',
    required this.stats,
    this.statPoints = 0,
    this.skills = const [],
    this.inventory = const [],
    this.army = const [],
    this.dailyQuests = const [],
    this.mainQuests = const [],
    this.lastDailyDate = '',
    this.name = 'Player',
    this.avatarPath = '',
    this.soundEnabled = true,
  });

  Map<String, dynamic> toJson() => {
    'level': level,
    'exp': exp,
    'expNext': expNext,
    'credits': credits,
    'traces': traces,
    'keys': keys,
    'rank': rank,
    'job': job,
    'title': title,
    'stats': stats.toJson(),
    'statPoints': statPoints,
    'skills': skills.map((e) => e.toJson()).toList(),
    'inventory': inventory.map((e) => e.toJson()).toList(),
    'army': army.map((e) => e.toJson()).toList(),
    'dailyQuests': dailyQuests.map((e) => e.toJson()).toList(),
    'mainQuests': mainQuests.map((e) => e.toJson()).toList(),
    'lastDailyDate': lastDailyDate,
    'name': name,
    'avatarPath': avatarPath,
    'soundEnabled': soundEnabled,
  };

  factory Player.fromJson(Map<String, dynamic> json) => Player(
    level: json['level'] ?? 1,
    exp: json['exp'] ?? 0,
    expNext: json['expNext'] ?? 100,
    credits: json['credits'] ?? 500,
    traces: json['traces'] ?? 0,
    keys: json['keys'] ?? 1,
    rank: json['rank'] ?? 'E-Rank',
    job: json['job'] ?? 'None',
    title: json['title'] ?? '[The Awakened One]',
    stats: PlayerStats.fromJson(json['stats'] ?? {}),
    statPoints: json['statPoints'] ?? 0,
    skills:
        (json['skills'] as List?)?.map((e) => Skill.fromJson(e)).toList() ?? [],
    inventory:
        (json['inventory'] as List?)?.map((e) => Item.fromJson(e)).toList() ??
        [],
    army:
        (json['army'] as List?)
            ?.map((e) => ShadowSoldier.fromJson(e))
            .toList() ??
        [],
    dailyQuests:
        (json['dailyQuests'] as List?)
            ?.map((e) => Quest.fromJson(e))
            .toList() ??
        [],
    mainQuests:
        (json['mainQuests'] as List?)?.map((e) => Quest.fromJson(e)).toList() ??
        [],
    lastDailyDate: json['lastDailyDate'] ?? '',
    name: json['name'] ?? 'Player',
    avatarPath: json['avatarPath'] ?? '',
    soundEnabled: json['soundEnabled'] ?? true,
  );
}
