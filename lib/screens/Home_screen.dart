// File: lib/screens/home_screen.dart

import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:learning2/screens/notification_screen.dart';
import 'package:learning2/screens/profile_screen.dart';
import 'package:learning2/screens/dashboard_screen.dart';
import 'package:learning2/screens/schema.dart';
import 'package:learning2/screens/token_scan.dart';
import 'package:learning2/screens/live_location_screen.dart';
import '../dsr_entry_screen/dsr_entry.dart';
import 'AccountsStatementPage.dart';
import 'ActivitySummaryPage.dart';
import 'EmployeeDashboardPage.dart';
import 'GrcLeadEntryPage.dart';
import 'PainterKycTrackingPage.dart';
import 'RetailerRegistrationPage.dart';
import 'SchemeDocumentPage.dart';
import 'UniversalOutletRegistrationPage.dart';
import 'mail_screen.dart';
import 'app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  // These are the four “root” screens for bottom navigation:
  final List<Widget> _screens = [
    const HomeContent(),
    const DashboardScreen(),
    const MailScreen(),
    const ProfilePage(),
  ];

  // The currently displayed screen:
  Widget _currentScreen = const HomeContent();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Updates both the selected index and the displayed screen.
  void _updateCurrentScreen(int index, {Widget? screen}) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        _currentScreen = screen ?? _screens[index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Intercept Android “back” button:
      onWillPop: () async {
        if (_selectedIndex != 0) {
          // If we’re not on Home, send back to Home.
          _updateCurrentScreen(0);
          return false;
        }
        return true; // Let the system handle “back” when already on Home.
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        drawer: const AppDrawer(),
        body: Stack(
          children: [
            // The currently active screen (HomeContent / Dashboard / Mail / Profile):
            _currentScreen,
            // The search‐overlay (if _isSearchVisible):
            _buildSearchInput(context),
          ],
        ),
        bottomNavigationBar: _buildPremiumBottomBar(),
      ),
    );
  }

  /// Builds the gradient AppBar with a search‐icon and notifications‐icon.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 4,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue, Colors.blue],
          ),
        ),
      ),
      title: Builder(
        builder: (context) {
          final screenWidth = MediaQuery.of(context).size.width;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                color: Colors.white,
                size: (screenWidth * 0.07).clamp(24.0, 32.0),
              ),
              SizedBox(width: screenWidth * 0.02),
              Flexible(
                child: Text(
                  'SPARSH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (screenWidth * 0.065).clamp(20.0, 30.0),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        Builder(
          builder: (context) {
            final screenWidth = MediaQuery.of(context).size.width;
            return IconButton(
              icon: Icon(
                Icons.notifications_none,
                size: (screenWidth * 0.07).clamp(24.0, 32.0),
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
            );
          },
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child:
              _isSearchVisible
                  ? const SizedBox(width: 48, height: 48)
                  : Builder(
                    builder: (context) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      return IconButton(
                        key: const ValueKey('search_icon'),
                        icon: Icon(
                          Icons.search,
                          size: (screenWidth * 0.07).clamp(24.0, 32.0),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSearchVisible = true;
                          });
                        },
                      );
                    },
                  ),
        ),
      ],
    );
  }

  /// The sliding search bar that appears on top of everything else.
  Widget _buildSearchInput(BuildContext context) {
    return AnimatedOpacity(
      opacity: _isSearchVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Visibility(
        visible: _isSearchVisible,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.04,
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for reports, orders, etc...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _isSearchVisible = false;
                        _searchController.clear();
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04,
                    vertical: MediaQuery.of(context).size.width * 0.03,
                  ),
                ),
                onSubmitted: (value) {
                  // Implement your search logic here.
                  setState(() {
                    _isSearchVisible = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Bottom navigation bar with a center “floating QR scanner” button.
  Widget _buildPremiumBottomBar() {
    final screenWidth = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> navItems = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Home',
        'color': Colors.blue.shade700,
        'gradient': LinearGradient(
          colors: [Colors.blue.shade400, Colors.blue.shade700],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.dashboard_outlined,
        'activeIcon': Icons.dashboard,
        'label': 'Dashboard',
        'color': Colors.purpleAccent,
        'gradient': LinearGradient(
          colors: [Colors.purple.shade300, Colors.purpleAccent],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.qr_code_scanner,
        'activeIcon': Icons.qr_code_scanner,
        'label': 'Scan',
        'color': Colors.blueAccent,
        'gradient': LinearGradient(
          colors: [Colors.blueAccent, Colors.lightBlue.shade600],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.schema_outlined,
        'activeIcon': Icons.schema,
        'label': 'Scheme',
        'color': Colors.orange,
        'gradient': LinearGradient(
          colors: [Colors.orange.shade300, Colors.deepOrange],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
      {
        'icon': Icons.person_outline,
        'activeIcon': Icons.person,
        'label': 'Profile',
        'color': Colors.green,
        'gradient': LinearGradient(
          colors: [Colors.teal.shade300, Colors.green.shade600],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
      },
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Glass‐morphism background behind the bottom bar
        ClipPath(
          clipper: BottomNavClipper(),
          child: Container(
            height: (screenWidth * 0.25).clamp(80.0, 100.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFEAF6FF).withValues(alpha: 0.8),
                  const Color(0xFFD6ECFF).withValues(alpha: 0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 2,
                  offset: const Offset(0, -5),
                ),
              ],
              border: Border(
                top: BorderSide(
                  color: Colors.blue.withValues(alpha: 0.6),
                  width: 1.5,
                ),
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(navItems.length, (index) {
                  // Skip index 2 so we can leave a gap for the floating button
                  if (index == 2) return SizedBox(width: screenWidth * 0.18);

                  final item = navItems[index];
                  final isActive = _selectedIndex == index;
                  final color = item['color'] as Color;
                  final gradient = item['gradient'] as Gradient;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (index == 3) {
                          // “Scheme” tab: directly open Schema() screen
                          _updateCurrentScreen(index, screen: const Schema());
                        } else if (index == 4) {
                          // “Profile” tab:
                          _updateCurrentScreen(
                            index,
                            screen: const ProfilePage(),
                          );
                        } else {
                          _updateCurrentScreen(index);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: isActive ? gradient : null,
                          boxShadow:
                              isActive
                                  ? [
                                    BoxShadow(
                                      color: color.withValues(alpha: 0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isActive ? item['activeIcon'] : item['icon'],
                              color:
                                  isActive
                                      ? Colors.white
                                      : Colors.grey.shade600,
                              size: (screenWidth * 0.06).clamp(20.0, 28.0),
                            ),
                            SizedBox(height: screenWidth * 0.01),
                            Flexible(
                              child: Text(
                                item['label'],
                                style: TextStyle(
                                  fontSize: (screenWidth * 0.03).clamp(
                                    10.0,
                                    14.0,
                                  ),
                                  fontWeight:
                                      isActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                  color:
                                      isActive
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                ),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // Floating “Scanner” button in the center with shimmer/pulse animation:
        Positioned(
          bottom: screenWidth * 0.08,
          child: GestureDetector(
            onTap: () {
              _updateCurrentScreen(2, screen: const TokenScanPage());
            },
            child: Container(
                  width: (screenWidth * 0.15).clamp(50.0, 70.0),
                  height: (screenWidth * 0.15).clamp(50.0, 70.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.shade400,
                        Colors.blueAccent.shade700,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: Offset.zero,
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    color: Colors.white,
                    size: (screenWidth * 0.07).clamp(24.0, 32.0),
                  ),
                )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(
                  delay: 1000.ms,
                  duration: 1800.ms,
                  color: Colors.white.withValues(alpha: 0.3),
                )
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 1000.ms,
                  curve: Curves.easeInOut,
                ),
          ),
        ),
      ],
    );
  }
}

/// Custom clipper to “cut out” the notch for the floating button.
class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double notchRadius = 30;
    final double centerX = size.width / 2;
    const double notchWidth = notchRadius * 2 + 30;

    final path =
        Path()
          ..lineTo(centerX - notchWidth / 2, 0)
          ..quadraticBezierTo(
            centerX - notchRadius - 15,
            0,
            centerX - notchRadius,
            25,
          )
          ..arcToPoint(
            Offset(centerX + notchRadius, 25),
            radius: const Radius.circular(notchRadius),
            clockwise: false,
          )
          ..quadraticBezierTo(
            centerX + notchRadius + 15,
            0,
            centerX + notchWidth / 2,
            0,
          )
          ..lineTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

/// The “Home” tab’s main content, including banners, “Mostly Used Apps,” horizontal menu, and Quick Menu.
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late PageController _pageController;
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  /// Banner images (replace with your own assets if needed):
  final List<String> _bannerImagePaths = [
    'assets/image1.png',
    'assets/image21.jpg',
    'assets/image22.jpg',
    'assets/image23.jpg',
    'assets/image24.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (_bannerImagePaths.length > 1) {
      _startAutoScroll();
    }
    _pageController.addListener(() {
      if (_pageController.position.isScrollingNotifier.value == false) {
        _restartAutoScroll();
      }
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients) {
        timer.cancel();
        return;
      }
      double itemWidth = MediaQuery.of(context).size.width;
      double spacing = 10;
      double fullItemWidth = itemWidth + spacing;
      double maxScroll = _pageController.position.maxScrollExtent;
      double nextPosition = _currentIndex * fullItemWidth;

      if (nextPosition > maxScroll - itemWidth / 2) {
        _currentIndex = 0;
        nextPosition = 0;
      } else {
        _currentIndex++;
      }

      _pageController.animateTo(
        nextPosition,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _restartAutoScroll() {
    _autoScrollTimer?.cancel();
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _bannerImagePaths.length > 1) {
        _startAutoScroll();
      }
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.removeListener(_restartAutoScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenWidth * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: screenWidth * 0.025),
            _buildBanner(),
            SizedBox(height: screenWidth * 0.05),
            _sectionTitle("Mostly Used Apps"),
            SizedBox(height: screenWidth * 0.025),
            _mostlyUsedApps(screenWidth, screenHeight),
            SizedBox(height: screenWidth * 0.05),
            const HorizontalMenu(),
            SizedBox(height: screenWidth * 0.05),
            _sectionTitle("Quick Menu"),
            SizedBox(height: screenWidth * 0.025),
            _quickMenu(screenHeight, screenWidth),
            SizedBox(
              height: screenHeight * 0.12,
            ), // Add bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Three‐column Quick Menu with 14 items (icons + labels).
  Widget _quickMenu(double screenHeight, double screenWidth) {
    final List<Map<String, String>> quickMenuItems = [
      {
        'image': 'assets/painter_kyc_tracking.png',
        'label': 'Painter KYC\nTracking',
      },
      {
        'image': 'assets/painter_kyc_registration.png',
        'label': 'Painter KYC\nRegistration',
      },
      {
        'image': 'assets/universal_outlets_registration.png',
        'label': 'Universal Outlets\nRegistration',
      },
      {
        'image': 'assets/retailer_registration.png',
        'label': 'Retailer\nRegistration',
      },
      {
        'image': 'assets/accounts_statement.png',
        'label': 'Accounts\nStatement',
      },
      {
        'image': 'assets/information_document.png',
        'label': 'Information\nDocument',
      },
      {
        'image': 'assets/rpl_outlet_tracker.png',
        'label': 'RPL Outlet\nTracker',
      },
      {'image': 'assets/scheme_document.png', 'label': 'Scheme\nDocument'},
      {'image': 'assets/activity_summary.png', 'label': 'Activity\nSummary'},
      {'image': 'assets/purchaser_360.png', 'label': 'Purchaser\n360'},
      {
        'image': 'assets/employee_dashboard.png',
        'label': 'Employee\nDashBoard',
      },
      {'image': 'assets/grc_lead_entry.png', 'label': 'GRC\nLead Entry'},
      {'image': 'assets/rpl_6_enrolment.png', 'label': 'RPL 6\nEnrolment'},
    ];

    // Three columns to match your screenshot. Adjust to 4 if you’d prefer a 4‐column layout.
    final double itemWidth = screenWidth / 3;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: screenWidth > 600 ? 4 : (screenWidth < 350 ? 2 : 3),
          crossAxisSpacing: screenWidth * 0.03,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.85,
        ),
        itemCount: quickMenuItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final item = quickMenuItems[index];
          return InkWell(
            onTap: () {
              if (item['label']!.contains('Painter KYC\nTracking')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PainterKycTrackingPage(),
                  ),
                );
              } else if (item['label']!.contains(
                'Universal Outlets\nRegistration',
              )) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UniversalOutletRegistrationPage(),
                  ),
                );
              } else if (item['label']!.contains('Retailer\nRegistration')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RetailerRegistrationPage(),
                  ),
                );
              } else if (item['label']!.contains('Accounts\nStatement')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AccountsStatementPage(),
                  ),
                );
              } else if (item['label']!.contains('Scheme\nDocument')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SchemeDocumentPage()),
                );
              } else if (item['label']!.contains('Activity\nSummary')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ActivitySummaryPage(),
                  ),
                );
              } else if (item['label']!.contains('Employee\nDashBoard')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmployeeDashboardPage(),
                  ),
                );
              } else if (item['label']!.contains('GRC\nLead Entry')) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GrcLeadEntryPage()),
                );
              }
            },
            child: _buildQuickMenuItem(
              item['image']!,
              item['label']!,
              itemWidth,
            ),
          );
        },
      ),
    );
  }

  /// Helper to draw each Quick Menu icon + label.
  Widget _buildQuickMenuItem(String imagePath, String label, double itemWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = (screenWidth * 0.12).clamp(48.0, 64.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: iconSize,
            height: iconSize,
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (screenWidth * 0.03).clamp(10.0, 14.0),
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// “Mostly Used Apps” row (unchanged from before):
  Widget _mostlyUsedApps(double screenWidth, double screenHeight) {
    final List<Map<String, String>> mostlyUsedItems = [
      {'image': 'assets/image33.png', 'label': 'DSR', 'route': 'dsr'},
      {
        'image': 'assets/image34.png',
        'label': 'Staff\nAttendance',
        'route': 'attendance',
      },
      {
        'image': 'assets/image35.png',
        'label': 'DSR\nException',
        'route': 'dsr_exception',
      },
      {
        'image': 'assets/image36.png',
        'label': 'Token Scan',
        'route': 'scanner',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            mostlyUsedItems.map((item) {
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (item['route'] == 'dsr') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DsrEntry(),
                        ),
                      );
                    } else if (item['route'] == 'scanner') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TokenScanPage(),
                        ),
                      );
                    }
                  },
                  child: _buildMostlyUsedAppItem(
                    item['image']!,
                    item['label']!,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMostlyUsedAppItem(String imagePath, String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = (screenWidth * 0.12).clamp(48.0, 64.0);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            width: iconSize,
            height: iconSize,
            padding: EdgeInsets.all(screenWidth * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.white,
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
        ),
        SizedBox(height: screenWidth * 0.02),
        Flexible(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (screenWidth * 0.03).clamp(10.0, 14.0),
              color: Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Banner widget (responsive):
  Widget _buildBanner() {
    final screenHeight = MediaQuery.of(context).size.height;
    final bannerHeight =
        screenHeight * 0.2; // 20% of screen height, min 140, max 180
    final responsiveHeight = bannerHeight.clamp(140.0, 180.0);

    return SizedBox(
      height: responsiveHeight,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _bannerImagePaths.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    _bannerImagePaths[index],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          if (_bannerImagePaths.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_bannerImagePaths.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentIndex == index ? 16 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color:
                          _currentIndex == index
                              ? Colors.blue
                              : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

/// A simple horizontal menu bar above the Quick Menu (unchanged).
class HorizontalMenu extends StatefulWidget {
  const HorizontalMenu({super.key});

  @override
  State<HorizontalMenu> createState() => _HorizontalMenuState();
}

class _HorizontalMenuState extends State<HorizontalMenu> {
  String selected = "Quick Menu";

  final List<String> menuItems = [
    "Quick Menu",
    "Document",
    "Registration",
    "Entertainment",
    "Painter",
    "Attendance",
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final label = menuItems[index];
          final isSelected = selected == label;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: isSelected ? Colors.blue : Colors.white,
                foregroundColor: isSelected ? Colors.white : Colors.blue,
                side: BorderSide(
                  color: isSelected ? Colors.blue : Colors.grey.shade400,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: 8,
                ),
              ),
              onPressed: () {
                setState(() {
                  selected = label;
                });
              },
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
