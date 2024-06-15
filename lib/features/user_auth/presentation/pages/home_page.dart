import 'package:flutter/material.dart';
import 'package:speech_assistnt/providers/active_theme_provider.dart';
import 'package:speech_assistnt/screens/chat_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_assistnt/constants/themes.dart';

Widget _navigateToHomePage(BuildContext context) {
    return Homepage();
}
class Homepage extends ConsumerWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      debugShowCheckedModeBanner: false,
      themeMode: activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
      home: const ChatScreen(),
    );
  }
}
