package com.spendwise.model;

import java.math.BigDecimal;
import java.sql.Date;

public class BankTransaction {
    private int id;
    private int userId;
    private String transactionId;
    private String description;
    private BigDecimal amount;
    private Date transactionDate;
    private String category;

    // Getters and setters
    public int getId()                         { return id; }
    public void setId(int id)                  { this.id = id; }
    public int getUserId()                     { return userId; }
    public void setUserId(int userId)          { this.userId = userId; }
    public String getTransactionId()           { return transactionId; }
    public void setTransactionId(String tid)   { this.transactionId = tid; }
    public String getDescription()             { return description; }
    public void setDescription(String d)       { this.description = d; }
    public BigDecimal getAmount()              { return amount; }
    public void setAmount(BigDecimal a)        { this.amount = a; }
    public Date getTransactionDate()           { return transactionDate; }
    public void setTransactionDate(Date d)     { this.transactionDate = d; }
    public String getCategory()                { return category; }
    public void setCategory(String c)          { this.category = c; }
}