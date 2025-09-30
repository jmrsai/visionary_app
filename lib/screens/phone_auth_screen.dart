import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _smsController = TextEditingController();
  
  bool _codeSent = false;
  bool _isLoading = false;

  Future<void> _verifyPhoneNumber() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    await authProvider.verifyPhoneNumber(
      _phoneController.text,
      codeSent: (verificationId, resendToken) {
        setState(() {
          _codeSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification code sent')),
        );
      },
      verificationFailed: (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Verification failed')),
        );
      },
    );
  }

  Future<void> _signInWithSmsCode() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.signInWithSmsCode(_smsController.text);
    
    if (mounted) {
      setState(() => _isLoading = false);
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in failed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with Phone')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_codeSent)
              ..._buildPhoneInput(),
            if (_codeSent)
              ..._buildSmsCodeInput(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPhoneInput() {
    return [
      const Text(
        'Enter your phone number to receive a verification code.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 24),
      CustomTextField(
        controller: _phoneController,
        labelText: 'Phone Number',
        prefixIcon: Icons.phone,
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 24),
      CustomButton(
        text: 'Send Code',
        onPressed: _verifyPhoneNumber,
        isLoading: _isLoading,
      ),
    ];
  }

  List<Widget> _buildSmsCodeInput() {
    return [
      const Text(
        'Enter the 6-digit code sent to your phone.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 24),
      CustomTextField(
        controller: _smsController,
        labelText: 'SMS Code',
        prefixIcon: Icons.sms,
        keyboardType: TextInputType.number,
      ),
      const SizedBox(height: 24),
      CustomButton(
        text: 'Sign In',
        onPressed: _signInWithSmsCode,
        isLoading: _isLoading,
      ),
      TextButton(
        onPressed: () => setState(() => _codeSent = false),
        child: const Text('Change phone number'),
      )
    ];
  }
}
