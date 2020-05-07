package com.grinder15.flutter_pip

import android.app.PictureInPictureParams
import android.os.Build
import android.util.Rational
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterPipPlugin */
class FlutterPipPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.UserLeaveHintListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private var activityPluginBinding: ActivityPluginBinding? = null
    private var pipReady: Boolean = false
    private var numerator: Double? = null
    private var denominator: Double? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, FLUTTER_PIP)
        channel.setMethodCallHandler(this)
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        const val FLUTTER_PIP: String = "flutter_pip"
        const val SET_PIP_READY: String = "setPiPReady"
        const val UNSET_PIP_READY: String = "unsetPiPReady"
        const val GET_PIP_READY: String = "getPiPReadyStatus"
        const val SWITCH_TO_PIP_MODE: String = "switchToPiPMode"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), FLUTTER_PIP)
            channel.setMethodCallHandler(FlutterPipPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == SWITCH_TO_PIP_MODE) {
            if (checkIfPiPSupported()) {
                if (getPiPReady()) {
                    switchToPiPMode(numerator, denominator)
                    result.success(null)
                } else {
                    result.error("WRONG_CONFIGURATION", "You're trying to go Pip mode without setup. To use PiP Mode, call \"setPipReady\" method and supply numerator and denominator arguments", null)
                }
            } else {
                result.error("NOT_SUPPORTED", "PiP Mode in SDK ${Build.VERSION.SDK_INT} is not supported.", null)
            }
        } else if (call.method == SET_PIP_READY) {
            if (checkIfPiPSupported()) {
                result.success(setPiPReady(call.argument<Double>("numerator"),
                        call.argument<Double>("denominator")))
            } else {
                result.error("NOT_SUPPORTED", "PiP Mode in SDK ${Build.VERSION.SDK_INT} is not supported.", null)
            }
        } else if (call.method == UNSET_PIP_READY) {
            result.success(unsetPiPReady())
        } else if (call.method == GET_PIP_READY) {
            result.success(getPiPReady())
        } else {
            result.notImplemented()
        }
    }

    private fun checkIfPiPSupported(): Boolean {
        return Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
    }

    private fun switchToPiPMode(numerator: Double?, denominator: Double?) {
        if (checkIfPiPSupported()) {
            //val width = activityPluginBinding?.activity?.window?.decorView?.width
            //val height = activityPluginBinding?.activity?.window?.decorView?.height
            if (denominator != null && numerator != null) {
                val pipParams = PictureInPictureParams.Builder()
                        //.setAspectRatio(Rational(width + (width * 0.6).toInt(), height))
                        .setAspectRatio(Rational(numerator.toInt(), denominator.toInt()))
                        .build()
                activityPluginBinding?.activity?.enterPictureInPictureMode(pipParams)
            }
        }
    }

    private fun setPiPReady(numerator: Double?, denominator: Double?): Boolean {
        this.pipReady = true
        this.numerator = numerator
        this.denominator = denominator
        return this.pipReady
    }

    private fun unsetPiPReady(): Boolean {
        this.pipReady = false
        this.numerator = null
        this.denominator = null
        return pipReady
    }

    private fun getPiPReady(): Boolean {
        return pipReady && numerator != null && denominator != null
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding?.removeOnUserLeaveHintListener(this)
        activityPluginBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        activityPluginBinding?.addOnUserLeaveHintListener(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        activityPluginBinding?.addOnUserLeaveHintListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding?.removeOnUserLeaveHintListener(this)
        activityPluginBinding = null
    }

    override fun onUserLeaveHint() {
        if (getPiPReady()) {
            switchToPiPMode(numerator, denominator)
        }
    }
}
