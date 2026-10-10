<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !user.getRole().equalsIgnoreCase("LABOUR")) {
        response.sendRedirect("login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean hasData = false;

    try {
        conn = DBConnection.getConnection();

        String sql = "SELECT lb.*, ls.service_type, u.name AS farmer_name " +
                     "FROM labour_bookings lb " +
                     "JOIN labour_services ls ON lb.service_id = ls.service_id " +
                     "JOIN users u ON lb.farmer_id = u.user_id " +
                     "WHERE ls.leader_id=? ORDER BY lb.booking_id DESC";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, user.getUserId());
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Requests | KrushiConnect Labour</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .requests-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 1.5rem;
        }

        .request-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all var(--transition-normal);
        }

        .request-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-md);
            border-color: #a5b4fc;
        }

        .request-header {
            background: var(--slate-50);
            padding: 1.25rem;
            border-bottom: 1px solid var(--slate-100);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .request-body {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.65rem;
            flex: 1;
        }

        .request-footer {
            padding: 1.15rem 1.25rem;
            background: var(--slate-50);
            border-top: 1px solid var(--slate-100);
        }

        .action-btns-row {
            display: flex;
            gap: 0.75rem;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-labour">
    <div class="kc-brand">
        <div class="kc-brand-icon">🚜</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Service Requests</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="viewLabourServices.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-list-check"></i> My Services
        </a>
        <a href="labourDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="margin-bottom: 1.75rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-inbox" style="color: #4338ca; margin-right: 8px;"></i> Incoming Farmer Hire Requests
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Review field locations, schedule dates, and accept or reject farm work bookings.</p>
    </div>

    <div class="requests-grid">
<%
        while (rs.next()) {
            hasData = true;
            String status = rs.getString("status");
%>
        <div class="request-card">
            <div>
                <div class="request-header">
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 800; color: #312e81;">
                            <%= rs.getString("service_type") %>
                        </div>
                        <div style="font-size: 0.75rem; color: var(--slate-400);">
                            Request ID: #REQ-<%= rs.getInt("booking_id") %>
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

                <div class="request-body">
                    <div style="display: flex; align-items: center; gap: 0.65rem; background: #f8fafc; padding: 0.6rem 0.85rem; border-radius: 10px;">
                        <div style="width: 32px; height: 32px; border-radius: 50%; background: #dcfce7; color: #16a34a; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.8rem;">
                            🌾
                        </div>
                        <div>
                            <div style="font-size: 0.75rem; color: var(--slate-500);">Requesting Farmer</div>
                            <div style="font-size: 0.95rem; font-weight: 700; color: var(--slate-800);"><%= rs.getString("farmer_name") %></div>
                        </div>
                    </div>

                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--slate-600); margin-top: 0.25rem;">
                        <span><i class="fa-regular fa-calendar" style="margin-right: 4px;"></i> Required Dates:</span>
                        <strong><%= rs.getDate("from_date") %> &rarr; <%= rs.getDate("to_date") %></strong>
                    </div>

                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--slate-600);">
                        <span><i class="fa-solid fa-location-dot" style="margin-right: 4px;"></i> Field Address:</span>
                        <span style="font-weight: 500; color: var(--slate-800); text-align: right; max-width: 60%;"><%= rs.getString("address") %></span>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: baseline; padding-top: 0.5rem; border-top: 1px solid var(--slate-100); margin-top: 0.25rem;">
                        <span style="font-size: 0.85rem; font-weight: 600; color: var(--slate-500);">Total Compensation:</span>
                        <span style="font-family: var(--font-heading); font-size: 1.45rem; font-weight: 800; color: #15803d;">
                            ₹ <%= rs.getDouble("total_price") %>
                        </span>
                    </div>
                </div>
            </div>

            <!-- ACTION BUTTONS IF PENDING (UNCHANGED LOGIC & INPUTS) -->
            <% if(status != null && status.equalsIgnoreCase("PENDING")) { %>
                <div class="request-footer">
                    <form action="updateBookingStatus" method="post" class="action-btns-row">
                        <input type="hidden" name="bookingId" value="<%= rs.getInt("booking_id") %>">

                        <button type="submit" class="kc-btn kc-btn-primary" name="status" value="ACCEPTED" style="flex: 1;">
                            <i class="fa-solid fa-check"></i> Accept Work
                        </button>

                        <button type="submit" class="kc-btn kc-btn-danger" name="status" value="REJECTED" style="flex: 1;">
                            <i class="fa-solid fa-xmark"></i> Reject
                        </button>
                    </form>
                </div>
            <% } else { %>
                <div class="request-footer" style="text-align: center; font-size: 0.85rem; color: var(--slate-500); font-weight: 600;">
                    Decision logged as <%= status %>
                </div>
            <% } %>
        </div>
<%
        }

        if(!hasData){
%>
        <div style="grid-column: 1 / -1; padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200);">
            <div style="width: 72px; height: 72px; border-radius: 50%; background: #f1f5f9; color: #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-clipboard-check"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Service Requests</h3>
            <p style="color: var(--slate-500); font-size: 0.9rem; margin-top: 0.25rem;">You do not have any pending or active booking requests from farmers right now.</p>
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