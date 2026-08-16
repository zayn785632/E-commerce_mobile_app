import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- ROUTING UPDATED TO GATEWAY ---
import 'package:trandtribe/RoleGateway.dart';
import 'package:trandtribe/Widgets/RoundedButton.dart';
import 'package:trandtribe/SignIn&UpScreen/SignIn.dart';
import '../Widgets/CommonTextField.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = true;
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim().toLowerCase();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
          "Required Fields", "Please populate all structural input fields.",
          backgroundColor: Colors.amber.shade700, colorText: Colors.white);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': name},
      );

      Get.snackbar("Success", "Account created successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      // --- NAVIGATE TO GATEWAY ---
      Get.offAll(() => const RoleGateway(), transition: Transition.fadeIn);
    } on AuthException catch (e) {
      Get.snackbar("Authentication Failed", e.message,
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Connection Error", "An unexpected error occurred.",
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
              const Text("Create an account",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF18181A),
                      letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text("Let's set up your profile",
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 40),
              const Text("Full Name",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              const SizedBox(height: 10),
              CommonTextField(
                controller: nameController,
                text: "Enter your full name",
                obscure: false,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 20),
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
                text: "Create a strong password",
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
              const SizedBox(height: 40),
              _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFFFF5E1F)))
                  : RoundedButton(
                      title: "Sign Up",
                      onTap: _handleSignUp,
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
                        const Text("Sign up with Google",
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
                        const Text("Sign up with Facebook",
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
                  Text("Already a member?",
                      style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.to(() => const SignIn(),
                          transition: Transition.leftToRightWithFade);
                    },
                    child: const Text("Log In",
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
