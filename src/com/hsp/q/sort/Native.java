package com.hsp.q.sort;

import android.content.Context;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

public class Native {
    private static final String TAG = "Native";

    private static Handler mHandler = null;
    private static Context mContext = null;

    static {
        try {
            System.loadLibrary("qsort");
        } catch (UnsatisfiedLinkError u) {
            u.printStackTrace();
        }
    };

    public static void setHandler(Context context, Handler handler) {
        mContext = context;
        mHandler = handler;
    }

    public static void passData (String string) {
        if (mHandler == null) {
            return;
        }

        Message msg = Message.obtain();
        msg.what = QS.MSG_UPDATE_UI;
        msg.obj = (Object)string;
        mHandler.sendMessage(msg);       
    }

    public native static void sortIntArray(int length);
}
