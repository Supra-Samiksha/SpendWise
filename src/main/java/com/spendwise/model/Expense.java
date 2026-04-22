package com.spendwise.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Expense {
    private int id;
    private int userId;
    private String title;
    private BigDecimal amount;
    private String category;
    private Date expenseDate;
    private String notes;

    public Expense() {}

    // Getters and setters
    public int getId()                      { return id; }
    public void setId(int id)               { this.id = id; }
    public int getUserId()                  { return userId; }
    public void setUserId(int userId)       { this.userId = userId; }
    public String getTitle()                { return title; }
    public void setTitle(String title)      { this.title = title; }
    public BigDecimal getAmount()           { return amount; }
    public void setAmount(BigDecimal a)     { this.amount = a; }
    public String getCategory()             { return category; }
    public void setCategory(String c)       { this.category = c; }
    public Date getExpenseDate()            { return expenseDate; }
    public void setExpenseDate(Date d)      { this.expenseDate = d; }
    public String getNotes()                { return notes; }
    public void setNotes(String notes)      { this.notes = notes; }
}