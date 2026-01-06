import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/game_provider.dart';
import 'widgets/stat_radar.dart';
import 'screens/dashboard_screen.dart';
import 'screens/inventory_screen.dart';
import 'screens/army_screen.dart';
import 'screens/skills_screen.dart';
import 'screens/shop_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GameProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LevelUpSolo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.cyanAccent,
        textTheme: GoogleFonts.rajdhaniTextTheme(
          Theme.of(context).textTheme,
        ).apply(bodyColor: Colors.white, displayColor: Colors.white),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        colorScheme: const ColorScheme.dark(
          primary: Colors.cyanAccent,
          secondary: Colors.purpleAccent,
        ),
      ),
      home: const MainLayout(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<GameProvider>(context).player;

    return Scaffold(
      body: Stack(
        children: [
          // Background Effects
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [Color(0xFF0F172A), Colors.black],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // HEADER
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        color: Colors.cyanAccent,
                        margin: const EdgeInsets.only(right: 12),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SYSTEM',
                            style: GoogleFonts.orbitron(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.transparent,
                              shadows: [
                                const Shadow(
                                  color: Colors.cyanAccent,
                                  offset: Offset(0, 0),
                                  blurRadius: 10,
                                ),
                              ],
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.cyanAccent,
                            ),
                          ),
                          Text(
                            'MONARCH OS v4.1',
                            style: GoogleFonts.shareTechMono(
                              color: Colors.cyan,
                              fontSize: 10,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            player.name.toUpperCase(),
                            style: GoogleFonts.orbitron(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            player.title,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // PLAYER STATS CARD (Condensed)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      // Level
                      Column(
                        children: [
                          Text(
                            'LEVEL',
                            style: GoogleFonts.shareTechMono(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '${player.level}',
                            style: GoogleFonts.orbitron(
                              fontSize: 24,
                              color: Colors.cyanAccent,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // EXP Bar
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'EXP',
                                  style: GoogleFonts.shareTechMono(
                                    fontSize: 10,
                                    color: Colors.cyan,
                                  ),
                                ),
                                Text(
                                  '${player.exp} / ${player.expNext}',
                                  style: GoogleFonts.shareTechMono(
                                    fontSize: 10,
                                    color: Colors.cyan,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: player.exp / player.expNext,
                              backgroundColor: Colors.black,
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.cyanAccent,
                              ),
                              minHeight: 4,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Currency
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${player.credits} G',
                            style: GoogleFonts.shareTechMono(
                              color: Colors.amber,
                            ),
                          ),
                          Text(
                            '${player.traces} T',
                            style: GoogleFonts.shareTechMono(
                              color: Colors.purpleAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // TABS
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Colors.cyanAccent,
                  labelColor: Colors.cyanAccent,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: GoogleFonts.orbitron(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: 'DASHBOARD'),
                    Tab(text: 'INVENTORY'),
                    Tab(text: 'ARMY'),
                    Tab(text: 'SKILLS'),
                    Tab(text: 'SHOP'),
                  ],
                ),

                // CONTENT
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      DashboardScreen(),
                      InventoryScreen(),
                      ArmyScreen(),
                      SkillsScreen(),
                      ShopScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.black87,
              content: SizedBox(
                width: 300,
                child: StatRadar(
                  values: [
                    player.stats.str,
                    player.stats.vit,
                    player.stats.agi,
                    player.stats.intStat,
                    player.stats.sen,
                  ],
                ),
              ),
            ),
          );
        },
        backgroundColor: Colors.cyanAccent.withOpacity(0.2),
        shape: BeveledRectangleBorder(
          side: const BorderSide(color: Colors.cyanAccent),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Icon(Icons.analytics, color: Colors.cyanAccent),
      ),
    );
  }
}
