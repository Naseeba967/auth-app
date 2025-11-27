import 'package:developer_hub_authentication_app/screen/forget_password_screen.dart';
import 'package:developer_hub_authentication_app/screen/home_screen.dart';
import 'package:developer_hub_authentication_app/screen/sign_up_screen.dart';
import 'package:developer_hub_authentication_app/services/firebase_auth.dart';
import 'package:developer_hub_authentication_app/utils/constant.dart';
import 'package:developer_hub_authentication_app/widgets/custom_button.dart';
import 'package:developer_hub_authentication_app/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> loginHandle() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      String? errorMessage = await _firebaseAuthService.login(
        _emailController.text,
        _passwordController.text,
      );
      if (errorMessage == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage, style: TextStyle(color: Colors.red)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
       final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: Colors.grey.withValues(alpha: 0.1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                  SizedBox(height: 60),
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Log in to your account',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subtitle,
                  ),
                  SizedBox(height: 40),
                  CustomTextField(
                    controller: _emailController,
                    icon: Icons.email,
                    hintText: 'Enter your Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hintText: 'Password',
                    keyboardType: TextInputType.visiblePassword,
                    isPassword: true,
                  ),

                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForgetPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color:colorScheme.primary),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  CustomButton(
                    text: 'Log In',
                    onPressed: loginHandle,
                    isLoading: isLoading,
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account? '),
                      TextButton(
                        onPressed: () {
                 
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: colorScheme.primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
