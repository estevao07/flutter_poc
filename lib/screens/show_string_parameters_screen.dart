import 'package:flutter/material.dart';

import 'package:flutter_mottu_poc/services/platform_channel.dart';

class ShowStringParametersScreen extends StatefulWidget {
  const ShowStringParametersScreen({Key? key}) : super(key: key);

  @override
  State<ShowStringParametersScreen> createState() =>
      _ShowStringParametersScreenState();
}

class _ShowStringParametersScreenState
    extends State<ShowStringParametersScreen> {
  var platformChannel = PlatformChannel();

  String _result = '';
  String? nameRequest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                onChanged: (val) => nameRequest = val,
                decoration: const InputDecoration(hintText: 'Name'),
              ),
            ),
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
                _result = await platformChannel
                    .callSimpleMethodChannelWithParams(nameRequest);
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
