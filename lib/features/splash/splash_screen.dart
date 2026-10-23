import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/extensions/context_x.dart';
import '../../core/widgets/brand.dart';
import '../../state/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  @override
  void initState() {
    super.initState();
    _controller.forward();
    Future<void>.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) context.read<AuthController>().finishSplash();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    return Scaffold(
      body: BrandBackdrop(
        brand: true,
        child: Center(
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.9, end: 1).animate(animation),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: BrandLockup(onBrand: true, markSize: 92, showTagline: true, tagline: context.s.appTagline),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
