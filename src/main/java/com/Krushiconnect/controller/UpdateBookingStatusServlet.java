package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.util.DBConnection;
import com.Krushiconnect.util.NotificationUtil;

@WebServlet("/updateBookingStatus")
public class UpdateBookingStatusServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            int bookingId =
                    Integer.parseInt(
                            request.getParameter("bookingId"));

            String status =
                    request.getParameter("status");

            Connection conn =
                    DBConnection.getConnection();

            // 🔥 UPDATE STATUS
            String sql =
                    "UPDATE labour_bookings " +
                    "SET status=? " +
                    "WHERE booking_id=?";

            PreparedStatement ps =
                    conn.prepareStatement(sql);

            ps.setString(1, status);
            ps.setInt(2, bookingId);

            ps.executeUpdate();

            // 🔥 GET FARMER ID
            String farmerSql =
                    "SELECT farmer_id " +
                    "FROM labour_bookings " +
                    "WHERE booking_id=?";

            PreparedStatement ps2 =
                    conn.prepareStatement(farmerSql);

            ps2.setInt(1, bookingId);

            ResultSet rs =
                    ps2.executeQuery();

            if (rs.next()) {

                int farmerId =
                        rs.getInt("farmer_id");

                // 🔥 ACCEPTED
                if ("ACCEPTED".equalsIgnoreCase(status)) {

                    NotificationUtil.sendNotification(
                            farmerId,
                            "LABOUR_APPROVED",
                            bookingId
                    );
                }

                // 🔥 REJECTED
                if ("REJECTED".equalsIgnoreCase(status)) {

                    NotificationUtil.sendNotification(
                            farmerId,
                            "LABOUR_REJECTED",
                            bookingId
                    );
                }

                // 🔥 COMPLETED
                if ("COMPLETED".equalsIgnoreCase(status)) {

                    NotificationUtil.sendNotification(
                            farmerId,
                            "LABOUR_COMPLETED",
                            bookingId
                    );
                }
            }

            response.sendRedirect("viewBookings.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}