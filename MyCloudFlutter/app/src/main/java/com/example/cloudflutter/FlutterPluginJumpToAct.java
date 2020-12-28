package com.example.cloudflutter;

import android.app.Activity;
import android.content.Intent;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

/**
 * @Author: yuqingfan
 * @Description:  flutter调用原生
 * @date: 2020/12/10
 */
public class FlutterPluginJumpToAct implements MethodChannel.MethodCallHandler {

    public static String CHANNEL = "com.flutterToNative";

    static MethodChannel channel;

    private Activity activity;

    private FlutterPluginJumpToAct(Activity activity) {
        this.activity = activity;
    }

    public static void registerWith(PluginRegistry.Registrar registrar) {
        channel = new MethodChannel(registrar.messenger(), CHANNEL);
        FlutterPluginJumpToAct instance = new FlutterPluginJumpToAct(registrar.activity());
        //setMethodCallHandler在此通道上接收方法调用的回调
        channel.setMethodCallHandler(instance);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

        //通过MethodCall可以获取参数和方法名，然后再寻找对应的平台业务
        //接收来自flutter的指令
        if (call.method.equals("getUser")) {

            Integer userId = call.argument("userId");
            String mockUser = String.format("{\"name\":\"Wiki\",\"id\":%s}", userId);

            Intent intent = new Intent(activity, FromFlutterActivity.class);
            intent.putExtra("data", mockUser);
            activity.startActivity(intent);

            result.success("success");
        } else {
            result.notImplemented();
        }
    }

}