package com.example.cloudflutter;

import android.os.Bundle;
import android.widget.TextView;

import androidx.appcompat.app.AppCompatActivity;

import com.example.myfluttertest.R;

public class FromFlutterActivity extends AppCompatActivity {

    private TextView tvReceiveFlutter;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_from_flutter);
        tvReceiveFlutter = findViewById(R.id.tvReceiveFlutter);
        tvReceiveFlutter.setText(getIntent().getStringExtra("data"));

    }
}