import 'package:flutter/material.dart';

import 'package:flutter_mottu_poc/services/platform_channel.dart';

class ShowStringScreen extends StatefulWidget {
  const ShowStringScreen({Key? key}) : super(key: key);

  @override
  State<ShowStringScreen> createState() => _ShowStringScreenState();
}

class _ShowStringScreenState extends State<ShowStringScreen> {
  var platformChannel = PlatformChannel();
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show String'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Method Chaneel Result:',
            ),
            Text(
              _result,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
              onPressed: () async {
                _result = await platformChannel.callSimpleMethodChannel();
                setState(() {});
              },
              child: const Text('Show string from Kotlin'),
            ),
          ],
        ),
      ),
    );
  }
}
