package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.*;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.util.DBConnection;
import com.Krushiconnect.util.NotificationUtil;

@WebServlet("/updateDeliveryStatus")
public class UpdateDeliveryStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int deliveryId =
                Integer.parseInt(
                        request.getParameter("deliveryId"));

        String status =
                request.getParameter("status");

        try {

            Connection conn =
                    DBConnection.getConnection();

            // 🔹 1. UPDATE DELIVERY STATUS
            String sql =
                    "UPDATE deliveries " +
                    "SET status=? " +
                    "WHERE delivery_id=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, deliveryId);

            ps.executeUpdate();

            // 🔥 2. GET ORDER + FARMER + DELIVERY PERSON
            String orderSql =
                    "SELECT d.order_id, " +
                    "o.farmer_id, " +
                    "d.delivery_person_id " +
                    "FROM deliveries d " +
                    "JOIN orders o " +
                    "ON d.order_id = o.order_id " +
                    "WHERE d.delivery_id=?";

            PreparedStatement ps2 =
                    conn.prepareStatement(orderSql);

            ps2.setInt(1, deliveryId);

            ResultSet rs =
                    ps2.executeQuery();

            int orderId = 0;
            int farmerId = 0;
            int deliveryPersonId = 0;

            if (rs.next()) {

                orderId =
                        rs.getInt("order_id");

                farmerId =
                        rs.getInt("farmer_id");

                deliveryPersonId =
                        rs.getInt("delivery_person_id");
            }

            // 🔥 3. OUT FOR DELIVERY
            if ("OUT_FOR_DELIVERY"
                    .equalsIgnoreCase(status)) {

                // 🔹 UPDATE ORDER STATUS
                String updateOrder =
                        "UPDATE orders " +
                        "SET status='OUT_FOR_DELIVERY' " +
                        "WHERE order_id=?";

                PreparedStatement ps3 =
                        conn.prepareStatement(updateOrder);

                ps3.setInt(1, orderId);

                ps3.executeUpdate();

                // 🔥 FARMER NOTIFICATION
                NotificationUtil.sendNotification(
                        farmerId,
                        "ORDER_OUT_FOR_DELIVERY",
                        orderId
                );
            }

            // 🔥 4. DELIVERED
            if ("DELIVERED"
                    .equalsIgnoreCase(status)) {

                // 🔹 UPDATE ORDER STATUS
                String updateOrder =
                        "UPDATE orders " +
                        "SET status='DELIVERED' " +
                        "WHERE order_id=?";

                PreparedStatement ps4 =
                        conn.prepareStatement(updateOrder);

                ps4.setInt(1, orderId);

                ps4.executeUpdate();

                // 🔹 UPDATE VENDOR PAYMENTS
                String updateVendorPayment =
                        "UPDATE vendor_payments " +
                        "SET payment_status='PAID' " +
                        "WHERE order_id=?";

                PreparedStatement ps5 =
                        conn.prepareStatement(updateVendorPayment);

                ps5.setInt(1, orderId);

                ps5.executeUpdate();

                // 🔹 UPDATE DELIVERY PAYMENT
                String updateDeliveryPayment =
                        "UPDATE delivery_payments " +
                        "SET payment_status='PAID' " +
                        "WHERE order_id=?";

                PreparedStatement ps6 =
                        conn.prepareStatement(updateDeliveryPayment);

                ps6.setInt(1, orderId);

                ps6.executeUpdate();

                // 🔥 FARMER DELIVERY NOTIFICATION
                NotificationUtil.sendNotification(
                        farmerId,
                        "ORDER_DELIVERED",
                        orderId
                );

                // 🔥 FARMER PAYMENT NOTIFICATION
                NotificationUtil.sendNotification(
                        farmerId,
                        "PAYMENT_SUCCESS",
                        orderId
                );

                // 🔥 DELIVERY BOY EARNING NOTIFICATION
                NotificationUtil.sendNotification(
                        deliveryPersonId,
                        "DELIVERY_EARNING_CREDITED",
                        orderId
                );

                // 🔥 DELIVERY COMPLETED NOTIFICATION
                NotificationUtil.sendNotification(
                        deliveryPersonId,
                        "DELIVERY_COMPLETED",
                        orderId
                );
            }

            // 🔥 5. PICKED
            if ("PICKED"
                    .equalsIgnoreCase(status)) {

                NotificationUtil.sendNotification(
                        farmerId,
                        "DELIVERY_PICKED",
                        orderId
                );
            }

            response.sendRedirect("deliveryDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}