package com.Krushiconnect.model;

public class Product {

    private int productId;
    private int vendorId;

    private String name;
    private String description;

    private double price;

    // 🔥 NEW
    private double quantityValue;
    private String unit;

    private int stock;

    private String category;

    private String imagePath;

    private String manufacturer;
    private String status;

    // GETTERS & SETTERS

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getVendorId() {
        return vendorId;
    }

    public void setVendorId(int vendorId) {
        this.vendorId = vendorId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
    // 🔥 NEW GETTER/SETTER
    public double getQuantityValue() {
        return quantityValue;
    }

    public void setQuantityValue(double quantityValue) {
        this.quantityValue = quantityValue;
    }

    // 🔥 NEW GETTER/SETTER
    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getManufacturer() {
        return manufacturer;
    }

    public void setManufacturer(String manufacturer) {
        this.manufacturer = manufacturer;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }
}