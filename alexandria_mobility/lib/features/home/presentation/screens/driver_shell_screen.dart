import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';

class DriverShellScreen extends ConsumerStatefulWidget {
  final Widget child;

  const DriverShellScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<DriverShellScreen> createState() => _DriverShellScreenState();
}

class _DriverShellScreenState extends ConsumerState<DriverShellScreen> {
  int _currentIndex = 0;

  final _routes = [
    '/driver/dashboard',
    '/driver/trips',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavBar.driver(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          context.go(_routes[index]);
        },
      ),
    );
  }
}
