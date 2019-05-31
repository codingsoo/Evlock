package com.example.evlock;

public class BuyListContacts {

    private String id,price,Amount,Credit;

    public BuyListContacts(String id, String price, String Amount, String Credit){
        this.setId(id);
        this.setPrice(price);
        this.setAmount(Amount);
        this.setCredit(Credit);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPrice() {
        return price;
    }

    public void setPrice(String price) {
        this.price = price;
    }

    public String getAmount() {
        return Amount;
    }

    public void setAmount(String Amount) {
        this.Amount = Amount;
    }

    public String getCredit() {
        return Credit;
    }

    public void setCredit(String Credit) {
        this.Credit = Credit;
    }
}
