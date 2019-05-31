package com.example.evlock;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class BuyActivity extends AppCompatActivity {

    String buy_json_string;
    Button btn_refresh;

    String json_string;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.buy_activity);

        btn_refresh = (Button)findViewById(R.id.btn_refresh);
        btn_refresh.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                new buy_backgroundTask().execute();

                if (json_string == null){
                    //Toast.makeText(getApplicationContext(), "거래내역이 없습니다.",Toast.LENGTH_LONG).show();
                }
                else {
                    Intent intent = new Intent(v.getContext(), BuyListActivity.class);
                    intent.putExtra("json_data", json_string);
                    startActivity(intent);
                }
            }
        });
    }
    class buy_backgroundTask extends AsyncTask<Void, Void, String> {

        String buy_json_url;

        @Override
        protected void onPreExecute() {
            buy_json_url = "http://172.20.10.7/info";
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
        }
    }


}
