import 'dart:io';
import 'package:aqaraty/components/my_snackbar.dart';
import 'package:aqaraty/pages/setting_page.dart';
import 'package:aqaraty/pages/new_log.dart';
import 'package:aqaraty/pages/panding_page.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class MyDrawer extends ConsumerStatefulWidget {
  const MyDrawer({super.key});

  @override
  ConsumerState<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends ConsumerState<MyDrawer> {
  bool showAccounts = false;

  @override
  Widget build(BuildContext context) {
    final coreProvRead = ref.read(coreProvider);
    final theme = Theme.of(context);

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.82,
      backgroundColor: theme.scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showAccounts = !showAccounts;
                });
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(28, 158, 158, 158),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.1),
                      child: ClipOval(
                        child: Image.asset(
                          "assets/images/profile.png",
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coreProvRead.user?.username ?? "Guest User",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          Text(
                            coreProvRead.user?.phonenumber ?? "No phone linked",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      showAccounts ? Iconsax.arrow_up_2 : Iconsax.arrow_down_1,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),

            // --- Accounts Section ---
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  ListTile(
                    leading: const CircleAvatar(
                      radius: 18,
                      backgroundImage: AssetImage("assets/images/profile.png"),
                    ),
                    title: const Text("Account 2"),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Iconsax.add),
                    title: const Text("إضافة حساب"),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("إضافة حساب جديد")),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
              crossFadeState: showAccounts
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),

            // --- Menu Items ---
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                children: [
                  _drawerItem(
                    isLogout: true,
                    context,
                    icon: Iconsax.cloud,
                    label: "عقارات قيد الرفع",
                    onTap: () {
                      Navigator.pop(context);
                      context.myPush(const PendingEstatesPage());
                    },
                  ),
                  _drawerItem(
                    isLogout: true,
                    context,
                    icon: Iconsax.message_question,
                    label: "Help",
                    onTap: () {},
                  ),
                  _drawerItem(
                    isLogout: true,
                    context,
                    icon: Iconsax.setting_2,
                    label: "الإعدادات",
                    onTap: () {
                      context.myPush(SettingsPage());
                    },
                  ),
                  _drawerItem(
                    isLogout: false,
                    context,
                    icon: Iconsax.logout,
                    label: "تسجيل خروج",
                    onTap: () async {
                      final res = await MySnackBar.showYesNoDialog(
                        context,
                        "هل أنت متأكد من تسجيل الخروج؟",
                      );
                      if (res) {
                        await coreProvRead.fullLogout();
                        context.myPushReplacmentAll(LoginPage());
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      required bool isLogout}) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      leading: CircleAvatar(
        backgroundColor: theme.focusColor,
        child: Icon(icon, color: theme.canvasColor, size: 24),
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isLogout ? theme.canvasColor : Colors.red,
            ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
