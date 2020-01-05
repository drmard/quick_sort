package com.hsp.q.sort;

import android.app.Activity;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import android.util.Log;
import android.view.Window;
import android.widget.TextView;

public class QS extends Activity {

    private static final String TAG                 = "QS";
    public static final int MSG_UPDATE_UI           = 1001;
    public static final int MSG_INIT_NATIVE_SORT    = 1002;

    private boolean back_pressed = false;
    private TextView tv = null;

    @Override public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        requestWindowFeature (Window.FEATURE_NO_TITLE);

        setContentView(R.layout.main);

        tv = (TextView)findViewById(R.id.text_view);
        tv.setTypeface (Typeface.createFromAsset(getAssets(),
                "fonts/RobotoMono-Medium.ttf"));

        Native.setHandler(this, mHandler);
    }

    @Override protected void onResume() {
        super.onResume();
  
        if (mHandler != null) {
            Message message = new Message();
            message.what = MSG_INIT_NATIVE_SORT;
            mHandler.sendMessageDelayed(message, 500);
        }

        back_pressed = false;      
    }

    @Override public void onPause() {
        super.onPause();

        if (back_pressed == false)
            finish();
    }

    @Override public void onBackPressed() {
        super.onBackPressed();

        back_pressed = true;
    }

    @Override public void onDestroy() {
        Log.d (TAG, "onDestroy()");
        super.onDestroy();
    }

    private void updateUi(String string) {
        if (tv != null) {
            tv.setText(string);
        }
    }

    Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            switch (msg.what) {
                case MSG_UPDATE_UI:
                    if (msg.obj != null)
                        updateUi((String)msg.obj);
                break;
                case MSG_INIT_NATIVE_SORT:
                    Native.sortIntArray(100);
                break;
            }
        }
    };
}
