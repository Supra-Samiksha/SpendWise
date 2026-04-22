package com.spendwise.model;

public class User {
    private int id;
    private String fullName;
    private String email;
    private String password;

    public User() {}

    public User(int id, String fullName, String email) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
    }

    // Getters and setters
    public int getId()                  { return id; }
    public void setId(int id)           { this.id = id; }
    public String getFullName()         { return fullName; }
    public void setFullName(String n)   { this.fullName = n; }
    public String getEmail()            { return email; }
    public void setEmail(String e)      { this.email = e; }
    public String getPassword()         { return password; }
    public void setPassword(String p)   { this.password = p; }
}
