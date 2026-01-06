import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/game_provider.dart';
import '../models/player.dart';

class ArmyScreen extends StatelessWidget {
  const ArmyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final army = game.player.army;
    final allShadows = game.allShadows;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: allShadows.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (ctx, i) {
        final shadow = allShadows[i];
        final isOwned = army.any((s) => s.name == shadow.name);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isOwned ? Colors.purple.withOpacity(0.2) : Colors.grey[900],
            border: Border.all(
              color: isOwned ? Colors.purple : Colors.grey[800]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              FaIcon(
                _getIcon(shadow.img),
                size: 40,
                color: isOwned ? Colors.purpleAccent : Colors.grey,
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
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOwned)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ACTIVE',
                    style: const TextStyle(
                      color: Colors.green,
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
                  ),
                  child: const Text('EXTRACT (100)'), // Hardcoded cost for demo
                ),
            ],
          ),
        );
      },
    );
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'chess-knight':
        return FontAwesomeIcons.chessKnight;
      case 'shield-bear':
        return FontAwesomeIcons.shieldCat; // Close enough
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
