package com.example.the_second_engine_example

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import androidx.work.Data
import androidx.work.OneTimeWorkRequest
import androidx.work.WorkManager
import dev.fluttercommunity.workmanager.BackgroundWorker

/**
 * This reacts to a new bluetooth device being connected (literally any)=
 */
class MyBroadcastReceiver : BroadcastReceiver() {
    companion object {
        const val TAG = "MyReceiver"
        const val TASK_ID_ROUTINE_UPDATE = "the_second_engine_example.test_receiver"
    }

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Enqueuing one time work from MyReceiver")
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