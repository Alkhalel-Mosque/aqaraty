import 'package:aqaraty/api/api.dart';
import 'package:aqaraty/components/back_ground_effict.dart';
import 'package:aqaraty/pages/home_page.dart';
import 'package:aqaraty/router/router.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageDarkState();
}

class _LoginPageDarkState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Api api = Api();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String username = _usernameController.text.trim();
      String password = _passwordController.text.trim();

      final res = await api.login(username, password);

      setState(() => _isLoading = false);

      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("تم تسجيل الدخول بنجاح!"),
            backgroundColor: Colors.green.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        context.myPushReplacment(const HomePage());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("اسم المستخدم أو كلمة المرور غير صحيحة!"),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // خلفية
          background(context),
          circl1(context),
          circl2(context),

          // المحتوى
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // شعار
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          Iconsax.home,
                          size: 40,
                          color: theme.canvasColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "مرحباً بعودتك",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.canvasColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "سجل الدخول لتستمر في إدارة عقاراتك",
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.canvasColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // فورم
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: theme.canvasColor.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _usernameController,
                            style:
                                TextStyle(color: theme.colorScheme.onPrimary),
                            decoration: InputDecoration(
                              labelText: "اسم المستخدم",
                              labelStyle: TextStyle(color: theme.canvasColor),
                              prefixIcon:
                                  Icon(Iconsax.user, color: theme.canvasColor),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: theme.focusColor,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            validator: (value) => value == null || value.isEmpty
                                ? "يرجى إدخال اسم المستخدم"
                                : null,
                          ),

                          const SizedBox(height: 20),

                          // كلمة المرور
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style:
                                TextStyle(color: theme.colorScheme.onPrimary),
                            decoration: InputDecoration(
                              labelText: "كلمة المرور",
                              labelStyle: TextStyle(color: theme.canvasColor),
                              prefixIcon:
                                  Icon(Iconsax.lock, color: theme.canvasColor),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Iconsax.eye_slash
                                      : Iconsax.eye,
                                  color: theme.canvasColor,
                                ),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: theme.focusColor,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: theme.colorScheme.primary),
                              ),
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "يرجى إدخال كلمة المرور";
                              }
                              if (value.length < 6) {
                                return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 24),

                          // زر الدخول
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.focusColor,
                                foregroundColor: theme.cardColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 3)
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "تسجيل الدخول",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Iconsax.login,
                                          size: 20,
                                          color: theme.cardColor,
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // زر نسيان كلمة المرور
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: theme.focusColor,
                              textStyle: const TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                inherit: true,
                              ),
                            ),
                            child: const Text("نسيت كلمة المرور؟"),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "© 2024 عقارتي - جميع الحقوق محفوظة",
                    style: TextStyle(color: theme.canvasColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
