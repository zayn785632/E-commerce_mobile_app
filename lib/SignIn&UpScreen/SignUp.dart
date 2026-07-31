import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Widgets/BottomNavBar.dart';
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
    final email = emailController.text
        .trim()
        .toLowerCase(); // Case-insensitive sanitization
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
      // Create user inside Supabase Auth ecosystem
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': name
        }, // Passes to raw_user_meta_data for the database trigger
      );

      Get.snackbar("Success", "Account created successfully!",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.offAll(() => const BottomNavBar());
    } on AuthException catch (e) {
      Get.snackbar("Authentication Failed", e.message,
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Connection Error", "An unexpected error occurred.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Create an account",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text("Let's create your account",
                  style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 30),

              const Text("Full name",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CommonTextField(
                controller: nameController,
                text: "Enter your full name",
                obscure: false,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 15),

              const Text("Email",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CommonTextField(
                controller: emailController,
                text: "Enter your email address",
                obscure: false,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),

              const Text("Password",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              CommonTextField(
                controller: passwordController,
                text: "Enter your password",
                obscure: _isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                      _isPasswordVisible ? Iconsax.eye_slash : Iconsax.eye),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 25),

              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black))
                  : RoundedButton(
                      title: "Sign Up",
                      onTap: _handleSignUp,
                      width: double.infinity,
                    ),

              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text('Or', style: TextStyle(color: Colors.black)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),

              // Social channels preserved for future modules
              GestureDetector(
                onTap: () {},
                child: Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.black, width: 0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/Googlelogo.png", height: 25),
                        const SizedBox(width: 10),
                        const Text("Sign up with Google",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500)),
                      ],
                    )),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {},
                child: Container(
                    height: 60.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 24, 119, 242),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/facebook.png", height: 25),
                        const SizedBox(width: 10),
                        const Text("Sign up with Facebook",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w500)),
                      ],
                    )),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member?"),
                  const SizedBox(width: 10),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.to(() => const SignIn());
                    },
                    child: const Text("Login",
                        style: TextStyle(fontWeight: FontWeight.bold)),
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
