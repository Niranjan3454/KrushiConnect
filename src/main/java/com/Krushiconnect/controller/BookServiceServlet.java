package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.Krushiconnect.model.User;
import com.Krushiconnect.util.DBConnection;
import com.Krushiconnect.util.NotificationUtil;

@WebServlet("/bookService")
public class BookServiceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            HttpSession session = request.getSession();

            User user =
                    (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int farmerId = user.getUserId();

            int serviceId =
                    Integer.parseInt(
                            request.getParameter("serviceId"));

            String fromDate =
                    request.getParameter("fromDate");

            String toDate =
                    request.getParameter("toDate");

            String address =
                    request.getParameter("address");

            String paymentMode =
                    request.getParameter("paymentMode");

            Connection conn =
                    DBConnection.getConnection();

            // 🔥 CHECK AVAILABILITY
            String checkSql =
                    "SELECT * FROM labour_bookings " +
                    "WHERE service_id=? " +
                    "AND status='ACCEPTED' " +
                    "AND NOT (to_date < ? OR from_date > ?)";

            PreparedStatement checkPs =
                    conn.prepareStatement(checkSql);

            checkPs.setInt(1, serviceId);
            checkPs.setString(2, fromDate);
            checkPs.setString(3, toDate);

            ResultSet checkRs =
                    checkPs.executeQuery();

            if (checkRs.next()) {

                response.getWriter().println(
                        "❌ Service not available for selected dates!"
                );

                return;
            }

            // 🔥 GET PRICE
            String priceSql =
                    "SELECT price_per_day " +
                    "FROM labour_services " +
                    "WHERE service_id=?";

            PreparedStatement pricePs =
                    conn.prepareStatement(priceSql);

            pricePs.setInt(1, serviceId);

            ResultSet priceRs =
                    pricePs.executeQuery();

            double pricePerDay = 0;

            if (priceRs.next()) {
                pricePerDay =
                        priceRs.getDouble("price_per_day");
            }

            // 🔥 CALCULATE DAYS
            java.sql.Date d1 =
                    java.sql.Date.valueOf(fromDate);

            java.sql.Date d2 =
                    java.sql.Date.valueOf(toDate);

            long diff =
                    d2.getTime() - d1.getTime();

            int days =
                    (int) (diff / (1000 * 60 * 60 * 24)) + 1;

            if (days <= 0) {

                response.getWriter().println(
                        "❌ Invalid date range!"
                );

                return;
            }

            double totalPrice =
                    days * pricePerDay;

            // 🔥 PAYMENT STATUS
            String paymentStatus = "PENDING";

            if ("ONLINE".equalsIgnoreCase(paymentMode)) {
                paymentStatus = "PAID";
            }

            // 🔥 INSERT BOOKING
            String insertSql =
                    "INSERT INTO labour_bookings " +
                    "(service_id, farmer_id, from_date, to_date, " +
                    "total_days, total_price, address, status, " +
                    "payment_mode, payment_status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, 'PENDING', ?, ?)";

            PreparedStatement ps =
                    conn.prepareStatement(
                            insertSql,
                            PreparedStatement.RETURN_GENERATED_KEYS
                    );

            ps.setInt(1, serviceId);
            ps.setInt(2, farmerId);
            ps.setString(3, fromDate);
            ps.setString(4, toDate);
            ps.setInt(5, days);
            ps.setDouble(6, totalPrice);
            ps.setString(7, address);

            ps.setString(8, paymentMode);
            ps.setString(9, paymentStatus);

            ps.executeUpdate();

            // 🔥 GET BOOKING ID
            ResultSet bookingRs =
                    ps.getGeneratedKeys();

            int bookingId = 0;

            if (bookingRs.next()) {
                bookingId = bookingRs.getInt(1);
            }

            // 🔥 FARMER NOTIFICATION
            NotificationUtil.sendNotification(
                    farmerId,
                    "LABOUR_BOOKED",
                    bookingId
            );

            // 🔥 GET LEADER ID
            String leaderSql =
                    "SELECT leader_id " +
                    "FROM labour_services " +
                    "WHERE service_id=?";

            PreparedStatement leaderPs =
                    conn.prepareStatement(leaderSql);

            leaderPs.setInt(1, serviceId);

            ResultSet leaderRs =
                    leaderPs.executeQuery();

            if (leaderRs.next()) {

                int leaderId =
                        leaderRs.getInt("leader_id");

                // 🔥 LABOUR LEADER NOTIFICATION
                NotificationUtil.sendNotification(
                        leaderId,
                        "NEW_LABOUR_BOOKING",
                        bookingId
                );
            }

            response.sendRedirect("myBookings.jsp");

        } catch (Exception e) {

            e.printStackTrace();

            response.getWriter().println(
                    "❌ Error while booking service"
            );
        }
    }
}