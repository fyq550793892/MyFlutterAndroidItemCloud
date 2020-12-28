package com.example.cloudflutter;

import android.app.Activity;
import android.util.Log;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;


/**
 * @Author: yuqingfan
 * @Description: 原生调用flutter
 * @date: 2020/12/10
 */
public class FlutterPluginCounter implements EventChannel.StreamHandler {

    public static String CHANNEL = "com.nativeToFlutter";

    static EventChannel channel;

    private Activity activity;

    private FlutterPluginCounter(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new EventChannel(registrar.messenger(), CHANNEL);
        FlutterPluginCounter instance = new FlutterPluginCounter(registrar.activity());
        channel.setStreamHandler(instance);
    }

    @Override
    public void onListen(Object o, final EventChannel.EventSink eventSink) {

        eventSink.success("from android");

    }

    @Override
    public void onCancel(Object o) {
        Log.i("FlutterPluginCounter", "FlutterPluginCounter:onCancel");
    }

}
