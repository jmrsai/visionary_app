import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;
  
  late AnimationController _backgroundController;
  late AnimationController _formController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _formController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _formController.forward();
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    _formController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      bool success;
      
      if (_isLogin) {
        success = await authProvider.login(_emailController.text, _passwordController.text);
      } else {
        success = await authProvider.register(
          _nameController.text,
          _emailController.text, 
          _passwordController.text,
        );
      }
      
      if (mounted) {
        setState(() => _isLoading = false);
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_isLogin ? 'Invalid credentials' : 'Registration failed'),
              backgroundColor: AppTheme.error,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleSocialSignIn(Future<bool> Function() signInMethod, String name) async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await signInMethod();
    if (mounted) {
      setState(() => _isLoading = false);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$name Sign in Failed'),
            backgroundColor: AppTheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryBlue,
              AppTheme.accentGreen,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildHeader().animate().fadeIn(duration: 800.ms).slideY(begin: -0.3),
                const SizedBox(height: 40),
                _buildForm().animate().fadeIn(duration: 800.ms, delay: 300.ms).slideY(begin: 0.3),
                const SizedBox(height: 30),
                _buildToggle().animate().fadeIn(duration: 800.ms, delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: const Icon(Icons.visibility, size: 50, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Text(
          'Visionary',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your Personal Vision Companion',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isLogin ? 'Welcome Back' : 'Create Account',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _isLogin ? 'Sign in to continue your vision journey' : 'Join us for better eye health',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            if (!_isLogin) ...[
              CustomTextField(
                controller: _nameController,
                labelText: 'Full Name',
                prefixIcon: Icons.person_outline,
                validator: (value) => (value?.isEmpty ?? true) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
            ],
            CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter your email';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value!)) return 'Please enter a valid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _passwordController,
              labelText: 'Password',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Please enter your password';
                if (value!.length < 6) return 'Password must be at least 6 characters';
                return null;
              },
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: _isLogin ? 'Sign In' : 'Create Account',
              onPressed: _handleSubmit,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            _buildSocialLoginDivider(),
            const SizedBox(height: 16),
            ..._buildSocialButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLoginDivider() {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text('OR', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.secondaryLight)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
  
  List<Widget> _buildSocialButtons() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return [
      CustomButton(
        text: 'Sign in with Google',
        onPressed: () => _handleSocialSignIn(authProvider.signInWithGoogle, 'Google'),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryBlue,
        isOutlined: true,
      ),
      if (defaultTargetPlatform == TargetPlatform.iOS) ...[
        const SizedBox(height: 12),
        CustomButton(
          text: 'Sign in with Apple',
          onPressed: () => _handleSocialSignIn(authProvider.signInWithApple, 'Apple'),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ],
      const SizedBox(height: 12),
      CustomButton(
        text: 'Continue as Guest',
        onPressed: () => _handleSocialSignIn(authProvider.signInAnonymously, 'Guest'),
        backgroundColor: AppTheme.lightGrey,
        foregroundColor: AppTheme.primaryBlue,
      ),
    ];
  }

  Widget _buildToggle() {
    return Column(
      children: [
        Text(
          _isLogin ? "Don't have an account?" : 'Already have an account?',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9)),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            setState(() => _isLogin = !_isLogin);
            _formController.reset();
            _formController.forward();
          },
          child: Text(
            _isLogin ? 'Create Account' : 'Sign In',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                ),
          ),
        ),
      ],
    );
  }
}
