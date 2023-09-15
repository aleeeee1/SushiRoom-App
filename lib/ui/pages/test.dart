import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sushi_room/services/internal_api.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  InternalAPI internalAPI = Get.find<InternalAPI>();

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: [
          FutureBuilder(
            future: internalAPI.isDynamicThemeSupported(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!) {
                return ListTile(
                  title: const Text("Dynamic Theme"),
                  trailing: ThemeSwitcher(
                    builder: (ctx) => Switch(
                      value: internalAPI.isDynamicTheme,
                      onChanged: (value) {
                        internalAPI.setDynamicMode(value, ctx);
                      },
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test'),
          actions: [
            ThemeSwitcher(
              builder: (ctx) => IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 1.0),
                      end: const Offset(0.0, 0.0),
                    ).animate(anim);

                    final bounceAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(anim);

                    final fadeAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(anim);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: ScaleTransition(
                        scale: bounceAnimation,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: !internalAPI.isDarkMode
                      ? const Icon(
                          Icons.dark_mode,
                          key: ValueKey('dark'), // <-- senza key nva
                        )
                      : const Icon(
                          Icons.light_mode,
                          key: ValueKey('light'),
                        ),
                ),
                onPressed: () {
                  internalAPI.setDarkMode(!internalAPI.isDarkMode, ctx);
                },
              ),
            )
          ],
        ),
        drawer: drawer(),
      ),
    );
  }
}
