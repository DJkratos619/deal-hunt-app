import 'package:app_descuento_virtual/core/constants/app_colors.dart';
import 'package:app_descuento_virtual/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    ); // AnimationController
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }); // Future.delayed

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(28),
                    ), // BoxDecoration
                    child: const Icon(
                      Icons.local_offer_rounded,
                      size: 56,
                      color: Colors.white,
                    ), // Icon
                  ), // Container
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.appName,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -1,
                    ), // TextStyle
                  ), // Text
                  const SizedBox(height: 8),
                  const Text(
                    AppStrings.tagline,
                    style: TextStyle(
                      fontSize: 1,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                    ), // TextStyle
                  ),
                ],
              ), // Column
            ), // ScaleTransition
          ), // FadeTransition
        ), // Center
      ), // Container
    ); // Scaffold
  }
}
