package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;   // ✅ FIX: missing import

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.Krushiconnect.util.DBConnection;
import com.Krushiconnect.util.NotificationUtil;

@WebServlet("/assignDelivery")
public class AssignDeliveryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int orderId = Integer.parseInt(request.getParameter("orderId"));

            Connection conn = DBConnection.getConnection();

            // 🔥 get any delivery boy
            String sql = "SELECT user_id FROM users WHERE role='DELIVERY' LIMIT 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            int deliveryId = 0;

            if (rs.next()) {
                deliveryId = rs.getInt("user_id");
            } else {
                response.getWriter().println("No delivery person available");
                return;
            }

            // 🔥 insert delivery
            String insert = "INSERT INTO deliveries(order_id, delivery_person_id, status) VALUES (?, ?, 'ASSIGNED')";
            PreparedStatement ps2 = conn.prepareStatement(insert);

            ps2.setInt(1, orderId);
            ps2.setInt(2, deliveryId);

            ps2.executeUpdate();
            NotificationUtil.sendNotification(
            	    deliveryId,
            	    "🚚 New delivery assigned! Order ID: " + orderId
            	);

            // ✅ proper redirect
            response.sendRedirect(request.getContextPath() + "/adminDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error assigning delivery");
        }
    }
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        doGet(request, response);
    }
}