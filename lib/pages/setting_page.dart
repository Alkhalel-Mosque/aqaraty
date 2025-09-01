import 'package:aqaraty/api/local_data/currency2.dart';
import 'package:aqaraty/provider/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = info.version;
    });
  }

  @override
  Widget build(BuildContext context) {
    final core = ref.watch(coreProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: theme.canvasColor,
        ),
        title: Text(
          "الإعدادات",
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.outline,
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Column(
              children: [
                SwitchListTile(
                    activeColor: theme.canvasColor,
                    secondary: core.isDark
                        ? const Icon(Icons.dark_mode)
                        : const Icon(Icons.light_mode),
                    title: core.isDark
                        ? const Text("الوضع الليلي")
                        : const Text("الوضع النهاري"),
                    value: core.isDark,
                    onChanged: (val) {
                      core.toggleTheme(val);
                    }),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Iconsax.call, color: Colors.blue),
                  title: const Text("تواصل معنا"),
                  subtitle: const Text("راسل فريق الدعم الفني"),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text("تواصل معنا"),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Icons.email),
                                    title: Text("support@aqaraty.com"),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.phone),
                                    title: Text("+963 999 888 777"),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("إغلاق"))
                              ],
                            ));
                  },
                ),
                ListTile(
                  leading:
                      const Icon(Iconsax.dollar_circle, color: Colors.orange),
                  title: const Text("سعر صرف الليرة مقابل الدولار"),
                  subtitle: Text("الحالي: ${core.exchangeRates[Currency.SYP]}"),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        final controller = TextEditingController(
                          text: core.exchangeRates[Currency.SYP]?.toString(),
                        );
                        return AlertDialog(
                          title: const Text("تحديث سعر الصرف"),
                          content: TextField(
                            controller: controller,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "أدخل السعر الجديد",
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                      Theme.of(context).focusColor)),
                              onPressed: () {
                                final value = double.tryParse(controller.text);
                                if (value != null) {
                                  core.updateExchangeRate(Currency.SYP, value);
                                }
                                Navigator.pop(context);
                              },
                              child: const Text("حفظ"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Iconsax.info_circle, color: Colors.green),
                  title: const Text("عن التطبيق"),
                  subtitle: Text("الإصدار $appVersion"),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
