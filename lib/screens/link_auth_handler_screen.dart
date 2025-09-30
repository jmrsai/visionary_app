import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth_provider.dart';

class LinkAuthHandlerScreen extends StatefulWidget {
  final String link;
  const LinkAuthHandlerScreen({super.key, required this.link});

  @override
  State<LinkAuthHandlerScreen> createState() => _LinkAuthHandlerScreenState();
}

class _LinkAuthHandlerScreenState extends State<LinkAuthHandlerScreen> {
  @override
  void initState() {
    super.initState();
    _signInWithEmailLink();
  }

  Future<void> _signInWithEmailLink() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('emailForSignIn');

    if (email != null) {
      bool success = await authProvider.signInWithEmailLink(email, widget.link);
      if (!success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign in failed. Please try again.')),
        );
        // Redirect to login screen after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        });
      }
    } else {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not verify sign-in link. Please try again.')),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Verifying your sign-in link...'),
          ],
        ),
      ),
    );
  }
}
