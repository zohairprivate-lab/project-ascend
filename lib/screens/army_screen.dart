import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/game_provider.dart';

class ArmyScreen extends StatelessWidget {
  const ArmyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final army = game.player.army;
    final allShadows = game.allShadows;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SHADOW ARMY',
                  style: GoogleFonts.orbitron(
                    fontSize: 18,
                    color: Colors.purpleAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${army.length} / ${allShadows.length}',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: allShadows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (ctx, i) {
              final shadow = allShadows[i];
              final isOwned = army.any((s) => s.name == shadow.name);

              return FadeInUp(
                duration: const Duration(milliseconds: 500),
                delay: Duration(milliseconds: i * 100),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isOwned
                        ? Colors.purple.withOpacity(0.15)
                        : Colors.black54,
                    border: Border.all(
                      color: isOwned ? Colors.purpleAccent : Colors.grey[800]!,
                      width: isOwned ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isOwned
                        ? [
                            BoxShadow(
                              color: Colors.purple.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isOwned
                              ? Colors.purpleAccent.withOpacity(0.2)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isOwned
                                ? Colors.purpleAccent
                                : Colors.grey[700]!,
                          ),
                        ),
                        child: Center(
                          child: FaIcon(
                            _getIcon(shadow.img),
                            size: 24,
                            color: isOwned ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shadow.name,
                              style: GoogleFonts.orbitron(
                                color: isOwned ? Colors.white : Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              shadow.rank.toUpperCase(),
                              style: GoogleFonts.shareTechMono(
                                color: isOwned
                                    ? Colors.purple[200]
                                    : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isOwned)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.greenAccent),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.greenAccent.withOpacity(0.1),
                          ),
                          child: Text(
                            'EXTRACTED',
                            style: GoogleFonts.orbitron(
                              color: Colors.greenAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      else
                        ElevatedButton(
                          onPressed: game.player.traces >= 100
                              ? () => game.extractShadow(shadow.name)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[800],
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey[800],
                            disabledForegroundColor: Colors.grey[600],
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.download, size: 14),
                              const SizedBox(width: 4),
                              const Text('100'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'chess-knight':
        return FontAwesomeIcons.chessKnight;
      case 'shield-bear':
        return FontAwesomeIcons.shieldCat;
      case 'dumbbell':
        return FontAwesomeIcons.dumbbell;
      case 'hat-wizard':
        return FontAwesomeIcons.hatWizard;
      case 'dragon':
        return FontAwesomeIcons.dragon;
      case 'locust':
        return FontAwesomeIcons.locust;
      case 'skull':
        return FontAwesomeIcons.skull;
      default:
        return FontAwesomeIcons.ghost;
    }
  }
}
