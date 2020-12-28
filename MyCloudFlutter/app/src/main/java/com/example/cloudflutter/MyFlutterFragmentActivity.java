package com.example.cloudflutter;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.example.myfluttertest.R;

import io.flutter.embedding.android.FlutterFragment;

public class MyFlutterFragmentActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my_flutter_fragment);

        // 通过FlutterFragment引入Flutter编写的页面
        FlutterFragment flutterFragment = FlutterFragment.withNewEngine()
                .initialRoute("route1")
                .build();
        getSupportFragmentManager()
                .beginTransaction()
                .add(R.id.fl_container, flutterFragment)
                .commit();



    }
}