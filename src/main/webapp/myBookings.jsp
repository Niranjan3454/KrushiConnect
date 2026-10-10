<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !user.getRole().equalsIgnoreCase("FARMER")) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean hasData = false;

    try {
        conn = DBConnection.getConnection();

        String sql = "SELECT lb.*, ls.service_type " +
                     "FROM labour_bookings lb " +
                     "JOIN labour_services ls ON lb.service_id = ls.service_id " +
                     "WHERE lb.farmer_id=? ORDER BY lb.booking_id DESC";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, user.getUserId());
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Labour Bookings | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .bookings-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 1.5rem;
        }

        .booking-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            transition: all var(--transition-normal);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .booking-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: #86efac;
        }

        .booking-card-header {
            background: var(--slate-50);
            padding: 1.25rem;
            border-bottom: 1px solid var(--slate-100);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .booking-card-body {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.65rem;
            flex: 1;
        }

        .booking-card-footer {
            padding: 1rem 1.25rem;
            background: var(--slate-50);
            border-top: 1px solid var(--slate-100);
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-farmer">
    <div class="kc-brand">
        <div class="kc-brand-icon">🚜</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Labour Bookings</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="viewServices.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-plus"></i> Hire More Labour
        </a>
        <a href="farmerDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="margin-bottom: 1.75rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-calendar-check" style="color: #16a34a; margin-right: 8px;"></i> My Labour Hire Requests
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Monitor crew approval status, schedule dates, and settlement payments.</p>
    </div>

    <div class="bookings-grid">
<%
        while (rs.next()) {
            hasData = true;

            String status = rs.getString("status");
            String paymentStatus = rs.getString("payment_status");
            if(paymentStatus == null) paymentStatus = "PENDING";
%>
        <div class="booking-card">
            <div>
                <div class="booking-card-header">
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 800; color: var(--slate-900);">
                            <%= rs.getString("service_type") %>
                        </div>
                        <div style="font-size: 0.75rem; color: var(--slate-400);">
                            Booking ID: #LBK-<%= rs.getInt("booking_id") %>
                        </div>
                    </div>

                    <div>
                        <%
                            String bClass = "badge-pending";
                            if("ACCEPTED".equalsIgnoreCase(status) || "COMPLETED".equalsIgnoreCase(status)) bClass = "badge-active";
                            else if("REJECTED".equalsIgnoreCase(status)) bClass = "badge-inactive";
                        %>
                        <span class="kc-badge <%= bClass %>">
                            <span class="kc-badge-dot"></span> <%= status %>
                        </span>
                    </div>
                </div>

                <div class="booking-card-body">
                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--slate-600);">
                        <span><i class="fa-regular fa-calendar" style="margin-right: 4px;"></i> Schedule Dates:</span>
                        <strong><%= rs.getDate("from_date") %> &rarr; <%= rs.getDate("to_date") %></strong>
                    </div>

                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--slate-600);">
                        <span><i class="fa-regular fa-clock" style="margin-right: 4px;"></i> Total Working Days:</span>
                        <strong><%= rs.getInt("total_days") %> Days</strong>
                    </div>

                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--slate-600);">
                        <span><i class="fa-solid fa-location-dot" style="margin-right: 4px;"></i> Farm Location:</span>
                        <span style="font-weight: 500; color: var(--slate-800); text-align: right; max-width: 60%;"><%= rs.getString("address") %></span>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: baseline; padding-top: 0.5rem; border-top: 1px solid var(--slate-100); margin-top: 0.35rem;">
                        <span style="font-size: 0.85rem; font-weight: 600; color: var(--slate-500);">Total Labour Cost:</span>
                        <span style="font-family: var(--font-heading); font-size: 1.4rem; font-weight: 800; color: #15803d;">
                            ₹ <%= rs.getDouble("total_price") %>
                        </span>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; font-size: 0.85rem;">
                        <span style="font-weight: 600; color: var(--slate-500);">Payment Status:</span>
                        <%
                            String pClass = "badge-pending";
                            if("PAID".equalsIgnoreCase(paymentStatus)) pClass = "badge-paid";
                        %>
                        <span class="kc-badge <%= pClass %>"><%= paymentStatus %></span>
                    </div>
                </div>
            </div>

            <!-- PAYMENT ACTION FOOTER (UNCHANGED LOGIC) -->
            <div class="booking-card-footer">
                <% if("ACCEPTED".equals(status) && !"PAID".equalsIgnoreCase(paymentStatus)) { %>
                    <form action="labourPayment.jsp" method="post">
                        <input type="hidden" name="bookingId" value="<%= rs.getInt("booking_id") %>">
                        <input type="hidden" name="amount" value="<%= rs.getDouble("total_price") %>">
                        <button class="kc-btn kc-btn-primary kc-btn-block" type="submit">
                            <i class="fa-solid fa-credit-card"></i> Pay Now (₹<%= rs.getDouble("total_price") %>)
                        </button>
                    </form>
                <% } else if("PAID".equalsIgnoreCase(paymentStatus)) { %>
                    <div style="display: flex; align-items: center; justify-content: center; gap: 0.5rem; color: #15803d; font-weight: 700; font-size: 0.9rem;">
                        <i class="fa-solid fa-circle-check"></i> Labour Payment Settled
                    </div>
                <% } else { %>
                    <div style="text-align: center; font-size: 0.8rem; color: #94a3b8;">
                        Awaiting Leader Approval Before Payment
                    </div>
                <% } %>
            </div>
        </div>
<%
        }

        if(!hasData){
%>
        <div style="grid-column: 1 / -1; padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200);">
            <div style="width: 72px; height: 72px; border-radius: 50%; background: #f1f5f9; color: #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-calendar-xmark"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Labour Bookings Yet</h3>
            <p style="color: var(--slate-500); font-size: 0.9rem; margin-top: 0.25rem;">Explore available agricultural crews and schedule field work.</p>
            <a href="viewServices.jsp" class="kc-btn kc-btn-primary" style="margin-top: 1.25rem;">
                Find Available Labour
            </a>
        </div>
<%
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(ps != null) ps.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>
    </div>

</div>

</body>
</html>