import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const LevoApp());
}

class LevoApp extends StatelessWidget {
  const LevoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEVO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070708), // Ultra Dark Luxury Studio BG
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3200), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainAppScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00A2FF).withOpacity(0.2),
                        blurRadius: 45,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.blur_circular_rounded, size: 120, color: Colors.blueAccent);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const StudioDashboard(),
    const AssetsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: const Color(0xFF0D0D11),
        selectedItemColor: const Color(0xFF00A2FF),
        unselectedItemColor: Colors.white30,
        showUnselectedLabels: false,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_rounded), label: 'Studio'),
          BottomNavigationBarItem(icon: Icon(Icons.folder_special_rounded), label: 'Assets'),
          BottomNavigationBarItem(icon: Icon(Icons.tune_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}

// --- SCREEN 1: STUDIO DASHBOARD ---
class StudioDashboard extends StatelessWidget {
  const StudioDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LEVO STUDIO', style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.bolt, color: Colors.amber), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFF1E1E26), const Color(0xFF0F0F14)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFF00A2FF).withOpacity(0.1),
                    child: const Icon(Icons.person, color: Color(0xFF00A2FF), size: 30),
                  ),
                  const SizedBox(width: 15),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome Back, Creator', style: TextStyle(color: Colors.white54, fontSize: 14)),
                      SizedBox(height: 4),
                      Text('LEVO PREMIUM', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text('QUICK ACTIONS', style: TextStyle(color: Colors.white38, letterSpacing: 1.5, fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(height: 15),
            
            // Feature Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                _buildFeatureCard(Icons.video_library_rounded, 'Render Queue', 'Check active rendering logs', const Color(0xFF00A2FF)),
                _buildFeatureCard(Icons.auto_awesome, 'VFX Automation', 'Trigger premium filters', Colors.purpleAccent),
                _buildFeatureCard(Icons.cloud_download_rounded, 'Cloud Cloud Storage', 'Fetch branding elements', Colors.tealAccent),
                _buildFeatureCard(Icons.analytics_rounded, 'Analytics', 'Monitor short-form reach', Colors.orangeAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String sub, Color accentColor) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF13131A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: accentColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: accentColor, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
            ],
          )
        ],
      ),
    );
  }
}

// --- SCREEN 2: ASSETS MANAGEMENT ---
class AssetsScreen extends StatelessWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BRAND ASSETS'), centerTitle: true, backgroundColor: Colors.transparent),
      body: const Center(child: Text('Logo assets & config engine live soon', style: TextStyle(color: Colors.white30))),
    );
  }
}

// --- SCREEN 3: SETTINGS ---
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('STUDIO CONFIG'), centerTitle: true, backgroundColor: Colors.transparent),
      body: const Center(child: Text('VFX rendering & pipeline options', style: TextStyle(color: Colors.white30))),
    );
  }
}
