package com.Krushiconnect.util;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class NotificationUtil {

    // 🔥 AUTO MESSAGE GENERATOR
    public static String generateMessage(String type, int refId) {

        switch(type) {

            // 📦 ORDER
            case "ORDER_PLACED":
                return "📦 Your Order #" + refId +
                        " has been placed successfully.";

            case "ORDER_CANCELLED":
                return "❌ Your Order #" + refId +
                        " has been cancelled.";

            case "ORDER_ASSIGNED":
                return "🚚 Delivery assigned for Order #" + refId;

            case "ORDER_OUT_FOR_DELIVERY":
                return "📍 Order #" + refId +
                        " is out for delivery.";

            case "ORDER_DELIVERED":
                return "✅ Order #" + refId +
                        " delivered successfully.";

            case "ORDER_DELAYED":
                return "⏳ Order #" + refId +
                        " delivery delayed.";
                
            case "NEW_VENDOR_ORDER":
                return "🛒 New order received! Order ID #" + refId;

            // 💳 PAYMENT
            case "PAYMENT_SUCCESS":
                return "💳 Payment successful for Order ID #" + refId;

            case "PAYMENT_FAILED":
                return "❌ Payment failed for Order ID #" + refId;

            case "COD_CONFIRMED":
                return "💰 Cash on delivery payment confirmed.";

            case "REFUND_SUCCESS":
                return "💸 Refund processed successfully.";

            // 🛒 CART
            case "PRODUCT_ADDED":
                return "🛒 Product added to cart.";

            case "PRODUCT_REMOVED":
                return "🗑 Product removed from cart.";

            // 🚚 DELIVERY
            case "DELIVERY_ASSIGNED":
                return "🚚 New delivery assigned.";

            case "DELIVERY_PICKED":
                return "📦 Parcel picked for delivery.";

            case "DELIVERY_COMPLETED":
                return "✅ Delivery completed successfully.";

            case "DELIVERY_EARNING_CREDITED":
                return "💰 Delivery earnings credited.";

            // 👷 LABOUR
            case "LABOUR_BOOKED":
                return "👷 Labour booking request submitted.";
                
            case "NEW_LABOUR_BOOKING":
                return "📥 New labour booking request received.";

            case "LABOUR_APPROVED":
                return "✅ Labour booking approved.";

            case "LABOUR_REJECTED":
                return "❌ Labour booking rejected.";

            case "LABOUR_COMPLETED":
                return "🏁 Labour work completed.";

            case "LABOUR_PAYMENT_RELEASED":
                return "💰 Labour payment released.";

            // 📦 PRODUCT
            case "PRODUCT_ADDED_SUCCESS":
                return "📦 Product added successfully.";

            case "LOW_STOCK":
                return "⚠ Product stock running low.";

            case "OUT_OF_STOCK":
                return "❌ Product out of stock.";

            // 🔐 ACCOUNT
            case "PASSWORD_RESET":
                return "🔒 Password updated successfully.";

            case "NEW_LOGIN":
                return "🔐 New login detected.";

            case "ACCOUNT_CREATED":
                return "🎉 Account created successfully.";

            // ⚙ SYSTEM
            case "SYSTEM_ALERT":
                return "⚠ System alert notification.";

            case "ADMIN_WARNING":
                return "🚨 Admin warning notification.";

            default:
                return "🔔 New Notification";
        }
    }

    // 🔥 SAVE NOTIFICATION
    public static void sendNotification(
            int userId,
            String type,
            int refId) {

        try {

            Connection conn = DBConnection.getConnection();

            String message = generateMessage(type, refId);

            String sql =
                    "INSERT INTO notifications(user_id, message) VALUES(?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);
            ps.setString(2, message);

            ps.executeUpdate();

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}