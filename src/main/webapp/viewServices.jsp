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
        String sql = "SELECT ls.*, u.name FROM labour_services ls JOIN users u ON ls.leader_id = u.user_id";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hire Labour Services | KrushiConnect Farm Force</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
            gap: 1.75rem;
        }

        .service-card {
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

        .service-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: #86efac;
        }

        .service-header {
            background: linear-gradient(135deg, #f0fdf4 0%, #ecfdf5 100%);
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #dcfce7;
        }

        .service-body {
            padding: 1.5rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 0.85rem;
        }

        .booking-box {
            background: var(--slate-50);
            border-top: 1px solid var(--slate-100);
            padding: 1.25rem 1.5rem;
        }

        .date-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.75rem;
            margin-bottom: 0.75rem;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-farmer">
    <div class="kc-brand">
        <div class="kc-brand-icon">🚜</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| On-Demand Labour</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="myBookings.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-calendar-check"></i> My Bookings
        </a>
        <a href="farmerDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="margin-bottom: 1.75rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-person-digging" style="color: #16a34a; margin-right: 8px;"></i> Available Agricultural Services
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Hire verified labor groups and machinery for sowing, harvesting, tilling & irrigation.</p>
    </div>

    <div class="services-grid">
<%
        while(rs.next()){
            hasData = true;
%>
        <div class="service-card">
            <div>
                <div class="service-header">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                        <h3 style="font-size: 1.25rem; font-weight: 800; color: #14532d;">
                            <%= rs.getString("service_type") %>
                        </h3>
                        <span class="kc-badge badge-active">VERIFIED</span>
                    </div>

                    <div style="font-size: 1.35rem; font-weight: 800; color: #15803d; margin-top: 0.35rem; font-family: var(--font-heading);">
                        ₹ <%= rs.getDouble("price_per_day") %> <span style="font-size: 0.85rem; font-weight: 500; color: var(--slate-600);">/ day</span>
                    </div>
                </div>

                <div class="service-body">
                    <div style="display: flex; align-items: center; gap: 0.75rem;">
                        <div style="width: 38px; height: 38px; border-radius: 50%; background: #e0e7ff; color: #4338ca; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.9rem;">
                            👷
                        </div>
                        <div>
                            <div style="font-size: 0.8rem; color: var(--slate-500);">Crew Leader</div>
                            <div style="font-weight: 700; color: var(--slate-800);"><%= rs.getString("name") %></div>
                        </div>

                        <div style="margin-left: auto; background: #f1f5f9; padding: 0.35rem 0.75rem; border-radius: 8px; font-size: 0.85rem; font-weight: 600; color: var(--slate-700);">
                            <i class="fa-solid fa-users" style="color: #64748b; margin-right: 4px;"></i> <%= rs.getInt("team_size") %> Workers
                        </div>
                    </div>

                    <p style="font-size: 0.88rem; color: var(--slate-600); line-height: 1.5; margin-top: 0.25rem;">
                        <%= rs.getString("description") %>
                    </p>
                </div>
            </div>

            <!-- BOOKING FORM (UNCHANGED LOGIC & INPUTS) -->
            <div class="booking-box">
                <form action="bookService" method="post">
                    <input type="hidden" name="serviceId" value="<%= rs.getInt("service_id") %>">

                    <div class="date-row">
                        <div>
                            <label class="kc-label" style="font-size: 0.75rem;">From Date</label>
                            <input type="date"
                                   name="fromDate"
                                   class="kc-input"
                                   style="padding: 0.55rem; font-size: 0.85rem;"
                                   min="<%= new java.sql.Date(System.currentTimeMillis()) %>"
                                   required>
                        </div>
                        <div>
                            <label class="kc-label" style="font-size: 0.75rem;">To Date</label>
                            <input type="date"
                                   name="toDate"
                                   class="kc-input"
                                   style="padding: 0.55rem; font-size: 0.85rem;"
                                   required>
                        </div>
                    </div>

                    <div style="margin-bottom: 0.85rem;">
                        <label class="kc-label" style="font-size: 0.75rem;">Farm / Field Location Address</label>
                        <textarea name="address"
                                  class="kc-textarea"
                                  placeholder="Survey no, village, road directions"
                                  style="height: 65px; font-size: 0.85rem;"
                                  required></textarea>
                    </div>

                    <button type="submit" class="kc-btn kc-btn-primary kc-btn-block">
                        <i class="fa-solid fa-calendar-plus"></i> Request Booking
                    </button>
                </form>
            </div>
        </div>
<%
        }

        if(!hasData){
%>
        <div style="grid-column: 1 / -1; padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200);">
            <div style="width: 72px; height: 72px; border-radius: 50%; background: #f1f5f9; color: #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-person-digging"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Labour Services Listed</h3>
            <p style="color: var(--slate-500); font-size: 0.9rem; margin-top: 0.25rem;">Service providers will list agricultural crews here soon.</p>
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