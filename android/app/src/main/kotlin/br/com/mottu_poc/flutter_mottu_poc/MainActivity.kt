package br.com.mottu_poc.flutter_mottu_poc

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import java.text.SimpleDateFormat
import java.util.*
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.content.BroadcastReceiver
import android.os.Build
import android.provider.Telephony
import io.flutter.plugin.common.BinaryMessenger

class MainActivity: FlutterActivity() {
    private val CHANNEL = "unique.identifier.method/channel"
    private val CHANNEL_STREAM = "unique.identifier.method/stream"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
      call, result ->

      if (call.method == "getHelloWorld") {
          //Metódo responsável por trazer o nome digitado
          val user: String? = call.argument("user");
          if(user == null) { 
            result.success("Hello Mottu people ;)")
          } else {
            result.success("Hello ${user}");
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod("methodCallback", "result callback kt");
          }
      } else if (call.method == "getBatteryLevel") {
        //#2 Metódo responsável capturar a porcentagem da bateria
        val batteryLevel = getBatteryLevel()

        if (batteryLevel != -1) {
            result.success(batteryLevel)
        } else {
            result.error("UNAVAILABLE", "Battery level not available.", null)
        }
      } else {
          result.notImplemented()
      }
    }

    //Método responsável por enviar as horas para o flutter
    EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_STREAM).setStreamHandler(
      object : EventChannel.StreamHandler {
        override fun onListen(args: Any?, events: EventChannel.EventSink) {
            var handler = Handler(Looper.getMainLooper())
            handler.postDelayed(object : Runnable {
                override fun run() {
                    val sdf = SimpleDateFormat("dd/M/yyyy hh:mm:ss")
                    val currentDate = sdf.format(Date())
                    events.success(currentDate)
                    handler.postDelayed(this, 1000)
                }
            }, 0)
        }

        override fun onCancel(arguments: Any?) {
            println("cancelling listener")
        }
      }
    )

    //#1 Metodo responsável para receber sms
    val smsReceiver = object : EventChannel.StreamHandler, BroadcastReceiver() {
      var eventSink: EventChannel.EventSink? = null
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
          eventSink = events
      }

      override fun onCancel(arguments: Any?) {
          eventSink = null
      }

      override fun onReceive(p0: Context?, p1: Intent?) {
          if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
              for (sms in Telephony.Sms.Intents.getMessagesFromIntent(p1)) {
                  eventSink?.success(sms.displayMessageBody)
              }
          }
      }
    }

  //#1 SMS
  registerReceiver(smsReceiver, IntentFilter("android.provider.Telephony.SMS_RECEIVED"))
  EventChannel(flutterEngine.dartExecutor.binaryMessenger, "unique.identifier.method/smsStream")
      .setStreamHandler(smsReceiver)

  }

   //#2 Bateria
    private fun getBatteryLevel(): Int {
        val batteryLevel: Int
        if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            batteryLevel = intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }

        return batteryLevel
    }
}
