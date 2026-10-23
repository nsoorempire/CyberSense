import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';

class SenseMark extends StatelessWidget {
  const SenseMark({super.key, this.size = 72, this.onBrand = false});

  final double size;
  final bool onBrand;

  @override
  Widget build(BuildContext context) {
    final mark = onBrand ? Colors.white : AppColors.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _MarkPainter(mark)),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.075
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final shield = Path()
      ..moveTo(w * 0.50, h * 0.08)
      ..lineTo(w * 0.86, h * 0.24)
      ..lineTo(w * 0.86, h * 0.50)
      ..quadraticBezierTo(w * 0.86, h * 0.78, w * 0.50, h * 0.93)
      ..quadraticBezierTo(w * 0.14, h * 0.78, w * 0.14, h * 0.50)
      ..lineTo(w * 0.14, h * 0.24)
      ..close();
    canvas.drawPath(shield, stroke);

    final arc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.07
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(w * 0.5, h * 0.52), radius: w * 0.16),
      math.pi * 1.15,
      math.pi * 1.7,
      false,
      arc,
    );
    canvas.drawCircle(Offset(w * 0.5, h * 0.52), w * 0.045, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _MarkPainter oldDelegate) => oldDelegate.color != color;
}

class BrandLockup extends StatelessWidget {
  const BrandLockup({super.key, this.markSize = 72, this.onBrand = false, this.showTagline = false, this.tagline});

  final double markSize;
  final bool onBrand;
  final bool showTagline;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final titleColor = onBrand ? Colors.white : Theme.of(context).colorScheme.onSurface;
    final subColor = onBrand ? Colors.white.withValues(alpha: 0.82) : Theme.of(context).textTheme.bodySmall?.color;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SenseMark(size: markSize, onBrand: onBrand),
        SizedBox(height: markSize * 0.28),
        Text(
          'Cyber Sense',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: titleColor, letterSpacing: -0.4),
        ),
        if (showTagline && tagline != null) ...[
          const SizedBox(height: 8),
          Text(tagline!, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: subColor)),
        ],
      ],
    );
  }
}

class BrandBackdrop extends StatelessWidget {
  const BrandBackdrop({super.key, required this.child, this.brand = false});

  final Widget child;
  final bool brand;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: brand
            ? AppColors.splashGradient
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: dark
                    ? const [Color(0xFF140C1C), Color(0xFF0C0A12)]
                    : const [Color(0xFFF3E9FA), Color(0xFFF6F4F8)],
              ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -40,
            child: _Glow(size: 220, color: brand ? Colors.white.withValues(alpha: 0.08) : AppColors.primary.withValues(alpha: dark ? 0.18 : 0.08)),
          ),
          Positioned(
            bottom: -60,
            left: -30,
            child: _Glow(size: 180, color: AppColors.accent.withValues(alpha: brand ? 0.16 : (dark ? 0.12 : 0.08))),
          ),
          child,
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
