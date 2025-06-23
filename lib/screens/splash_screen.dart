import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'Home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _showLogin = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _animationController.forward();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    const splashDuration = Duration(seconds: 3);

    print('SplashScreen: isLoggedIn = $isLoggedIn');

    if (isLoggedIn) {
      Future.delayed(splashDuration, () {
        if (mounted) {
          print('SplashScreen: Navigating to HomeScreen');
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) =>
                      const HomeScreen(),
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        }
      });
    } else {
      // Instead of navigating away, show the login screen with animation
      Future.delayed(splashDuration, () {
        if (mounted) {
          setState(() {
            _showLogin = true;
          });
        }
      });
    }
  }

  void _handleSwipeUp() {
    print('SplashScreen: _handleSwipeUp called');
    setState(() {
      _showLogin = true;
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Container buildImageContainer(double width, double height, Image image) {
    return Container(
      width: width,
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(10), child: image),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: Stack(
        children: [
          // Background Images
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  buildImageContainer(
                    width,
                    height * 0.2,
                    Image.asset('assets/image11.png', fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildImageContainer(
                        width * 0.4,
                        height * 0.2,
                        Image.asset('assets/image12.png', fit: BoxFit.cover),
                      ),
                      buildImageContainer(
                        width * 0.5,
                        height * 0.2,
                        Image.asset('assets/image13.png', fit: BoxFit.cover),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildImageContainer(
                        width * 0.5,
                        height * 0.2,
                        Image.asset('assets/image14.png', fit: BoxFit.contain),
                      ),
                      buildImageContainer(
                        width * 0.5,
                        height * 0.2,
                        Image.asset('assets/image15.png', fit: BoxFit.contain),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildImageContainer(
                        width * 0.4,
                        height * 0.2,
                        Image.asset('assets/image16.png', fit: BoxFit.contain),
                      ),
                      buildImageContainer(
                        width * 0.5,
                        height * 0.2,
                        Image.asset('assets/image17.png', fit: BoxFit.contain),
                      ),
                    ],
                  ),
                  buildImageContainer(
                    width * 0.9,
                    height * 0.2,
                    Image.asset('assets/image18.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.shade900.withValues(alpha: 0.85),
                    Colors.blue.shade700.withValues(alpha: 0.85),
                    Colors.cyan.shade400.withValues(alpha: 0.85),
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo animation
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 3.14159,
                        child: Container(
                          width: (width * 0.6).clamp(200.0, 300.0),
                          height: (height * 0.12).clamp(80.0, 120.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.02,
                            vertical: height * 0.005,
                          ),
                          child: Image.asset(
                            'assets/logo.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Title animations
                AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: Column(
                        children: [
                          Text(
                            'Welcome to',
                            style: TextStyle(
                              fontSize: (width * 0.07).clamp(22.0, 32.0),
                              color: Colors.white70,
                              fontWeight: FontWeight.w300,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: height * 0.012),
                          ShaderMask(
                            shaderCallback:
                                (bounds) => LinearGradient(
                                  colors: [
                                    Colors.white,
                                    Colors.white.withValues(alpha: 0.8),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ).createShader(bounds),
                            child: Text(
                              'SPARSH',
                              style: TextStyle(
                                fontSize: (width * 0.12).clamp(36.0, 56.0),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: width * 0.01,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      Text(
                        'Developed By',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: (width * 0.04).clamp(14.0, 18.0),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: height * 0.006),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Birla White IT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (width * 0.045).clamp(16.0, 20.0),
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(width: width * 0.02),
                          Icon(
                            Icons.favorite,
                            color: Colors.red.shade400,
                            size: (width * 0.05).clamp(18.0, 24.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Login screen slide up animation
          if (_showLogin)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height:
                  MediaQuery.of(context).size.height *
                  0.9, // Take up 90% of screen height
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    child: LoginScreen(),
                  ),
                ),
              ),
            ),

          // Swipe up indicator when login is not showing
          if (!_showLogin)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    setState(() {
                      _showLogin = true;
                    });
                  }
                },
                child: Column(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.white,
                      size: (width * 0.09).clamp(28.0, 40.0),
                    ),
                    SizedBox(height: height * 0.01),
                    Text(
                      'Swipe up to login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: (width * 0.04).clamp(14.0, 18.0),
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
