import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
              child: Text(
                'INVENTORY EMPTY',
                style: GoogleFonts.shareTechMono(color: Colors.grey),
              ),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: inv.length,
              itemBuilder: (ctx, i) {
                final item = inv[i];
                return GestureDetector(
                  onTap: () => _showItemDetails(context, game, i, item),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      border: Border.all(
                        color: _getRarityColor(item.rarity),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: FaIcon(
                        _getIcon(item.icon),
                        color: Colors.white,
                        size: 20,
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
        return Colors.red;
      case 'Legendary':
        return Colors.yellow;
      case 'Epic':
        return Colors.purple;
      case 'Rare':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'flask':
        return FontAwesomeIcons.bottleWater;
      case 'gem':
        return FontAwesomeIcons.gem;
      case 'box':
        return FontAwesomeIcons.box;
      case 'khanda':
        return FontAwesomeIcons.khanda;
      case 'mask':
        return FontAwesomeIcons.mask;
      case 'chess-knight':
        return FontAwesomeIcons.chessKnight;
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
        title: Text(
          item.name.toUpperCase(),
          style: GoogleFonts.orbitron(color: _getRarityColor(item.rarity)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.desc,
              style: GoogleFonts.shareTechMono(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              item.type.toUpperCase(),
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CLOSE'),
          ),
          ElevatedButton(
            onPressed: () {
              game.useItem(index);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.cyan[900]),
            child: Text(
              item.type == 'consumable' || item.type == 'gacha'
                  ? 'USE'
                  : 'EQUIP',
            ),
          ),
        ],
      ),
    );
  }
}
