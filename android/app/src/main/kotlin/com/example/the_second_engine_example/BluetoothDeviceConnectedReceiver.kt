package com.example.the_second_engine_example

import android.Manifest
import android.bluetooth.BluetoothClass
import android.bluetooth.BluetoothDevice
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.util.Log
import androidx.core.app.ActivityCompat
import androidx.work.Data
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import dev.fluttercommunity.workmanager.BackgroundWorker

/**
 * This reacts to a new bluetooth device being connected (literally any)=
 */
class BluetoothDeviceConnectedReceiver : BroadcastReceiver() {
    companion object {
        const val TAG = "BtDevConnReceiver"
        const val TASK_ID_ROUTINE_UPDATE = "the_second_engine_example.test_receiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        when (intent.action) {
            BluetoothDevice.ACTION_ACL_CONNECTED -> {
                val device = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE, BluetoothDevice::class.java)
                } else {
                    intent.getParcelableExtra(BluetoothDevice.EXTRA_DEVICE)
                }
                if (device == null) {
                    Log.wtf(TAG, "device is null!!")
                    return
                }
                Log.d(TAG, "Connected to dev: $device ; Class: ${device.bluetoothClass.majorDeviceClass}")
                Log.i(TAG, "Scheduling one time work...")
                // this is stuff imported from dev.fluttercommunity.workmanager
                val oneOffTaskRequest = OneTimeWorkRequest.Builder(BackgroundWorker::class.java)
                    .setInputData(
                        Data.Builder()
                            .putString(BackgroundWorker.DART_TASK_KEY, TASK_ID_ROUTINE_UPDATE)
                            .putBoolean(BackgroundWorker.IS_IN_DEBUG_MODE_KEY, false)
                            .build()
                    )
                    .build()
                WorkManager.getInstance(context).enqueue(oneOffTaskRequest)
            }
        }
    }
}