package com.example.cloudflutter;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import androidx.appcompat.app.AppCompatActivity;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends AppCompatActivity {
    private Button btIntoFlutterView;
    private Button btIntoFlutterFragment;
    private Button btIntoFlutterActivity;
    private Button btAndroidToFlutter;
    String sharedText;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.activity_main);
        btIntoFlutterView = findViewById(R.id.btIntoFlutterView);
        btIntoFlutterFragment = findViewById(R.id.btIntoFlutterFragment);
        btIntoFlutterActivity = findViewById(R.id.btIntoFlutterActivity);
        btIntoFlutterView.setVisibility(View.GONE);
        btIntoFlutterFragment.setVisibility(View.GONE);

        btAndroidToFlutter = findViewById(R.id.btAndroidToFlutter);

        btIntoFlutterView.setOnClickListener(v -> {
            startActivity(new Intent(MainActivity.this, MyFlutterViewActivity.class));
        });

        btIntoFlutterFragment.setOnClickListener(v -> {
            startActivity(new Intent(MainActivity.this, MyFlutterFragmentActivity.class));

        });

        FlutterEngine flutterEngine = new FlutterEngine(MainActivity.this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        btIntoFlutterActivity.setOnClickListener(v ->{
            startActivity(
                    FlutterActivity
                            .withCachedEngine("my_engine_id")
                            //.initialRoute("route1")
                            .build(this));
        });

        btAndroidToFlutter.setOnClickListener(v -> {
            startActivity(new Intent(MainActivity.this, DataFlutterActivity.class));
        });

    }
}