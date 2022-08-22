import 'package:flutter/material.dart';

import 'package:flutter_mottu_poc/services/platform_channel.dart';

class BatteryScreen extends StatefulWidget {
  const BatteryScreen({Key? key}) : super(key: key);

  @override
  State<BatteryScreen> createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  var platformChannel = PlatformChannel();

  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Battery Life'),
      ),
      body: Material(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_result),
              ElevatedButton(
                onPressed: () async {
                  _result = await platformChannel.getBatteryLevel();
                  setState(() {});
                },
                child: const Text('Get Battery Level'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
