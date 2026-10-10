package com.Krushiconnect.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import com.Krushiconnect.model.Product;
import com.Krushiconnect.util.DBConnection;

import java.util.*;
import java.sql.*;

public class ProductDAO {

    // 🔥 ADD PRODUCT
    public boolean addProduct(Product p) {

        boolean status = false;

        try {

            Connection conn = DBConnection.getConnection();

            String sql =
                    "INSERT INTO products " +
                    "(vendor_id, name, description, price, quantity_value, unit, stock, category, manufacturer, image_path) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, p.getVendorId());
            ps.setString(2, p.getName());
            ps.setString(3, p.getDescription());
            ps.setDouble(4, p.getPrice());

            // 🔥 NEW
            ps.setDouble(5, p.getQuantityValue());
            ps.setString(6, p.getUnit());

            ps.setInt(7, p.getStock());
            ps.setString(8, p.getCategory());
            ps.setString(9, p.getManufacturer());
            ps.setString(10, p.getImagePath());

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // 🔥 GET ALL PRODUCTS
    public List<Product> getAllProducts() {

        List<Product> list = new ArrayList<>();

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM products WHERE status='ACTIVE'";

            PreparedStatement ps = conn.prepareStatement(sql);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();

                p.setProductId(rs.getInt("product_id"));
                p.setVendorId(rs.getInt("vendor_id"));

                p.setName(rs.getString("name"));
                p.setDescription(rs.getString("description"));

                p.setPrice(rs.getDouble("price"));

                // 🔥 NEW
                p.setQuantityValue(rs.getDouble("quantity_value"));
                p.setUnit(rs.getString("unit"));

                p.setStock(rs.getInt("stock"));

                p.setCategory(rs.getString("category"));

                p.setManufacturer(rs.getString("manufacturer"));

                p.setImagePath(rs.getString("image_path"));
                p.setStatus(rs.getString("status"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // 🔥 GET PRODUCTS BY VENDOR
    public List<Product> getProductsByVendor(int vendorId) {

        List<Product> list = new ArrayList<>();

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM products WHERE vendor_id=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, vendorId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();

                p.setProductId(rs.getInt("product_id"));

                p.setVendorId(rs.getInt("vendor_id"));

                p.setName(rs.getString("name"));

                p.setPrice(rs.getDouble("price"));

                p.setDescription(rs.getString("description"));

                // 🔥 NEW
                p.setQuantityValue(rs.getDouble("quantity_value"));
                p.setUnit(rs.getString("unit"));

                p.setStock(rs.getInt("stock"));

                p.setCategory(rs.getString("category"));

                p.setManufacturer(rs.getString("manufacturer"));

                p.setImagePath(rs.getString("image_path"));
                p.setStatus(rs.getString("status"));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}