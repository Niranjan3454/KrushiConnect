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
        String sql = "SELECT * FROM labour_services WHERE leader_id=? ORDER BY service_id DESC";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, user.getUserId());
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Labour Services | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
        }

        .service-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            box-shadow: var(--shadow-sm);
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all var(--transition-normal);
        }

        .service-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: #a5b4fc;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-labour">
    <div class="kc-brand">
        <div class="kc-brand-icon">🚜</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| My Services</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="addService.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-plus"></i> Post New Service
        </a>
        <a href="labourDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1.75rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
                <i class="fa-solid fa-list-check" style="color: #4338ca; margin-right: 8px;"></i> My Registered Services
            </h1>
            <p style="color: var(--slate-500); font-size: 0.95rem;">Active farm operations and rates available to hiring farmers.</p>
        </div>

        <a href="addService.jsp" class="kc-btn kc-btn-primary">
            <i class="fa-solid fa-plus"></i> Add Service
        </a>
    </div>

    <div class="services-grid">
<%
        while(rs.next()){
            hasData = true;
%>
        <div class="service-card">
            <div>
                <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.75rem;">
                    <h3 style="font-size: 1.25rem; font-weight: 800; color: #312e81;">
                        <%= rs.getString("service_type") %>
                    </h3>
                    <span class="kc-badge badge-active">ACTIVE</span>
                </div>

                <div style="font-family: var(--font-heading); font-size: 1.5rem; font-weight: 800; color: #15803d; margin-bottom: 0.75rem;">
                    ₹ <%= rs.getDouble("price_per_day") %> <span style="font-size: 0.85rem; font-weight: 500; color: var(--slate-500);">/ day</span>
                </div>

                <div style="display: flex; align-items: center; gap: 0.5rem; background: #f8fafc; padding: 0.5rem 0.75rem; border-radius: 8px; margin-bottom: 0.75rem; font-size: 0.85rem; font-weight: 600; color: var(--slate-700);">
                    <i class="fa-solid fa-users" style="color: #6366f1;"></i>
                    <span>Team / Crew Size: <strong><%= rs.getInt("team_size") %> Workers</strong></span>
                </div>

                <p style="font-size: 0.875rem; color: var(--slate-600); line-height: 1.5;">
                    <%= rs.getString("description") %>
                </p>
            </div>

            <div style="padding-top: 1rem; border-top: 1px solid var(--slate-100); margin-top: 1rem; font-size: 0.8rem; color: var(--slate-400);">
                ID: #SRV-<%= rs.getInt("service_id") %> &bull; Listed by Leader #<%= user.getUserId() %>
            </div>
        </div>
<%
        }

        if(!hasData){
%>
        <div style="grid-column: 1 / -1; padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200);">
            <div style="width: 72px; height: 72px; border-radius: 50%; background: #f1f5f9; color: #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-screwdriver-wrench"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Services Registered Yet</h3>
            <p style="color: var(--slate-500); font-size: 0.9rem; margin-top: 0.25rem;">Start offering your agricultural harvesting, sowing, or equipment services to local farmers.</p>
            <a href="addService.jsp" class="kc-btn kc-btn-primary" style="margin-top: 1.25rem;">
                <i class="fa-solid fa-plus"></i> Register First Service
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