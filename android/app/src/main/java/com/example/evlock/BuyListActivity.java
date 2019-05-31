package com.example.evlock;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

//Buy에 뜨는 목록 뷰
public class BuyListActivity extends AppCompatActivity {

    String buy_json_string;
    String json_string;
    JSONObject jsonObject;
    JSONArray jsonArray;
    BuyListConactsAdaptor buyListConactsAdaptor;
    ListView buylistview;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.buy_list_activity);

        buylistview = (ListView) findViewById(R.id.buylistview);

        //아이템들 리스트뷰로 연결
        buyListConactsAdaptor = new BuyListConactsAdaptor(this, R.layout.buy_list_row);
        buylistview.setAdapter(buyListConactsAdaptor);

        //아이템 클릭 시 팝업 메세지 창
        buylistview.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                final AlertDialog.Builder builder = new AlertDialog.Builder(BuyListActivity.this);
                View view1 = getLayoutInflater().inflate(R.layout.buy_info, null);
                final EditText buy_edit = (EditText) findViewById(R.id.amount_editText);
                //pop up message trade button.
                Button btn_cancel = (Button) view1.findViewById(R.id.btn_cancel);
                Button btn_ok = (Button) view1.findViewById(R.id.btn_ok);

                builder.setView(view1);
                final AlertDialog dialog = builder.create();
                dialog.setCanceledOnTouchOutside(false);
                Log.d("button", "2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");


                btn_cancel.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        dialog.dismiss();
                    }
                });

                btn_ok.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        //trade button after code.
                        if (buy_edit == null) {
                            Toast.makeText(BuyListActivity.this, "transaction successful", Toast.LENGTH_SHORT).show();
                            new buy_backgroundTask().execute();
                            dialog.dismiss();
                        }else {
                            Toast.makeText(BuyListActivity.this, "Please check your amount", Toast.LENGTH_SHORT).show();
                        }

                        if (json_string == null){
                            Toast.makeText(getApplicationContext(), "거래내역이 없습니다.",Toast.LENGTH_LONG).show();
                        }
                        else {
                            Intent intent = new Intent(v.getContext(), BuyListActivity.class);
                            intent.putExtra("json_data", json_string);
                            startActivity(intent);
                        }


                    }
                });

                dialog.show();

            }
        });

        json_string = getIntent().getExtras().getString("json_data");
        try {
            jsonObject = new JSONObject(json_string);
            jsonArray = jsonObject.getJSONArray("info");
            int count = 0;
            String id, price, Amount, Credit;

            while (count < jsonArray.length()){
                JSONObject JO = jsonArray.getJSONObject(count);

                //각각 데이터를 가져오는 부분.
                //json파일의 데이터 index와 일치해야 가져올 수 있다. 그러지 않으면 null값이 되므로 주의하자.!!
                id = JO.getString("id");
                price = JO.getString("price");
                Amount = JO.getString("Amount");
                Credit = JO.getString("Credit");

                BuyListContacts buyListContacts = new BuyListContacts(id, price, Amount, Credit);
                buyListConactsAdaptor.add(buyListContacts);

                count ++;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    class buy_backgroundTask extends AsyncTask<Void, Void, String> {

        String buy_json_url2;

        @Override
        protected void onPreExecute() {
            buy_json_url2 = "http://172.20.10.7/buy";
        }

        @Override
        protected String doInBackground(Void... voids) {
            try {
                URL url = new URL(buy_json_url2);
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

        }
    }
}
