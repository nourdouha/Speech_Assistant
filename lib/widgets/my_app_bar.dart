import 'package:flutter/material.dart';
import '../providers/active_theme_provider.dart';
import 'theme_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../global/common/toast.dart';
import 'package:speech_assistnt/features/user_auth/presentation/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/chat_item.dart';
import '../widgets/profile.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({Key? key}) : super(key: key);
  final String username = 'mina';

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: GestureDetector(
        onTap: () {
          // Show the popup menu when the title is tapped
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(
              160, // left
              kToolbarHeight, // top
              160, // right
              0,
            ), // bottom),// Width and height of the parent widget (can be adjusted as needed)
            items: [
              PopupMenuItem(
                child: Row(
                  children: [
                    Consumer(
                      builder: (context, ref, child) => Icon(
                        ref.watch(activeThemeProvider) == Themes.dark
                            ? Icons.dark_mode
                            : Icons.light_mode,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const ThemeSwitch(),
                  ],
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                    showToast(message: "Successfully signed out");
                  },
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ),
              PopupMenuItem(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                          userName: username,
                          positivePercentage: 40.5,
                          negativePercentage: 20.1,
                          neutralPercentage: 39.4,
                          analysisResult: 'Positive',
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                  ),
                ),
              ),
            ],
          );
        },
        child: Center(
          child: Text(
            'Genius',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
