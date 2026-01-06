class Item {
  String id;
  String name;
  String type; // 'consumable', 'equip', 'material', 'key', 'gacha'
  int cost;
  String icon; // FontAwesome icon name mapped to a string
  String desc;
  String? slot; // 'hand', 'head', 'chest', 'feet', 'hand_armor'
  int sellPrice;
  String rarity; // 'Common', 'Rare', 'Epic', 'Legendary', 'Mythic'

  Item({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    required this.icon,
    required this.desc,
    this.slot,
    this.sellPrice = 0,
    this.rarity = 'Common',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type,
    'cost': cost,
    'icon': icon,
    'desc': desc,
    'slot': slot,
    'sellPrice': sellPrice,
    'rarity': rarity,
  };

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    id: json['id'],
    name: json['name'],
    type: json['type'],
    cost: json['cost'],
    icon: json['icon'],
    desc: json['desc'],
    slot: json['slot'],
    sellPrice: json['sellPrice'] ?? 0,
    rarity: json['rarity'] ?? 'Common',
  );
}
