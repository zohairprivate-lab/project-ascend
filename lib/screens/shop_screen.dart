import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animate_do/animate_do.dart';
import '../providers/game_provider.dart';
import '../widgets/holo_card.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  IconData _getIcon(String iconName) {
    switch (iconName) {
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
      default:
        return FontAwesomeIcons.bagShopping;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, child) {
        final items = game.shopItems;
        final p = game.player;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeInDown(
                duration: const Duration(milliseconds: 600),
                child: HoloCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CREDITS',
                        style: GoogleFonts.orbitron(
                          fontSize: 16,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        '${p.credits}',
                        style: GoogleFonts.orbitron(
                          fontSize: 24,
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                itemBuilder: (ctx, i) {
                  final item = items[i];
                  return FadeInUp(
                    duration: const Duration(milliseconds: 500),
                    delay: Duration(milliseconds: i * 100),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blueAccent.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blueAccent.withOpacity(0.5),
                            ),
                          ),
                          child: Center(
                            child: FaIcon(
                              _getIcon(item.icon),
                              color: Colors.cyanAccent,
                              size: 24,
                            ),
                          ),
                        ),
                        title: Text(
                          item.name,
                          style: GoogleFonts.orbitron(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            item.desc,
                            style: GoogleFonts.shareTechMono(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: p.credits >= item.cost
                                ? Colors.blue[900]
                                : Colors.grey[900],
                            foregroundColor: p.credits >= item.cost
                                ? Colors.cyanAccent
                                : Colors.grey,
                            side: BorderSide(
                              color: p.credits >= item.cost
                                  ? Colors.cyanAccent
                                  : Colors.grey,
                            ),
                            shape: BeveledRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: p.credits >= item.cost ? 5 : 0,
                          ),
                          onPressed: p.credits >= item.cost
                              ? () {
                                  game.buyItem(item.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'PURCHASED: ${item.name}',
                                        style: GoogleFonts.orbitron(),
                                      ),
                                      backgroundColor: Colors.blueAccent,
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                }
                              : null,
                          child: Text(
                            '${item.cost} C',
                            style: GoogleFonts.shareTechMono(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
