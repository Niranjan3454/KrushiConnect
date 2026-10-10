<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean hasData = false;

    try {
        conn = DBConnection.getConnection();
        String sql = "SELECT * FROM products ORDER BY status ASC, product_id DESC";
        ps = conn.prepareStatement(sql);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products | KrushiConnect Super Admin</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .action-toggle-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.4rem 0.85rem;
            border-radius: var(--radius-sm);
            font-size: 0.825rem;
            font-weight: 700;
            text-decoration: none;
            transition: all var(--transition-fast);
        }

        .btn-disable {
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fca5a5;
        }
        .btn-disable:hover {
            background: #dc2626;
            color: #ffffff;
        }

        .btn-enable {
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #86efac;
        }
        .btn-enable:hover {
            background: #15803d;
            color: #ffffff;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-admin">
    <div class="kc-brand">
        <div class="kc-brand-icon">📦</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.85;">| Catalog Moderation</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="adminAnalytics.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-chart-line"></i> Analytics
        </a>
        <a href="viewUsers.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-users"></i> Users
        </a>
        <a href="adminDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="margin-bottom: 1.75rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-boxes-stacked" style="color: #6366f1; margin-right: 8px;"></i> Vendor Products Management
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Moderate agricultural catalog inventory and disable or re-enable listings instantly.</p>
    </div>

    <div class="kc-table-wrapper">
        <table class="kc-table">
            <thead>
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th>Product Title</th>
                    <th>Price</th>
                    <th>Status</th>
                    <th style="text-align: right;">Moderation Action</th>
                </tr>
            </thead>
            <tbody>
<%
        while(rs.next()){
            hasData = true;
            int productId = rs.getInt("product_id");
            String name = rs.getString("name");
            double price = rs.getDouble("price");
            String status = rs.getString("status");
%>
                <tr>
                    <td style="font-weight: 700; color: var(--slate-500);">#<%= productId %></td>
                    <td>
                        <div style="font-weight: 700; color: var(--slate-900);"><%= name %></div>
                    </td>
                    <td style="font-family: var(--font-heading); font-size: 1.05rem; font-weight: 800; color: #15803d;">
                        ₹ <%= price %>
                    </td>
                    <td>
                        <% if(status != null && status.equalsIgnoreCase("ACTIVE")){ %>
                            <span class="kc-badge badge-active">
                                <span class="kc-badge-dot"></span> ACTIVE
                            </span>
                        <% } else { %>
                            <span class="kc-badge badge-inactive">
                                <span class="kc-badge-dot"></span> <%= status != null ? status : "INACTIVE" %>
                            </span>
                        <% } %>
                    </td>
                    <td style="text-align: right;">
                        <!-- ORIGINAL ACTION LINKS (UNCHANGED LOGIC & URL) -->
                        <% if(status != null && status.equalsIgnoreCase("ACTIVE")){ %>
                            <a class="action-toggle-btn btn-disable" href="disableProduct?productId=<%= productId %>">
                                <i class="fa-solid fa-ban"></i> Disable Listing
                            </a>
                        <% } else { %>
                            <a class="action-toggle-btn btn-enable" href="enableProduct?productId=<%= productId %>">
                                <i class="fa-solid fa-check"></i> Re-Enable Listing
                            </a>
                        <% } %>
                    </td>
                </tr>
<%
        }
%>
            </tbody>
        </table>
    </div>

<%
        if(!hasData){
%>
    <div style="padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200); margin-top: 1.5rem;">
        <i class="fa-solid fa-box-open" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 1rem; display: block;"></i>
        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Products Available</h3>
        <p style="color: var(--slate-500); font-size: 0.9rem;">No vendor product listings found in the database.</p>
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

</body>
</html>