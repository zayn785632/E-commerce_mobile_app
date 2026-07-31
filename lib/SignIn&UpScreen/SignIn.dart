import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trandtribe/Widgets/BottomNavBar.dart';
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
    final email =
        emailController.text.trim().toLowerCase(); // Normalize case styling
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
      // Authenticate session tokens via Supabase
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      Get.snackbar("Welcome Back", "Authentication verification clear.",
          backgroundColor: Colors.green, colorText: Colors.white);

      Get.offAll(() => const BottomNavBar());
    } on AuthException catch (e) {
      Get.snackbar("Access Denied", e.message,
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    } catch (e) {
      Get.snackbar(
          "Network Error", "Unable to declare server context handshake.",
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
              const Text("Welcome Back!",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text("Log in to your existing account",
                  style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 30),
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
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {},
                    child: const Text("Forget Password?",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.black))
                  : RoundedButton(
                      title: "Log In",
                      onTap: _handleSignIn,
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
                        const Text("Continue with Google",
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
                        const Text("Continue with Facebook",
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
                  const Text("New User"),
                  const SizedBox(width: 10),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      Get.to(() => const SignUp());
                    },
                    child: const Text("Create an account",
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
