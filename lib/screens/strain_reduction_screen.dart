import 'package:flutter/material.dart';
import 'package:visionary/services/background_service.dart';

class StrainReductionScreen extends StatefulWidget {
  const StrainReductionScreen({super.key});

  @override
  State<StrainReductionScreen> createState() => _StrainReductionScreenState();
}

class _StrainReductionScreenState extends State<StrainReductionScreen> {
  bool _isTimerEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strain Reduction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Enable 20-20-20 Timer'),
              value: _isTimerEnabled,
              onChanged: (bool value) {
                setState(() {
                  _isTimerEnabled = value;
                  if (_isTimerEnabled) {
                    BackgroundServiceManager.startService();
                  } else {
                    BackgroundServiceManager.stopService();
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
