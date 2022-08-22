import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PlatformChannel {
  var platform = const MethodChannel('unique.identifier.method/channel');
  static const _channel = EventChannel("unique.identifier.method/smsStream");

  Future<String> callSimpleMethodChannel() async =>
      await platform.invokeMethod('getHelloWorld');

  Future<String> callSimpleMethodChannelWithParams(String? param) async {
    if (param == null || param.isEmpty) return '';
    return await platform.invokeMethod('getHelloWorld', {'user': param});
  }

  //Metódo callback para o nativo invocar o flutter
  Future<void> _callbackPlatformChannel(MethodCall call) async {
    final String args = call.arguments;
    switch (call.method) {
      case "methodCallback":
        debugPrint('Method Channel Callback -> $args');
    }
  }

  //Método responsável por capturar a porcentagem da bateria
  Future<String> getBatteryLevel() async {
    String batteryLevel = 'Unknown battery level.';
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    return batteryLevel;
  }

  //Responsável por capturar as informações de qualquer sms recebida
  Stream smsStream() async* {
    yield* _channel.receiveBroadcastStream();
  }
}
