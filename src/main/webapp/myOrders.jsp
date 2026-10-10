<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int farmerId = user.getUserId();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean hasOrders = false;

    try {
        conn = DBConnection.getConnection();

        String sql = "SELECT o.order_id, o.total_amount, o.status AS order_status, o.order_date, o.delivery_fee, " +
                     "d.status AS delivery_status, u.name AS delivery_name, u.phone AS delivery_phone " +
                     "FROM orders o " +
                     "LEFT JOIN deliveries d ON o.order_id = d.order_id " +
                     "LEFT JOIN users u ON d.delivery_person_id = u.user_id " +
                     "WHERE o.farmer_id=? ORDER BY o.order_id DESC";

        ps = conn.prepareStatement(sql);
        ps.setInt(1, farmerId);
        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders | KrushiConnect Tracking</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .orders-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 1.5rem;
        }

        .order-card {
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

        .order-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: #86efac;
        }

        .order-card-header {
            background: var(--slate-50);
            padding: 1.25rem;
            border-bottom: 1px solid var(--slate-100);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .order-card-body {
            padding: 1.25rem;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .delivery-info-box {
            background: #f8fafc;
            border: 1px solid var(--slate-200);
            border-radius: var(--radius-md);
            padding: 1rem;
            margin-top: 0.5rem;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-farmer">
    <div class="kc-brand">
        <div class="kc-brand-icon">📦</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Order Tracking</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="viewProducts.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-store"></i> Browse Catalog
        </a>
        <a href="farmerDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="margin-bottom: 1.75rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-boxes-packing" style="color: #16a34a; margin-right: 8px;"></i> My Purchase Orders
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Track real-time delivery status, partner details, and order history.</p>
    </div>

    <div class="orders-grid">
<%
        while (rs.next()) {
            hasOrders = true;
            String orderStatus = rs.getString("order_status");
            String deliveryStatus = rs.getString("delivery_status");
            if(deliveryStatus == null) deliveryStatus = "Not Assigned";
            String delName = rs.getString("delivery_name");
            String delPhone = rs.getString("delivery_phone");
%>
        <div class="order-card">
            <div>
                <div class="order-card-header">
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 800; color: var(--slate-900);">
                            Order #<%= rs.getInt("order_id") %>
                        </div>
                        <div style="font-size: 0.75rem; color: var(--slate-400); margin-top: 2px;">
                            <%= rs.getTimestamp("order_date") != null ? rs.getTimestamp("order_date") : "Recent Order" %>
                        </div>
                    </div>

                    <div>
                        <%
                            String bClass = "badge-pending";
                            if("DELIVERED".equalsIgnoreCase(orderStatus) || "PAID".equalsIgnoreCase(orderStatus)) bClass = "badge-delivered";
                            else if("OUT_FOR_DELIVERY".equalsIgnoreCase(orderStatus)) bClass = "badge-out_for_delivery";
                        %>
                        <span class="kc-badge <%= bClass %>">
                            <span class="kc-badge-dot"></span> <%= orderStatus %>
                        </span>
                    </div>
                </div>

                <div class="order-card-body">
                    <div style="display: flex; justify-content: space-between; align-items: baseline;">
                        <span style="font-size: 0.85rem; color: var(--slate-500); font-weight: 600;">Order Total:</span>
                        <span style="font-family: var(--font-heading); font-size: 1.45rem; font-weight: 800; color: #15803d;">
                            ₹ <%= rs.getDouble("total_amount") %>
                        </span>
                    </div>

                    <div style="display: flex; justify-content: space-between; font-size: 0.85rem; color: var(--slate-600);">
                        <span>Delivery Fee Included:</span>
                        <strong style="color: var(--slate-800);">₹ <%= rs.getDouble("delivery_fee") %></strong>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; padding-top: 0.5rem; border-top: 1px solid var(--slate-100);">
                        <span style="font-size: 0.85rem; color: var(--slate-500); font-weight: 600;">Delivery Status:</span>
                        <%
                            String dClass = "badge-pending";
                            if("DELIVERED".equalsIgnoreCase(deliveryStatus)) dClass = "badge-delivered";
                            else if("OUT_FOR_DELIVERY".equalsIgnoreCase(deliveryStatus)) dClass = "badge-out_for_delivery";
                            else if("PICKED".equalsIgnoreCase(deliveryStatus)) dClass = "badge-delivery";
                        %>
                        <span class="kc-badge <%= dClass %>">
                            <span class="kc-badge-dot"></span> <%= deliveryStatus.replace('_', ' ') %>
                        </span>
                    </div>

                    <!-- DELIVERY PERSON DETAILS BOX (UNCHANGED DATA) -->
                    <div class="delivery-info-box">
                        <div style="font-size: 0.8rem; font-weight: 700; text-transform: uppercase; color: var(--slate-500); margin-bottom: 0.5rem; letter-spacing: 0.05em;">
                            <i class="fa-solid fa-truck-ramp-box" style="color: #0284c7; margin-right: 4px;"></i> Delivery Executive
                        </div>

                        <div style="font-size: 0.9rem; font-weight: 600; color: var(--slate-800); margin-bottom: 0.25rem;">
                            <%= delName != null ? delName : "Assigning Partner..." %>
                        </div>

                        <% if(delPhone != null && !delPhone.trim().equals("-")) { %>
                            <div style="font-size: 0.85rem; color: #0284c7;">
                                <a href="tel:<%= delPhone %>" style="color: #0284c7; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 0.35rem;">
                                    <i class="fa-solid fa-phone"></i> <%= delPhone %>
                                </a>
                            </div>
                        <% } else { %>
                            <div style="font-size: 0.8rem; color: var(--slate-400);">Contact will appear upon pickup</div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
<%
        }

        if (!hasOrders) {
%>
        <div style="grid-column: 1 / -1; padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200);">
            <div style="width: 72px; height: 72px; border-radius: 50%; background: #f1f5f9; color: #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 2rem; margin: 0 auto 1.25rem;">
                <i class="fa-solid fa-box-open"></i>
            </div>
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Orders Placed Yet</h3>
            <p style="color: var(--slate-500); font-size: 0.9rem; margin-top: 0.25rem;">Your agricultural order purchase history will appear here.</p>
            <a href="viewProducts.jsp" class="kc-btn kc-btn-primary" style="margin-top: 1.25rem;">
                Explore Marketplace
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