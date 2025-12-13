import 'dart:async';

import 'package:flutter/material.dart';

class ModernAnalysisLoader extends StatefulWidget {
  const ModernAnalysisLoader({super.key});

  @override
  State<ModernAnalysisLoader> createState() => _ModernAnalysisLoaderState();
}

class _ModernAnalysisLoaderState extends State<ModernAnalysisLoader> {
  int _index = 0;
  final List<String> _loadingMessages = [
    "Scanning profile details...",
    "Analyzing work history...",
    "Verifying skill matches...",
    "Evaluating education...",
    "Calculating ATS score...",
    "Generating insights..."
  ];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Change text every 1.5 seconds
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      setState(() {
        _index = (_index + 1) % _loadingMessages.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Outer Glow Circle
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2563EB).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 10,
                )
              ],
            ),
            child: const CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              backgroundColor: Color(0xFFE2E8F0),
            ),
          ),
          const SizedBox(height: 32),
          
          // Changing Text with AnimatedSwitcher for smooth fade
          SizedBox(
            height: 50, // Fixed height to prevent jumping
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: SlideTransition(
                  position: Tween<Offset>(begin: const Offset(0.0, 0.5), end: Offset.zero).animate(animation),
                  child: child,
                ));
              },
              child: Text(
                _loadingMessages[_index],
                key: ValueKey<int>(_index),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}