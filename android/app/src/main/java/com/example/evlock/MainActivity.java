package com.example.evlock;

import android.content.Intent;
import android.os.AsyncTask;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    Button btn_buy;
    Button btn_sell;

    String buy_json_string;
    String json_string;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        btn_buy = (Button) findViewById(R.id.btn_buy);
        btn_sell = (Button) findViewById(R.id.btn_sell);

        btn_buy.setOnClickListener(this);
        btn_sell.setOnClickListener(this);
    }
    /*

    class buy_backgroundTask extends AsyncTask<Void, Void, String> {

        String buy_json_url;

        @Override
        protected void onPreExecute() {
            buy_json_url = "http://175.192.140.18/info";
        }

        @Override
        protected String doInBackground(Void... voids) {
            try {
                URL url = new URL(buy_json_url);
                HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
                httpURLConnection.connect();
                InputStream inputStream = httpURLConnection.getInputStream();
                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));

                StringBuilder stringBuilder = new StringBuilder();
                while ((buy_json_string = bufferedReader.readLine()) != null) {

                    stringBuilder.append(buy_json_string + "\n");
                }
                bufferedReader.close();
                inputStream.close();
                httpURLConnection.disconnect();

                return stringBuilder.toString().trim();
            } catch (MalformedURLException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onProgressUpdate(Void... values) {
            super.onProgressUpdate(values);
        }

        @Override
        protected void onPostExecute(String result) {
            TextView textView = (TextView)findViewById(R.id.json_textview);
            textView.setText(result);
            json_string = result;
            Log.d("111111111111111111","@@@@@@@@@@@@@@");
        }
    }
    */
    private void Buy() {
        Intent intent_buy = new Intent(getApplicationContext(), BuyActivity.class);
        startActivity(intent_buy);
    }

    private void Sell() {
        Intent intent_sell = new Intent(getApplicationContext(), SellActivity.class);
        startActivity(intent_sell);
    }

    @Override
    public void onClick(View v) {
        if(v == btn_buy) {
            Buy();
        }
        if(v == btn_sell) {
            Sell();
        }
    }
}