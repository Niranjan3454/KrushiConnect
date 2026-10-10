package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.util.DBConnection;
import com.Krushiconnect.util.PasswordUtil;

@WebServlet("/resetPassword")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String email = request.getParameter("email");
        String newPassword = PasswordUtil.hashPassword(request.getParameter("newPassword"));

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE users SET password=? WHERE email=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, newPassword);
            ps.setString(2, email);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                response.getWriter().println("✅ Password Updated Successfully!");
            } else {
                response.getWriter().println("❌ Email not found!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}