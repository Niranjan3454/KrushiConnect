package com.Krushiconnect.dao;

import java.sql.*;
import java.util.*;

import com.Krushiconnect.util.DBConnection;

public class VendorDAO {

    // 🔹 Total Earnings (ONLY PAID + ONLY THIS VENDOR)
    public double getVendorEarnings(int vendorId) {
        double total = 0;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT SUM(final_amount) FROM vendor_payments WHERE vendor_id=? AND payment_status='PAID'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, vendorId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    // 🔹 Orders List
    public List<String> getVendorOrders(int vendorId) {
        List<String> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT order_id, SUM(final_amount) as total " +
                         "FROM vendor_payments " +
                         "WHERE vendor_id=? AND payment_status='PAID' " +
                         "GROUP BY order_id";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, vendorId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add("Order #" + rs.getInt("order_id") +
                         " | Earned: ₹" + rs.getDouble("total"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}