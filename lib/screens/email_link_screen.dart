import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class EmailLinkScreen extends StatefulWidget {
  const EmailLinkScreen({super.key});

  @override
  State<EmailLinkScreen> createState() => _EmailLinkScreenState();
}

class _EmailLinkScreenState extends State<EmailLinkScreen> {
  final _emailController = TextEditingController();
  bool _linkSent = false;
  bool _isLoading = false;

  Future<void> _sendSignInLink() async {
    setState(() => _isLoading = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool success = await authProvider.sendSignInLink(_emailController.text);
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        if (success) {
          _linkSent = true;
        }
      });
      
      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send sign-in link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in with Email Link')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_linkSent)
              ..._buildEmailInput(),
            if (_linkSent)
              ..._buildLinkSentMessage(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildEmailInput() {
    return [
      const Text(
        'Enter your email to receive a sign-in link.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 24),
      CustomTextField(
        controller: _emailController,
        labelText: 'Email',
        prefixIcon: Icons.email,
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 24),
      CustomButton(
        text: 'Send Link',
        onPressed: _sendSignInLink,
        isLoading: _isLoading,
      ),
    ];
  }

  List<Widget> _buildLinkSentMessage() {
    return [
      const Icon(Icons.check_circle_outline, color: Colors.green, size: 80),
      const SizedBox(height: 24),
      const Text(
        'A sign-in link has been sent to your email.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 12),
      const Text(
        'Please check your inbox and follow the link to sign in.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 24),
      CustomButton(
        text: 'Back to Login',
        onPressed: () => Navigator.of(context).pop(),
      ),
    ];
  }
}
