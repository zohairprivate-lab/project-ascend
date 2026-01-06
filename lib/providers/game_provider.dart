import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/item.dart';
import '../models/skill.dart';

class GameProvider extends ChangeNotifier {
  Player player = Player(stats: PlayerStats());
  late SharedPreferences _prefs;

  // Databases (Simplified versions of the JS DBs)
  final List<Skill> _allSkills = [
    Skill(id: 's_sprint', name: 'Sprint', cd: 30, desc: 'Move speed +30%.'),
    Skill(
      id: 's_stealth',
      name: 'Stealth',
      cd: 120,
      desc: 'Become invisible to enemies.',
    ),
    Skill(id: 's_bloodlust', name: 'Bloodlust', cd: 60, desc: 'Stats +20%.'),
    Skill(
      id: 's_dagger_throw',
      name: 'Dagger Toss',
      cd: 5,
      desc: 'Ranged attack.',
    ),
    Skill(
      id: 's_heal',
      name: 'Status Recovery',
      cd: 200,
      desc: 'Restore HP completely.',
    ),
  ];

  final Map<String, Item> _itemDB = {
    'pot_hp_s': Item(
      id: 'pot_hp_s',
      name: 'Small HP Potion',
      type: 'consumable',
      cost: 50,
      icon: 'flask',
      desc: 'Heals 20% HP',
    ),
    'pot_mp_s': Item(
      id: 'pot_mp_s',
      name: 'Mana Crystal',
      type: 'consumable',
      cost: 100,
      icon: 'gem',
      desc: 'Restores Mana',
    ),
    'box_gacha': Item(
      id: 'box_gacha',
      name: 'Mystery Box',
      type: 'gacha',
      cost: 200,
      icon: 'box',
      desc: 'Random Reward',
    ),
    'w_dagger': Item(
      id: 'w_dagger',
      name: "Rasaka's Fang",
      type: 'equip',
      cost: 1000,
      icon: 'khanda',
      desc: 'Atk +10',
      slot: 'hand',
      rarity: 'Rare',
    ),
    'a_head_shadow': Item(
      id: 'a_head_shadow',
      name: 'Shadow Veil',
      type: 'equip',
      cost: 3000,
      icon: 'mask',
      desc: 'Stealth +20%',
      slot: 'head',
      rarity: 'Epic',
    ),
  };

  final List<ShadowSoldier> _allShadows = [
    ShadowSoldier(name: 'Igris', rank: 'Knight', img: 'chess-knight'),
    ShadowSoldier(name: 'Tank', rank: 'Elite', img: 'shield-bear'),
    ShadowSoldier(name: 'Tusk', rank: 'Elite', img: 'hat-wizard'),
    ShadowSoldier(name: 'Beru', rank: 'Marshal', img: 'locust'),
  ];

  GameProvider() {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadData();
  }

  void _loadData() {
    String? data = _prefs.getString('player_data');
    if (data != null) {
      player = Player.fromJson(jsonDecode(data));
    } else {
      player.skills = [_allSkills[0], _allSkills[1]]; // Initial skills
    }
    _checkDailyReset();
    notifyListeners();
  }

  void _saveData() {
    _prefs.setString('player_data', jsonEncode(player.toJson()));
    notifyListeners();
  }

  void _checkDailyReset() {
    String today = DateTime.now().toIso8601String().split('T')[0];
    if (player.lastDailyDate != today) {
      player.dailyQuests = [
        Quest(id: 'dq_run', desc: 'RUN: 10KM', exp: 100),
        Quest(id: 'dq_push', desc: 'PUSH-UPS: 100', exp: 100),
        Quest(id: 'dq_sit', desc: 'SIT-UPS: 100', exp: 100),
        Quest(id: 'dq_squat', desc: 'SQUATS: 100', exp: 100),
      ];
      player.lastDailyDate = today;
      _saveData();
    }
  }

  // --- ACTIONS ---

  void addStat(String stat) {
    if (player.statPoints > 0) {
      if (stat == 'str') player.stats.str++;
      if (stat == 'vit') player.stats.vit++;
      if (stat == 'agi') player.stats.agi++;
      if (stat == 'int') player.stats.intStat++;
      if (stat == 'sen') player.stats.sen++;
      player.statPoints--;
      _saveData();
    }
  }

  void completeDaily(String id) {
    int idx = player.dailyQuests.indexWhere((q) => q.id == id);
    if (idx != -1 && !player.dailyQuests[idx].done) {
      player.dailyQuests[idx].done = true;
      _addRewards(exp: player.dailyQuests[idx].exp, credits: 10, traces: 1);
    }
  }

  void completeMainQuest(String id) {
    // Simplification: Standard reward for custom quests
    player.mainQuests.removeWhere((q) => q.id == id);
    _addRewards(exp: 150, credits: 50);
  }

  void addMainQuest(String desc) {
    player.mainQuests.add(
      Quest(
        id: 'mq_${DateTime.now().millisecondsSinceEpoch}',
        desc: desc,
        exp: 150,
      ),
    );
    _saveData();
  }

  void buyItem(String itemId) {
    if (_itemDB.containsKey(itemId)) {
      Item item = _itemDB[itemId]!;
      if (player.credits >= item.cost) {
        player.credits -= item.cost;
        player.inventory.add(Item.fromJson(item.toJson())); // Clone
        _saveData();
      }
    }
  }

  void useItem(int index) {
    Item item = player.inventory[index];
    player.inventory.removeAt(index);

    if (item.type == 'gacha') {
      // Simple gacha logic
      int roll = DateTime.now().millisecondsSinceEpoch % 3;
      Item reward = roll == 0
          ? _itemDB['pot_hp_s']!
          : (roll == 1 ? _itemDB['w_dagger']! : _itemDB['pot_mp_s']!);
      player.inventory.add(Item.fromJson(reward.toJson()));
    }
    _saveData();
  }

  void extractShadow(String shadowName) {
    var shadow = _allShadows.firstWhere(
      (s) => s.name == shadowName,
      orElse: () => ShadowSoldier(name: '', rank: '', img: ''),
    );
    if (shadow.name.isNotEmpty && player.traces >= 100) {
      // Fixed cost for simplicity
      player.traces -= 100;
      player.army.add(shadow);
      _saveData();
    }
  }

  void _addRewards({int exp = 0, int credits = 0, int traces = 0}) {
    player.exp += exp;
    player.credits += credits;
    player.traces += traces;
    _checkLevelUp();
    _saveData();
  }

  void _checkLevelUp() {
    if (player.exp >= player.expNext) {
      player.level++;
      player.exp -= player.expNext;
      player.expNext = (player.expNext * 1.2).floor();
      player.statPoints += 3;

      if (player.level > 20) player.rank = 'B-Rank';
      if (player.level > 50) player.rank = 'A-Rank';
      if (player.level > 75) player.rank = 'S-Rank';
    }
  }

  // Getters for UI
  List<Item> get shopItems => _itemDB.values.toList();
  List<ShadowSoldier> get allShadows => _allShadows;
}
