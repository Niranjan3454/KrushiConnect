package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.util.DBConnection;

@WebServlet("/updateOrderStatus")
public class UpdateOrderStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int orderId = Integer.parseInt(request.getParameter("orderId"));
        String status = request.getParameter("status");

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE orders SET status=? WHERE order_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, orderId);

            ps.executeUpdate();

            response.sendRedirect("adminDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}