package com.Krushiconnect.dao;

import java.sql.*;
import com.Krushiconnect.model.User;
import com.Krushiconnect.util.DBConnection;

public class UserDAO {

    // REGISTER
    public boolean registerUser(User user) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO users(name, email, password, role, phone, address) VALUES (?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword()); // already hashed
            ps.setString(4, user.getRole());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    // LOGIN
    public User loginUser(String email, String password) {
        User user = null;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM users WHERE email=? AND password=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setStatus(rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
}