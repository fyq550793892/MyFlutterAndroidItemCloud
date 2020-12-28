package com.example.cloudflutter;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class DataFlutterActivity extends FlutterActivity {

    String sharedText;
    private static final String TAG = "DataFlutterActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        FlutterEngine flutterEngine = new FlutterEngine(DataFlutterActivity.this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        registerCustomPlugin(this);
    }

    private static void registerCustomPlugin(PluginRegistry registrar) {

        FlutterPluginJumpToAct.registerWith(registrar.registrarFor(FlutterPluginJumpToAct.CHANNEL));

        FlutterPluginCounter.registerWith(registrar.registrarFor(FlutterPluginCounter.CHANNEL));
    }

}
