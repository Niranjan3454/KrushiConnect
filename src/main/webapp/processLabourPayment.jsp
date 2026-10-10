<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>

<%
    int bookingId = Integer.parseInt(request.getParameter("bookingId"));
    String method = request.getParameter("method");

    // VALIDATION (UNCHANGED LOGIC)
    if("UPI".equals(method)){
        String upi = request.getParameter("upi");
        String pass = request.getParameter("upiPass");

        if(upi == null || !upi.contains("@")){
            out.println("<div style='color:red; font-family:sans-serif; padding:2rem; text-align:center;'>❌ Invalid UPI Address. <a href='myBookings.jsp'>Go Back</a></div>");
            return;
        }

        if(pass == null || pass.length() < 4){
            out.println("<div style='color:red; font-family:sans-serif; padding:2rem; text-align:center;'>❌ Invalid Password/PIN. <a href='myBookings.jsp'>Go Back</a></div>");
            return;
        }

    } else if("CARD".equals(method)){
        String card = request.getParameter("card");
        String cvv = request.getParameter("cvv");

        if(card == null || card.length() < 12){
            out.println("<div style='color:red; font-family:sans-serif; padding:2rem; text-align:center;'>❌ Invalid Card Number. <a href='myBookings.jsp'>Go Back</a></div>");
            return;
        }

        if(cvv == null || cvv.length() != 3){
            out.println("<div style='color:red; font-family:sans-serif; padding:2rem; text-align:center;'>❌ Invalid CVV. <a href='myBookings.jsp'>Go Back</a></div>");
            return;
        }
    }

    Connection conn = null;
    PreparedStatement ps = null;
    PreparedStatement ps2 = null;
    ResultSet rs = null;
    PreparedStatement ps3 = null;

    try {
        conn = DBConnection.getConnection();

        // 1. UPDATE BOOKING STATUS (UNCHANGED LOGIC)
        String sql = "UPDATE labour_bookings SET payment_mode=?, payment_status='PAID' WHERE booking_id=?";
        ps = conn.prepareStatement(sql);
        ps.setString(1, method);
        ps.setInt(2, bookingId);
        ps.executeUpdate();

        // 2. FETCH LEADER & PRICE
        String fetchSql = "SELECT ls.leader_id, lb.total_price " +
                          "FROM labour_bookings lb " +
                          "JOIN labour_services ls ON lb.service_id = ls.service_id " +
                          "WHERE lb.booking_id=?";
        ps2 = conn.prepareStatement(fetchSql);
        ps2.setInt(1, bookingId);
        rs = ps2.executeQuery();

        if(rs.next()){
            int leaderId = rs.getInt("leader_id");
            double total = rs.getDouble("total_price");

            double commissionRate = 0.10;
            double commission = total * commissionRate;
            double finalAmount = total - commission;

            // 3. INSERT INTO LABOUR_PAYMENTS
            String insertSql = "INSERT INTO labour_payments " +
                    "(booking_id, leader_id, total_amount, commission, final_amount, payment_status) " +
                    "VALUES (?, ?, ?, ?, ?, 'PAID')";
            ps3 = conn.prepareStatement(insertSql);
            ps3.setInt(1, bookingId);
            ps3.setInt(2, leaderId);
            ps3.setDouble(3, total);
            ps3.setDouble(4, commission);
            ps3.setDouble(5, finalAmount);
            ps3.executeUpdate();
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(ps != null) ps.close(); } catch(Exception e) {}
        try { if(ps2 != null) ps2.close(); } catch(Exception e) {}
        try { if(ps3 != null) ps3.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.9) 0%, rgba(20, 83, 45, 0.85) 100%),
                        url('https://images.unsplash.com/photo-1499529112087-3cb3b73cec95?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            color: #ffffff;
        }

        .success-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 28px;
            padding: 3.5rem 2.5rem;
            text-align: center;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .check-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(34, 197, 94, 0.25);
            border: 2px solid #4ade80;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #4ade80;
            margin: 0 auto 1.5rem;
            animation: kcPulse 2s infinite;
        }

        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 0.85rem;
            margin-top: 2rem;
        }
    </style>
</head>

<body>

<div class="success-card">

    <div class="check-icon">
        <i class="fa-solid fa-check"></i>
    </div>

    <h2 style="font-size: 1.85rem; font-weight: 800; color: #ffffff; margin-bottom: 0.5rem; letter-spacing: -0.02em;">
        Payment Settled Successfully!
    </h2>

    <p style="font-size: 0.95rem; color: #cbd5e1; line-height: 1.6;">
        Labour booking <strong>#LBK-<%= bookingId %></strong> has been marked as <strong>PAID</strong>. The crew leader payout has been credited with platform commission deduction.
    </p>

    <!-- ACTION LINKS (UNCHANGED LOGIC) -->
    <div class="btn-group">
        <a href="myBookings.jsp" style="text-decoration: none;">
            <button class="kc-btn kc-btn-primary kc-btn-lg kc-btn-block">
                <i class="fa-solid fa-calendar-check"></i> View My Bookings
            </button>
        </a>

        <a href="farmerDashboard.jsp" style="text-decoration: none;">
            <button class="kc-btn kc-btn-outline-white kc-btn-block">
                <i class="fa-solid fa-house"></i> Farmer Dashboard
            </button>
        </a>
    </div>

</div>

</body>
</html>