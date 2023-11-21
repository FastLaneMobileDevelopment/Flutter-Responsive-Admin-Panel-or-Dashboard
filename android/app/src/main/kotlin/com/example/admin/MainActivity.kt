package com.yupcity.yupapp.admin

import android.util.Log
import com.smartlock.bl.sdk.api.ExtendedBluetoothDevice
import com.smartlock.bl.sdk.api.SmartLockClient
import com.smartlock.bl.sdk.callback.ControlLockCallback
import com.smartlock.bl.sdk.callback.InitLockCallback
import com.smartlock.bl.sdk.callback.ScanLockCallback
import com.smartlock.bl.sdk.constant.ControlAction
import com.smartlock.bl.sdk.entity.ControlLockResult
import com.smartlock.bl.sdk.callback.ResetLockCallback
import com.smartlock.bl.sdk.entity.LockError

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result


class MainActivity: FlutterActivity() {


    var currentDevice : ExtendedBluetoothDevice? = null
    var currentDevice1 : ExtendedBluetoothDevice? = null
    var currentDevice2 : ExtendedBluetoothDevice? = null
    var currentDevice3 : ExtendedBluetoothDevice? = null
    var currentDevice4 : ExtendedBluetoothDevice? = null


    var logs : String = ""

    val UNLOCK = 3

    val LOCK = 6

    var currentStep : String = ""


    private val CHANNEL_LOCK = "samples.flutter.dev/lock"

    private lateinit var channel: MethodChannel


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        SmartLockClient.getDefault().prepareBTService(getApplicationContext())
//        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_LOCK)
//        channel.setMethodCallHandler {
//                call, result ->
//            if (call.method == "getLockData") {
//                val currentStep = call.argument<String?>("step")
//                Log.d("getLockData", currentStep.toString())
//                if (currentStep == "lock1") {
//                    Log.d("step", "GET Current Device 1")
//                    currentDevice = currentDevice1
//                }
//
//                if (currentStep == "lock2") {
//                    Log.d("step", "GET Current Device 2")
//                    currentDevice = currentDevice2
//                }
//
//                if (currentStep == "lock3") {
//                    Log.d("step", "GET Current Device 3")
//                    currentDevice = currentDevice3
//                }
//
//                if (currentStep == "lock4") {
//                    Log.d("step", "GET Current Device 4")
//                    currentDevice = currentDevice4
//                }
//
//                if (currentDevice != null) {
//                    val name = currentDevice?.device?.name
//                    val address = currentDevice?.device?.address
//                    Log.d("scanner smart", "Start To InitLock:")
//                    currentDevice?.manufacturerId = "XBY9E68A" // "XBY9E68A" // "XBYMIYABE"
//                    Log.d("Scanner smart", currentDevice.toString())
//                    SmartLockClient.getDefault().initLock(currentDevice, object : InitLockCallback {
//                        override fun onInitLockSuccess(lockData: String) {
//                            print(lockData)
//                            Log.d("scanner smart", "lockData:" + lockData)
//                            var currentLogData = lockData
//                            channel.invokeMethod("found_lockData", listOf(name, address, lockData), object : MethodChannel.Result {
//                                override fun success(result: Any?) {
//                                    Log.d("Android", "result = $result")
//                                }
//                                override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
//                                    Log.d("Android", "$errorCode, $errorMessage, $errorDetails")
//                                }
//                                override fun notImplemented() {
//                                    Log.d("Android", "notImplemented")
//                                }
//                            })
//                            /*val settings: SharedPreferences? = context?.getSharedPreferences("my_prefs", 0)
//                            val editor = settings?.edit()
//                            editor?.putString("logData", currentLogData)
//                            editor?.commit() */
//
//                            //init success
//                        }
//
//                        override fun onFail(error: LockError) {
//                            //SmartLockClient.getDefault().disconnect();
//                            Log.d("scanner smart", "error:" + error.description)
//                            //failed
//                        }
//                    })
//                }
//
//            }
//            if (call.method == "reset_lock") {
//                currentDevice = null
//                val lockData  = call.argument<String?>("lockData")
//                val lockdId  = call.argument<String?>("lockId")
//
//                Log.d("Android",  "LockData:  " + lockData)
//                Log.d("Android",  "LockID:  " + lockdId)
//                SmartLockClient.getDefault().prepareBTService(getApplicationContext())
//                SmartLockClient.getDefault().resetLock(lockData,
//                    object : ResetLockCallback {
//                        override fun onResetLockSuccess() {
//                            SmartLockClient.getDefault().stopBTService()
//                            result.success(lockdId)
//                        }
//
//                        override fun onFail(p0: LockError?) {
//                            Log.d("Android", p0?.description + " " + p0?.errorMsg)
//                            result.success(lockdId)
//
//                        }
//                    })
//            }
//            if (call.method == "reset") {
//                var currentDevice = null
//                var currentDevice1 = null
//                var currentDevice2 = null
//                var currentDevice3 = null
//                var currentDevice4 = null
//                result.success("reset");
//            }
//            if (call.method == "searchPaired") {
//                val currentStep = call.argument<String?>("step")
//                Log.d("step", "The current step is $currentStep")
//                SmartLockClient.getDefault().prepareBTService(getApplicationContext());
//                SmartLockClient.getDefault().startScanLock(object : ScanLockCallback {
//                    override fun onScanLockSuccess(device: ExtendedBluetoothDevice) {
//                        print(device.toString())
//                        Log.d("test", device.toString())
//                        // SmartLockClient.getDefault().stopScanLock()
//                        logs = SmartLockClient.getDefault().sdkLog
//                        currentDevice = device
//
//                        if (device.name.startsWith("EXO")) {
//                            if (!device.isSettingMode) {
//                                SmartLockClient.getDefault().stopScanLock()
//                                val name = currentDevice?.device?.name
//                                val address = currentDevice?.device?.address
//                                channel.invokeMethod(
//                                    "found",
//                                    listOf(name, address),
//                                    object : MethodChannel.Result {
//                                        override fun success(result: Any?) {
//                                            Log.d("Android", "result = $result")
//                                        }
//
//                                        override fun error(
//                                            errorCode: String?,
//                                            errorMessage: String?,
//                                            errorDetails: Any?
//                                        ) {
//                                            Log.d(
//                                                "Android",
//                                                "$errorCode, $errorMessage, $errorDetails"
//                                            )
//                                        }
//
//                                        override fun notImplemented() {
//                                            Log.d("Android", "notImplemented")
//                                        }
//                                    })
//                            }
//                        }
//
//                        Log.d("test", device.toString())
//
//                    }
//
//                    //only the lock is in setting mode(device.isSettingMode()) can be inited.
//                    override fun onFail(error: LockError) {
//                        Log.d("scanner smart", "error:" + error.description)
//                    }
//                })
//            }
//            if (call.method == "search")
//            {
//                val currentStep = call.argument<String?>("step")
//                Log.d("step", "The current step is $currentStep")
//                SmartLockClient.getDefault().prepareBTService(getApplicationContext());
//                SmartLockClient.getDefault().startScanLock(object : ScanLockCallback {
//                    override fun onScanLockSuccess(device: ExtendedBluetoothDevice) {
//                        print(device.toString())
//                        Log.d("test", device.toString())
//                        // SmartLockClient.getDefault().stopScanLock()
//                        logs = SmartLockClient.getDefault().sdkLog
//                        currentDevice = device
//
//                        if (device.name.startsWith("EXO")) {
//                            Log.d("step","Device NAME Found: " + device.name + " Setting mode: " + device.isSettingMode)
//                            if (device.isSettingMode) {
//                                Log.d("search", "SELECTED: $device")
//
//                                device.manufacturerId = "XBY9E68A"
//                                currentDevice = device
//                                if (currentStep == "lock1") {
//                                    Log.d("step", "SET Current Device 1")
//                                    currentDevice1 = device
//                                }
//
//                                if (currentStep == "lock2") {
//                                    Log.d("step", "Current Device 2")
//                                    currentDevice2 = device
//                                }
//
//                                if (currentStep == "lock3") {
//                                    Log.d("step", "Current Device 3")
//                                    currentDevice3 = device;
//                                }
//
//                                if (currentStep == "lock4") {
//                                    Log.d("step", "Current Device 4")
//                                    currentDevice4 = device
//                                }
//                                SmartLockClient.getDefault().stopScanLock()
//                                val name = currentDevice?.device?.name
//                                val address = currentDevice?.device?.address
//                                channel.invokeMethod(
//                                    "found",
//                                    listOf(name, address),
//                                    object : MethodChannel.Result {
//                                        override fun success(result: Any?) {
//                                            Log.d("Android", "result = $result")
//                                        }
//
//                                        override fun error(
//                                            errorCode: String?,
//                                            errorMessage: String?,
//                                            errorDetails: Any?
//                                        ) {
//                                            Log.d(
//                                                "Android",
//                                                "$errorCode, $errorMessage, $errorDetails"
//                                            )
//                                        }
//
//                                        override fun notImplemented() {
//                                            Log.d("Android", "notImplemented")
//                                        }
//                                    })
//
//
//                            }
//                            /*else {
//                                SmartLockClient.getDefault().stopScanLock()
//                                val name = currentDevice?.device?.name
//                                val address = currentDevice?.device?.address
//                                channel.invokeMethod(
//                                    "found",
//                                    listOf(name, address),
//                                    object : MethodChannel.Result {
//                                        override fun success(result: Any?) {
//                                            Log.d("Android", "result = $result")
//                                        }
//
//                                        override fun error(
//                                            errorCode: String?,
//                                            errorMessage: String?,
//                                            errorDetails: Any?
//                                        ) {
//                                            Log.d(
//                                                "Android",
//                                                "$errorCode, $errorMessage, $errorDetails"
//                                            )
//                                        }
//
//                                        override fun notImplemented() {
//                                            Log.d("Android", "notImplemented")
//                                        }
//                                    })
//                            }*/
//                        }
//                        /*if (device.name == "EXO_28ce09d2a2") {
//                            device.manufacturerId =  "XBY9E68A"
//                            currentDevice1 = device
//                        }
//                        else if(device.name == "EXO_2e0e28") {
//                            device.manufacturerId =  "XBY9E68A"
//                            currentDevice2 = device
//                        }
//
//                        if (currentDevice1 != null && currentDevice2 != null) {
//                            Log.d("test", "STOP SEARCHING LOCKS")
//                             SmartLockClient.getDefault().stopScanLock()
//                        }*/
//
//                        Log.d("test", device.toString())
//
//                    }
//
//                    //only the lock is in setting mode(device.isSettingMode()) can be inited.
//                    override fun onFail(error: LockError) {
//                        Log.d("scanner smart", "error:" + error.description)
//                    }
//                })
//            }
//
//            if (call.method == "open")
//            {
//                val lockDataArg = call.argument<String?>("lockData")
//                Log.d("Android",  "LockData:  " + lockDataArg)
//                SmartLockClient.getDefault().controlLock(ControlAction.UNLOCK, lockDataArg, object: ControlLockCallback {
//                    override fun onControlLockSuccess(p0: ControlLockResult?) {
//                        result.success(ControlAction.UNLOCK)
//                        Log.d("tag", p0.toString())
//                    }
//
//                    override fun onFail(p0: LockError?) {
//                        // result.error("0", "Error con lock", p0)
//                        Log.d("tag", p0.toString())
//                    }
//                })
//
//
//            }
//
//            if (call.method == "close") {
//                val lockDataArg = call.argument<String?>("lockData")
//                Log.d("Android",  "LockData:  " + lockDataArg)
//                SmartLockClient.getDefault().controlLock(ControlAction.LOCK, lockDataArg, object: ControlLockCallback {
//                    override fun onControlLockSuccess(p0: ControlLockResult?) {
//                        result.success(ControlAction.LOCK)
//                        Log.d("tag", p0.toString())
//                    }
//
//                    override fun onFail(p0: LockError?) {
//                        // result.error("0", "Error con lock", p0)
//                        Log.d("tag", p0.toString())
//                    }
//                })
//
//            }
//        }
    }



}
