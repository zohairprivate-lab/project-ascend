import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/game_provider.dart';
import '../models/item.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = Provider.of<GameProvider>(context);
    final inv = game.player.inventory;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: inv.isEmpty
          ? Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 800),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FontAwesomeIcons.boxOpen,
                      size: 48,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'INVENTORY EMPTY',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: inv.length,
              itemBuilder: (ctx, i) {
                final item = inv[i];
                return FadeInUp(
                  duration: const Duration(milliseconds: 500),
                  delay: Duration(
                    milliseconds: (i * 50).clamp(0, 1000),
                  ), // Staggered Effect
                  child: GestureDetector(
                    onTap: () => _showItemDetails(context, game, i, item),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getRarityColor(item.rarity).withOpacity(0.8),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getRarityColor(
                              item.rarity,
                            ).withOpacity(0.4),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Center(
                        child: FaIcon(
                          _getIcon(item.icon),
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Mythic':
        return Colors.redAccent;
      case 'Legendary':
        return Colors.amber;
      case 'Epic':
        return Colors.purpleAccent;
      case 'Rare':
        return Colors.blueAccent;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'flask':
        return FontAwesomeIcons.flask;
      case 'gem':
        return FontAwesomeIcons.gem;
      case 'box':
        return FontAwesomeIcons.boxOpen;
      case 'khanda':
        return FontAwesomeIcons.khanda;
      case 'mask':
        return FontAwesomeIcons.mask;
      case 'shield':
        return FontAwesomeIcons.shieldHalved;
      case 'hat-wizard':
        return FontAwesomeIcons.hatWizard;
      default:
        return FontAwesomeIcons.circleQuestion;
    }
  }

  void _showItemDetails(
    BuildContext context,
    GameProvider game,
    int index,
    Item item,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: _getRarityColor(item.rarity), width: 2),
        ),
        title: Text(
          item.name.toUpperCase(),
          style: GoogleFonts.orbitron(
            color: _getRarityColor(item.rarity),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.desc,
              style: GoogleFonts.shareTechMono(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getRarityColor(item.rarity).withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                item.type.toUpperCase(),
                style: GoogleFonts.orbitron(
                  color: _getRarityColor(item.rarity),
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: GoogleFonts.shareTechMono(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              game.useItem(index);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getRarityColor(item.rarity).withOpacity(0.8),
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: Text(
              item.type == 'consumable' || item.type == 'gacha'
                  ? 'USE'
                  : 'EQUIP',
              style: GoogleFonts.orbitron(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
