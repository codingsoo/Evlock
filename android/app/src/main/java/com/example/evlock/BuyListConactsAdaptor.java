package com.example.evlock;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

public class BuyListConactsAdaptor extends ArrayAdapter {
    List buy_list = new ArrayList();

    public BuyListConactsAdaptor(Context context, int resource) {
        super(context, resource);
    }

    public void add(BuyListContacts object) {
        super.add(object);
        buy_list.add(object);
    }

    @Override
    public int getCount() {
        return buy_list.size();
    }

    @Override
    public Object getItem(int position) {
        return buy_list.get(position);
    }

    @Override
    public View getView(int position,View convertView,ViewGroup parent) {
        View row;
        row = convertView;
        BuyListContactsHolder buyListContactsHolder;
        if (row == null){
            LayoutInflater layoutInflater = (LayoutInflater) this.getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            row = layoutInflater.inflate(R.layout.buy_list_row,parent,false);
            buyListContactsHolder = new BuyListContactsHolder();
            buyListContactsHolder.row_list_id = (TextView) row.findViewById(R.id.row_list_id);
            buyListContactsHolder.row_list_price = (TextView) row.findViewById(R.id.row_list_price);
            buyListContactsHolder.row_list_amount = (TextView) row.findViewById(R.id.row_list_amount);
            buyListContactsHolder.row_list_credit = (TextView) row.findViewById(R.id.row_list_credit);

            row.setTag(buyListContactsHolder);
        }else {
            buyListContactsHolder = (BuyListContactsHolder) row.getTag();
        }
        BuyListContacts buyListContacts = (BuyListContacts) this.getItem(position);
        buyListContactsHolder.row_list_id.setText(buyListContacts.getId());
        buyListContactsHolder.row_list_price.setText(buyListContacts.getPrice());
        buyListContactsHolder.row_list_amount.setText(buyListContacts.getAmount());
        buyListContactsHolder.row_list_credit.setText(buyListContacts.getCredit());
        return row;
    }

    static class BuyListContactsHolder{
        TextView row_list_id,row_list_price,row_list_amount,row_list_credit;
    }
}
