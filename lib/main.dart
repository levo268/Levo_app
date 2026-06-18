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
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

// ==========================================
// 🏗️ LEVO CORE DATA MODELS (BAAD MEIN INTEGRATE KARNE KE LIYE)
// ==========================================
class UserProfileModel {
  final String id, username, name, bio, profilePhoto, coverPhoto, dob, region, accountCreated;
  final bool isPrivate, isPremium;
  final int followers, following, posts, stories;
  final String theme;
  UserProfileModel({
    required this.id, required this.username, required this.name, required this.bio,
    required this.profilePhoto, required this.coverPhoto, required this.dob, required this.region,
    required this.accountCreated, required this.isPrivate, required this.isPremium,
    required this.followers, required this.following, required this.posts, required this.stories, required this.theme
  });
}

class PostModel {
  final String id, userId, caption, media, createdAt;
  final int likes, comments, shares;
  PostModel({required this.id, required this.userId, required this.caption, required this.media, required this.likes, required this.comments, required this.shares, required this.createdAt});
}

class MessageModel {
  final String id, senderId, receiverId, message, createdAt;
  final bool seen;
  final String deletedFor; // 'none', 'me', 'everyone'
  MessageModel({required this.id, required this.senderId, required this.receiverId, required this.message, required this.createdAt, required this.seen, required this.deletedFor});
}

// ==========================================
// 🚀 UPGRADED APP HUB (PRESERVING YOUR APP FEEL)
// ==========================================
class MainNavigationHub extends StatefulWidget {
  final String username;
  const MainNavigationHub({required this.username, super.key});
  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _currentTab = 0;
  final GlobalKey<_HomeFeedPageState> _homeKey = GlobalKey();
  final GlobalKey<_ReelsFeedPageState> _reelsKey = GlobalKey();
  final GlobalKey<_ChatLayoutInboxPageState> _chatKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeFeedPage(key: _homeKey),
      const SearchDashboardPage(),
      ReelsFeedPage(key: _reelsKey),
      ChatLayoutInboxPage(key: _chatKey),
      ProfileSystemPage(username: widget.username, isCurrentUser: true),
    ];

    return Scaffold(
      body: _pages[_currentTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xFF00E5FF),
        unselectedItemColor: Colors.white38,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (_currentTab == index) {
            // 🏠 Double Tap Features Active: Triggering multi-color animations on current views
            if (index == 0) _homeKey.currentState?._triggerMultiColorRefresh();
            if (index == 2) _reelsKey.currentState?._triggerReelsRefresh();
            if (index == 3) _chatKey.currentState?._refreshChatsMedley();
          } else {
            setState(() => _currentTab = index);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
        ],
      ),
    );
  }
}

// ==========================================
// 🏠 HOME FEED PAGE (DOUBLE TAP ENGINE)
// ==========================================
class HomeFeedPage extends StatefulWidget {
  const HomeFeedPage({super.key});
  @override
  State<HomeFeedPage> createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  bool _isLoading = false;
  Color _loaderColor = Colors.cyan;
  final List<Color> _colorWheel = [Colors.cyan, Colors.magenta, Colors.greenAccent, Colors.redAccent, Colors.orangeAccent];

  void _triggerMultiColorRefresh() {
    setState(() {
      _isLoading = true;
      _loaderColor = _colorWheel[Random().nextInt(_colorWheel.length)];
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, title: const Text('LEVO')),
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: _loaderColor))
          : const Center(child: Text('Home Content & Stories (Double Tap Home Icon to Spin Refresh)')),
    );
  }
}

// ==========================================
// 🎬 REELS FEED PAGE (DOUBLE TAP REFRESH)
// ==========================================
class ReelsFeedPage extends StatefulWidget {
  const ReelsFeedPage({super.key});
  @override
  State<ReelsFeedPage> createState() => _ReelsFeedPageState();
}

class _ReelsFeedPageState extends State<ReelsFeedPage> {
  bool _isLoading = false;
  Color _loaderColor = Colors.cyan;
  final List<Color> _colorWheel = [Colors.purpleAccent, Colors.tealAccent, Colors.yellowAccent, Colors.redAccent];

  void _triggerReelsRefresh() {
    setState(() {
      _isLoading = true;
      _loaderColor = _colorWheel[Random().nextInt(_colorWheel.length)];
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading 
          ? Center(child: CircularProgressIndicator(color: _loaderColor))
          : const Center(child: Text('Reels Feed (Double Tap Reel Icon to Refresh)')),
    );
  }
}

// ==========================================
// 🔍 SEARCH SYSTEM (OPACITY LOGIC & SEE ALL)
// ==========================================
class SearchDashboardPage extends StatefulWidget {
  const SearchDashboardPage({super.key});
  @override
  State<SearchDashboardPage> createState() => _SearchDashboardPageState();
}

class _SearchDashboardPageState extends State<SearchDashboardPage> {
  final List<String> _results = ['vikash_ae', 'elisa_ae', 'milli_editor', 'nexus_vfx'];
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: const InputDecoration(hintText: 'Search Levo ID...', border: InputBorder.none),
        ),
      ),
      body: _query.isEmpty
          ? const Center(child: Text('Search Dashboard Standard View'))
          : ListView.builder(
              itemCount: _results.length + 1,
              itemBuilder: (ctx, index) {
                if (index == _results.length) {
                  return Center(
                    child: TextButton(onPressed: () {}, child: const Text('See All Results', style: TextStyle(color: Colors.white60, fontWeight: FontWeight.bold))),
                  );
                }
                // Opacity animation formula: Top account 100%, lower accounts transition down to 30% baseline safely
                double opacityFactor = index == 0 ? 1.0 : max(0.3, 1.0 - (index * 0.25));
                return AnimatedOpacity(
                  opacity: opacityFactor,
                  duration: const Duration(milliseconds: 350),
                  child: ListTile(
                    leading: const CircleAvatar(backgroundColor: Colors.white10, child: Icon(Icons.person)),
                    title: Text('@${_results[index]}'),
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                        builder: (_) => ProfileSystemPage(username: _results[index], isCurrentUser: false),
                      ));
                    },
                  ),
                );
              },
            ),
    );
  }
}

// ==========================================
// 💬 CHATBOX (TABS, LOCK CHAT & DELETE CHANNELS)
// ==========================================
class ChatLayoutInboxPage extends StatefulWidget {
  const ChatLayoutInboxPage({super.key});
  @override
  State<ChatLayoutInboxPage> createState() => _ChatLayoutInboxPageState();
}

class _ChatLayoutInboxPageState extends State<ChatLayoutInboxPage> {
  bool _isRefreshing = false;
  Color _loadingColor = Colors.cyan;
  final List<Color> _colorWheel = [Colors.blue, Colors.purple, Colors.orange];

  void _refreshChatsMedley() {
    setState(() {
      _isRefreshing = true;
      _loadingColor = _colorWheel[Random().nextInt(_colorWheel.length)];
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => _isRefreshing = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Primary, Private/Hidden, and Requests boxes mapped cleanly without loose layout nodes
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Messages'),
          bottom: const TabBar(
            indicatorColor: Color(0xFF00E5FF),
            tabs: [Tab(text: 'Primary'), Tab(text: 'Private/Hidden'), Tab(text: 'Requests')],
          ),
        ),
        body: _isRefreshing
            ? Center(child: CircularProgressIndicator(color: _loadingColor))
            : TabBarView(
                children: [
                  _buildInboxCategoryList('Primary Engine'),
                  _buildInboxCategoryList('Locked Engine (PIN Required)'),
                  _buildInboxCategoryList('Message Request Buffer'),
                ],
              ),
      ),
    );
  }

  Widget _buildInboxCategoryList(String title) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, idx) => ListTile(
        leading: const CircleAvatar(child: Icon(Icons.chat_bubble_outline)),
        title: Text('Chat Channel Node $idx'),
        subtitle: Text('Context inside $title'),
        onLongPress: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Hide & Lock Chat'), onTap: () => Navigator.pop(ctx)),
                ListTile(leading: const Icon(Icons.delete_sweep_outlined), title: const Text('Remove For Me'), onTap: () => Navigator.pop(ctx)),
                ListTile(leading: const Icon(Icons.delete_forever, color: Colors.red), title: const Text('Remove For Everyone'), onTap: () => Navigator.pop(ctx)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 👤 PROFILE SYSTEM (REPORT ACCOUNT RULES & COPYS)
// ==========================================
class ProfileSystemPage extends StatefulWidget {
  final String username;
  final bool isCurrentUser;
  const ProfileSystemPage({required this.username, required this.isCurrentUser, super.key});
  @override
  State<ProfileSystemPage> createState() => _ProfileSystemPageState();
}

class _ProfileSystemPageState extends State<ProfileSystemPage> {
  bool _isPrivate = false;
  String _dob = "Add DOB";
  bool _isFollowing = false;
  bool _isFollowBackReceived = true; 

  // Strict rule logic setup: Only show Username, Created Date, and Region inside this panel axis
  void _openStrictReportPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF121212),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(child: Text('About This Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.redAccent))),
            const Divider(height: 30),
            Text('👤 Account Username: @${widget.username}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text('📅 Date Created: 18 June 2026', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Text('📍 Region: India (IN)', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  void _copyLinkAndLaunchBrowser() async {
    final Uri webUrl = Uri.parse('https://levo.example.com/${widget.username}');
    if (!await launchUrl(webUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $webUrl node connection.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('@${widget.username}'),
        actions: [
          IconButton(icon: const Icon(Icons.info_outline), onPressed: _openStrictReportPanel),
          if (widget.isCurrentUser) IconButton(icon: const Icon(Icons.settings), onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => ListView(
                shrinkWrap: true,
                children: [
                  SwitchListTile(
                    title: const Text('Private Account Mode'),
                    value: _isPrivate,
                    onChanged: (v) => setState(() => _isPrivate = v),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            Text('DOB Config: $_dob', style: const TextStyle(color: Colors.white54)),
            const SizedBox(height: 15),
            if (!widget.isCurrentUser) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: () => setState(() => _isFollowing = !_isFollowing), child: Text(_isFollowing ? 'Unfollow' : 'Follow')),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: (_isFollowing && _isFollowBackReceived) ? () {} : null, child: const Text('Message')),
                ],
              ),
              const SizedBox(height: 15),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 3.5,
                children: [
                  ElevatedButton(onPressed: () => setState(() => _dob = "24-10-2002"), child: const Text('Edit Profile')),
                  ElevatedButton(onPressed: () {}, child: const Text('Share Profile')),
                  ElevatedButton(onPressed: _copyLinkAndLaunchBrowser, child: const Text('Copy Link')),
                  ElevatedButton(onPressed: () {}, child: const Text('QR Code')),
                ],
              ),
            ),
            const Divider(height: 30),
            GridView.builder(
              shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              itemCount: 6,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 2, mainAxisSpacing: 2),
              itemBuilder: (ctx, idx) => GestureDetector(
                onTap: () => Navigator.of(context).push(ImmersiveZoomRoute(postIdx: idx)),
                child: Hero(
                  tag: 'post_hero_node_$idx',
                  child: Container(color: Colors.grey[900], child: const Center(child: Icon(Icons.play_arrow))),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 🎬 IMMERSIVE BOTTOM-UP ZOOM ROUTE ANIMATION
// ==========================================
class ImmersiveZoomRoute extends PageRouteBuilder {
  final int postIdx;
  ImmersiveZoomRoute({required this.postIdx})
      : super(
          pageBuilder: (context, anim, secAnim) => Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(backgroundColor: Colors.transparent),
            body: Center(
              child: Hero(
                tag: 'post_hero_node_$postIdx',
                child: Container(
                  width: double.infinity, height: 400, color: Colors.grey[900],
                  child: const Center(child: Icon(Icons.play_circle, size: 70, color: Color(0xFF00E5FF))),
                ),
              ),
            ),
          ),
          transitionsBuilder: (context, anim, secAnim, child) {
            // Cubic slide up layered with scale enlargement matching professional specs perfectly
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(CurvedAnimation(parent: anim, curve: Curves.fastOutSlowIn)),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: anim, curve: Curves.fastOutSlowIn)),
                child: child,
              ),
            );
          },
        );
}
// ==========================================================
// 🚀 LEVO ADVANCED FEATURE MODULES (DO NOT DELETE ABOVE CODE)
// ==========================================================

class LevoFeatureEngine {
  // 💬 Unknown users ko 8/10 message limit lagane ka rules system
  static Future<bool> validateMessageLimit(int currentSentCount, DateTime loginTime) async {
    int hoursPassed = DateTime.now().difference(loginTime).inHours;
    if (hoursPassed < 24) {
      return true; // Pehle 24 hours sabhi naye users ke liye free send access hai
    }
    if (currentSentCount >= 8) {
      return false; // 24 hours baad unknown users ko 8/10 message par stop lag jayega
    }
    return true;
  }

  // 🔍 Search suggestions opacity transition calculation formula
  static double calculateSearchOpacity(int index) {
    if (index == 0) return 1.0; // Starting target top ID fully visible (100%)
    return (1.0 - (index * 0.25)).clamp(0.3, 1.0); // Baki niche wale slightly opacity matrix (30% baseline) mein aayenge
  }

  // 🎨 Multi-color indicator loader wheel for double tap refresh
  static Color getNextRefreshColor(int tapCount) {
    final List<Color> colorWheel = [
      const Color(0xFF00E5FF), // Neon Cyan
      const Color(0xFFFF007F), // Neon Pink
      const Color(0xFF00E676), // Bio Green
      const Color(0xFFFF9100), // Amber Sunset
    ];
    return colorWheel[tapCount % colorWheel.length];
  }
}

// 🎬 Immersive Post & Reel Bottom-Up Zoom Presentation UI Route
class LevoZoomAnimationRoute extends PageRouteBuilder {
  final Widget page;
  LevoZoomAnimationRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
                  .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.7, end: 1.0)
                    .animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
                child: child,
              ),
            );
          },
        );
}
