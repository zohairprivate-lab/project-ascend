import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/game_provider.dart';
import '../widgets/holo_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final p = game.player;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DAILY QUESTS
          FadeInLeft(
            duration: const Duration(milliseconds: 600),
            child: HoloCard(
              border: Border(
                left: BorderSide(color: Colors.lightGreenAccent, width: 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'DAILY QUEST: PREPARATIONS',
                    style: GoogleFonts.orbitron(
                      color: Colors.lightGreenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...p.dailyQuests.map(
                    (q) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: q.done,
                          onChanged: (v) => game.completeDaily(q.id),
                          activeColor: Colors.lightGreenAccent,
                          checkColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ), // Modern shape
                        ),
                      ),
                      title: Text(
                        q.desc,
                        style: GoogleFonts.shareTechMono(
                          color: q.done ? Colors.grey : Colors.white,
                          decoration: q.done
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      trailing: Text(
                        '+${q.exp} EXP',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          // MAIN QUESTS / GATES
          FadeInRight(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: HoloCard(
              border: Border(
                left: BorderSide(color: Colors.blueAccent, width: 4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DUNGEON GATES',
                        style: GoogleFonts.orbitron(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.blueAccent,
                          size: 28,
                        ), // Better icon
                        onPressed: () => _showAddQuestDialog(context, game),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (p.mainQuests.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'NO ACTIVE SCENARIOS',
                          style: GoogleFonts.shareTechMono(color: Colors.grey),
                        ),
                      ),
                    ),
                  ...p.mainQuests.map(
                    (q) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: Colors.blue.withOpacity(0.3),
                        ), // Subtle border
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  q.desc,
                                  style: GoogleFonts.shareTechMono(
                                    color: Colors.blue[100],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'REWARD: ${q.exp} EXP',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[900],
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: BeveledRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  4,
                                ), // Techy shape
                              ),
                            ),
                            onPressed: () => game.completeMainQuest(q.id),
                            child: Text(
                              'ENTER',
                              style: GoogleFonts.orbitron(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddQuestDialog(BuildContext context, GameProvider game) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'INITIATE SYSTEM DIRECTIVE',
          style: GoogleFonts.orbitron(color: Colors.blue, fontSize: 14),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter Objective...',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                game.addMainQuest(controller.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text('CONFIRM', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
