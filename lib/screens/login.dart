import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import
import '../widgets/custom_input.dart';
import 'register.dart';
import 'main_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 1. Controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isLoading = false;

  // 2. Fungsi Login
  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        // Berhasil Login -> Biasanya pindah ke HomePage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login Berhasil!")),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      String message = "Login Gagal";
      if (e.code == 'user-not-found') message = "Email tidak ditemukan.";
      if (e.code == 'wrong-password') message = "Password salah.";
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF38383D);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
           // Background Image (sama)
           Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://i.pinimg.com/originals/e8/1a/3f/e81a3f7737df6d795fb2b3b71900d720.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const Icon(Icons.grid_view, size: 50),
                  const SizedBox(height: 10),
                  Text('DICE & DICE', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor, fontFamily: 'Serif')),
                  const SizedBox(height: 40),

                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      border: Border.all(color: Colors.black87),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Input Email (Ubah label jadi Email agar sesuai Firebase Auth)
                        CustomInput(label: "Email", controller: _emailController),
                        const SizedBox(height: 20),
                        CustomInput(label: "Password", controller: _passwordController, isPassword: true),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: _isLoading 
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Login", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // ... Sisa UI (Divider & Sign Up Link) sama seperti sebelumnya
                        const Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey)),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("Or")),
                            Expanded(child: Divider(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 30),

                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: const TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(color: Colors.grey[700], fontStyle: FontStyle.italic, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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