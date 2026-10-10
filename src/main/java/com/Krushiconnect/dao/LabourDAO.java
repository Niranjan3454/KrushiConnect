package com.Krushiconnect.dao;

import java.sql.*;
import com.Krushiconnect.util.DBConnection;

public class LabourDAO {

    public double getLabourEarnings(int labourId) {
        double total = 0;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT SUM(final_amount) FROM labour_payments WHERE leader_id=? AND payment_status='PAID'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, labourId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                total = rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }
}