package com.stayease.model;

/**
 * Represents a room type category (Standard, Deluxe, Suite).
 */
public class RoomType {
    private int id;
    private String typeName;
    private String description;
    private int capacity;
    private double basePrice;

    public RoomType() {}

    public RoomType(int id, String typeName, String description, int capacity, double basePrice) {
        this.id = id;
        this.typeName = typeName;
        this.description = description;
        this.capacity = capacity;
        this.basePrice = basePrice;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTypeName() { return typeName; }
    public void setTypeName(String typeName) { this.typeName = typeName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public double getBasePrice() { return basePrice; }
    public void setBasePrice(double basePrice) { this.basePrice = basePrice; }
}
