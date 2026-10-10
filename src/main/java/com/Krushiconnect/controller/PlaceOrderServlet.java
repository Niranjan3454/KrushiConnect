package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.*;
import java.util.*;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.model.CartItem;
import com.Krushiconnect.model.User;
import com.Krushiconnect.util.DBConnection;
import com.Krushiconnect.util.NotificationUtil;

@WebServlet("/placeOrder")
public class PlaceOrderServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int farmerId = user.getUserId();

        String paymentMode = request.getParameter("paymentMode");
        String address = request.getParameter("address");

        try {

            Connection conn = DBConnection.getConnection();

            // 🔹 1. GET CART
            String cartSql =
                    "SELECT c.product_id, c.quantity, " +
                    "p.price, p.vendor_id " +
                    "FROM cart c " +
                    "JOIN products p ON c.product_id = p.product_id " +
                    "WHERE c.farmer_id=?";

            PreparedStatement cartPs =
                    conn.prepareStatement(cartSql);

            cartPs.setInt(1, farmerId);

            ResultSet rs = cartPs.executeQuery();

            List<CartItem> cart = new ArrayList<>();

            double cartTotal = 0;

            Map<Integer, Integer> productVendorMap =
                    new HashMap<>();

            while (rs.next()) {

                CartItem item = new CartItem();

                int productId = rs.getInt("product_id");

                item.setProductId(productId);
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));

                cartTotal +=
                        item.getPrice() *
                        item.getQuantity();

                cart.add(item);

                productVendorMap.put(
                        productId,
                        rs.getInt("vendor_id")
                );
            }

            if (cart.isEmpty()) {

                response.getWriter()
                        .println("Cart is empty!");

                return;
            }

            // 🔥 DELIVERY FEE
            double deliveryFee = 50;

            double total = cartTotal + deliveryFee;

            // 🔥 PAYMENT STATUS
            String paymentStatus = "PENDING";

            if ("ONLINE".equalsIgnoreCase(paymentMode)) {
                paymentStatus = "PAID";
            }

            // 🔹 2. INSERT ORDER
            String orderSql =
                    "INSERT INTO orders" +
                    "(farmer_id, total_amount, status, " +
                    "payment_mode, payment_status, " +
                    "address, delivery_fee) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement orderPs =
                    conn.prepareStatement(
                            orderSql,
                            Statement.RETURN_GENERATED_KEYS
                    );

            orderPs.setInt(1, farmerId);
            orderPs.setDouble(2, total);
            orderPs.setString(3, "PENDING");
            orderPs.setString(4, paymentMode);
            orderPs.setString(5, paymentStatus);
            orderPs.setString(6, address);
            orderPs.setDouble(7, deliveryFee);

            orderPs.executeUpdate();

            ResultSet orderRs =
                    orderPs.getGeneratedKeys();

            int orderId = 0;

            if (orderRs.next()) {
                orderId = orderRs.getInt(1);
            }

            // 🔥 FARMER ORDER NOTIFICATION
            NotificationUtil.sendNotification(
                    farmerId,
                    "ORDER_PLACED",
                    orderId
            );

            // 🔥 AUTO ASSIGN DELIVERY
            String assignSql =
                    "SELECT u.user_id FROM users u " +
                    "LEFT JOIN deliveries d " +
                    "ON u.user_id = d.delivery_person_id " +
                    "AND d.status != 'DELIVERED' " +
                    "WHERE u.role='DELIVERY' " +
                    "GROUP BY u.user_id " +
                    "ORDER BY COUNT(d.delivery_id) ASC " +
                    "LIMIT 1";

            PreparedStatement assignPs =
                    conn.prepareStatement(assignSql);

            ResultSet assignRs =
                    assignPs.executeQuery();

            int deliveryPersonId = 0;

            if(assignRs.next()) {
                deliveryPersonId =
                        assignRs.getInt("user_id");
            }

            // 🔥 INSERT DELIVERY
            String insertDelivery =
                    "INSERT INTO deliveries" +
                    "(order_id, delivery_person_id, status) " +
                    "VALUES (?, ?, 'ASSIGNED')";

            PreparedStatement dps =
                    conn.prepareStatement(insertDelivery);

            dps.setInt(1, orderId);
            dps.setInt(2, deliveryPersonId);

            dps.executeUpdate();

            // 🔥 DELIVERY NOTIFICATION
            NotificationUtil.sendNotification(
                    deliveryPersonId,
                    "DELIVERY_ASSIGNED",
                    orderId
            );

            // 🔥 UPDATE ORDER
            String updateOrder =
                    "UPDATE orders " +
                    "SET delivery_person_id=? " +
                    "WHERE order_id=?";

            PreparedStatement ups =
                    conn.prepareStatement(updateOrder);

            ups.setInt(1, deliveryPersonId);
            ups.setInt(2, orderId);

            ups.executeUpdate();

            // 🔹 3. INSERT ORDER ITEMS
            String itemSql =
                    "INSERT INTO order_items" +
                    "(order_id, product_id, quantity, price) " +
                    "VALUES (?, ?, ?, ?)";

            for (CartItem item : cart) {

                PreparedStatement itemPs =
                        conn.prepareStatement(itemSql);

                itemPs.setInt(1, orderId);
                itemPs.setInt(2, item.getProductId());
                itemPs.setInt(3, item.getQuantity());
                itemPs.setDouble(4, item.getPrice());

                itemPs.executeUpdate();
            }

            // 🔹 4. VENDOR PAYMENTS
            double commissionRate = 0.10;

            String paymentSql =
                    "INSERT INTO vendor_payments" +
                    "(order_id, vendor_id, amount, " +
                    "commission, final_amount, payment_status) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

            Set<Integer> notifiedVendors =
                    new HashSet<>();

            for (CartItem item : cart) {

                int vendorId =
                        productVendorMap.get(
                                item.getProductId());

                double amount =
                        item.getPrice() *
                        item.getQuantity();

                double commission =
                        amount * commissionRate;

                double finalAmount =
                        amount - commission;

                PreparedStatement payPs =
                        conn.prepareStatement(paymentSql);

                payPs.setInt(1, orderId);
                payPs.setInt(2, vendorId);
                payPs.setDouble(3, amount);
                payPs.setDouble(4, commission);
                payPs.setDouble(5, finalAmount);
                payPs.setString(6, paymentStatus);

                payPs.executeUpdate();

                // 🔥 VENDOR NOTIFICATION
                if (!notifiedVendors.contains(vendorId)) {

                    NotificationUtil.sendNotification(
                            vendorId,
                            "NEW_VENDOR_ORDER",
                            orderId
                    );

                    notifiedVendors.add(vendorId);
                }
            }

            // 🔥 DELIVERY PAYMENT ENTRY
            String deliveryPaymentSql =
                    "INSERT INTO delivery_payments" +
                    "(order_id, delivery_person_id, amount, payment_status) " +
                    "VALUES (?, ?, ?, ?)";

            PreparedStatement dp =
                    conn.prepareStatement(deliveryPaymentSql);

            dp.setInt(1, orderId);
            dp.setInt(2, deliveryPersonId);
            dp.setDouble(3, deliveryFee);
            dp.setString(4, paymentStatus);

            dp.executeUpdate();

            // 🔹 5. CLEAR CART
            String deleteCart =
                    "DELETE FROM cart WHERE farmer_id=?";

            PreparedStatement delPs =
                    conn.prepareStatement(deleteCart);

            delPs.setInt(1, farmerId);

            delPs.executeUpdate();

            session.removeAttribute("cart");

            // 🔹 6. REDIRECT
            response.sendRedirect("orderSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}