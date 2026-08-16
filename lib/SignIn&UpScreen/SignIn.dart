import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- ROUTING UPDATED TO GATEWAY ---
import 'package:trandtribe/RoleGateway.dart';
import 'package:trandtribe/SignIn&UpScreen/SignUp.dart';
import '../Widgets/CommonTextField.dart';
import '../Widgets/RoundedButton.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = true;
  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    // Kept your case-insensitive logic
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
          "Missing Input", "Please supply both email and password keys.",
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      Get.snackbar("Welcome Back", "Authentication verification clear.",
          backgroundColor: Colors.green, colorText: Colors.white);

      // --- NAVIGATE TO GATEWAY ---
      Get.offAll(() => const RoleGateway(), transition: Transition.fadeIn);
    } on AuthException catch (e) {
      Get.snackbar("Access Denied", e.message,
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar(
          "Network Error", "Unable to declare server context handshake.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSocialLoginNotice() {
    Get.snackbar("Coming Soon",
        "Social login integration will be completed in the final phase.",
        backgroundColor: const Color(0xFF18181A),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Welcome Back!",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF18181A),
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text("Log in to your existing account",
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 40),
              const Text("Email",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              CommonTextField(
                controller: emailController,
                text: "Enter your email address",
                obscure: false,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text("Password",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              CommonTextField(
                controller: passwordController,
                text: "Enter your password",
                obscure: _isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                      _isPasswordVisible ? Iconsax.eye_slash : Iconsax.eye,
                      color: Colors.grey.shade600,
                      size: 20),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: const Text("Forget Password?",
                        style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF18181A))),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFFF5E1F)))
                  : RoundedButton(
                      title: "Log In",
                      onTap: _handleSignIn,
                      width: double.infinity,
                    ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text('Or',
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w700)),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: _showSocialLoginNotice,
                child: Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                          color: const Color(0xFFE8ECEF), width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/Googlelogo.png", height: 24),
                        const SizedBox(width: 12),
                        const Text("Continue with Google",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF18181A))),
                      ],
                    )),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: _showSocialLoginNotice,
                child: Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 24, 119, 242),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/facebook.png", height: 24),
                        const SizedBox(width: 12),
                        const Text("Continue with Facebook",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700)),
                      ],
                    )),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("New User?",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.to(() => const SignUp(),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: const Text("Create an account",
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF18181A))),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
