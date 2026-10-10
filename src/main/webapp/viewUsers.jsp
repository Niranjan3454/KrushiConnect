<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    String roleFilter = request.getParameter("role");
    String statusFilter = request.getParameter("status");
    String search = request.getParameter("search");

    if(roleFilter == null) roleFilter = "ALL";
    if(statusFilter == null) statusFilter = "ALL";
    if(search == null) search = "";

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    boolean found = false;

    try {
        conn = DBConnection.getConnection();

        String sql = "SELECT * FROM users WHERE 1=1";

        if(!roleFilter.equalsIgnoreCase("ALL")){
            sql += " AND role=?";
        }

        if(!statusFilter.equalsIgnoreCase("ALL")){
            sql += " AND status=?";
        }

        if(search != null && !search.trim().equals("")){
            sql += " AND (name LIKE ? OR email LIKE ?)";
        }

        sql += " ORDER BY user_id DESC";

        ps = conn.prepareStatement(sql);

        int i = 1;

        if(!roleFilter.equalsIgnoreCase("ALL")){
            ps.setString(i++, roleFilter);
        }

        if(!statusFilter.equalsIgnoreCase("ALL")){
            ps.setString(i++, statusFilter);
        }

        if(search != null && !search.trim().equals("")){
            ps.setString(i++, "%" + search + "%");
            ps.setString(i++, "%" + search + "%");
        }

        rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | KrushiConnect Super Admin</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .filter-panel {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.75rem;
            box-shadow: var(--shadow-sm);
        }

        .filter-form-row {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-box {
            flex: 1;
            min-width: 240px;
            position: relative;
        }

        .search-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        .search-box input {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.75rem;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--slate-200);
            font-family: var(--font-body);
            font-size: 0.95rem;
            outline: none;
        }

        .search-box input:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.2);
        }

        .role-pill-farmer   { background: #dcfce7; color: #15803d; }
        .role-pill-vendor   { background: #e0f2fe; color: #0369a1; }
        .role-pill-labour   { background: #ede9fe; color: #4338ca; }
        .role-pill-delivery { background: #fef3c7; color: #b45309; }
        .role-pill-admin    { background: #f1f5f9; color: #0f172a; font-weight: 800; }

        .btn-action-disable {
            padding: 0.4rem 0.85rem;
            border-radius: var(--radius-sm);
            background: #fee2e2;
            color: #dc2626;
            border: 1px solid #fca5a5;
            font-size: 0.825rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all var(--transition-fast);
        }
        .btn-action-disable:hover {
            background: #dc2626;
            color: #ffffff;
        }

        .btn-action-enable {
            padding: 0.4rem 0.85rem;
            border-radius: var(--radius-sm);
            background: #dcfce7;
            color: #15803d;
            border: 1px solid #86efac;
            font-size: 0.825rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all var(--transition-fast);
        }
        .btn-action-enable:hover {
            background: #15803d;
            color: #ffffff;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-admin">
    <div class="kc-brand">
        <div class="kc-brand-icon">👥</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.85;">| User Governance</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="adminAnalytics.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-chart-line"></i> Analytics
        </a>
        <a href="adminProducts.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-boxes-stacked"></i> Products
        </a>
        <a href="adminDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="margin-bottom: 1.75rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-users" style="color: #6366f1; margin-right: 8px;"></i> Registered Users Directory
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Audit all platform accounts across Farmers, Vendors, Labour, and Delivery personnel.</p>
    </div>

    <!-- FILTER TOOLBAR (UNCHANGED LOGIC & ACTION) -->
    <div class="filter-panel">
        <form method="get" action="viewUsers.jsp" class="filter-form-row">

            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text"
                       name="search"
                       placeholder="Search by user name or email..."
                       value="<%= search %>">
            </div>

            <select name="role" class="kc-select" style="width: auto; min-width: 160px;">
                <option value="ALL">All Roles</option>
                <option value="FARMER" <%= roleFilter.equalsIgnoreCase("FARMER") ? "selected" : "" %>>🌾 Farmer</option>
                <option value="VENDOR" <%= roleFilter.equalsIgnoreCase("VENDOR") ? "selected" : "" %>>🏪 Vendor</option>
                <option value="LABOUR" <%= roleFilter.equalsIgnoreCase("LABOUR") ? "selected" : "" %>>🚜 Labour</option>
                <option value="DELIVERY" <%= roleFilter.equalsIgnoreCase("DELIVERY") ? "selected" : "" %>>🚚 Delivery</option>
                <option value="ADMIN" <%= roleFilter.equalsIgnoreCase("ADMIN") ? "selected" : "" %>>👑 Admin</option>
            </select>

            <select name="status" class="kc-select" style="width: auto; min-width: 150px;">
                <option value="ALL">All Status</option>
                <option value="ACTIVE" <%= statusFilter.equalsIgnoreCase("ACTIVE") ? "selected" : "" %>>Active</option>
                <option value="INACTIVE" <%= statusFilter.equalsIgnoreCase("INACTIVE") ? "selected" : "" %>>Inactive</option>
            </select>

            <button type="submit" class="kc-btn kc-btn-secondary" style="padding: 0.75rem 1.5rem;">
                <i class="fa-solid fa-filter"></i> Filter
            </button>

            <% if(!roleFilter.equalsIgnoreCase("ALL") || !statusFilter.equalsIgnoreCase("ALL") || !search.isEmpty()) { %>
                <a href="viewUsers.jsp" class="kc-btn kc-btn-outline" style="padding: 0.75rem 1rem;">Reset</a>
            <% } %>

        </form>
    </div>

    <!-- USERS DIRECTORY TABLE -->
    <div class="kc-table-wrapper">
        <table class="kc-table">
            <thead>
                <tr>
                    <th style="width: 80px;">User ID</th>
                    <th>Full Name</th>
                    <th>Email Address</th>
                    <th>System Role</th>
                    <th>Account Status</th>
                    <th style="text-align: right;">Access Moderation</th>
                </tr>
            </thead>
            <tbody>
<%
        while(rs.next()){
            found = true;
            int userId = rs.getInt("user_id");
            String name = rs.getString("name");
            String email = rs.getString("email");
            String role = rs.getString("role");
            String status = rs.getString("status");
            if(status == null) status = "ACTIVE";
%>
                <tr>
                    <td style="font-weight: 700; color: var(--slate-500);">#<%= userId %></td>
                    <td style="font-weight: 700; color: var(--slate-900);"><%= name %></td>
                    <td style="color: var(--slate-600);"><%= email %></td>
                    <td>
                        <%
                            String roleClass = "role-pill-farmer";
                            if("VENDOR".equalsIgnoreCase(role)) roleClass = "role-pill-vendor";
                            else if("LABOUR".equalsIgnoreCase(role)) roleClass = "role-pill-labour";
                            else if("DELIVERY".equalsIgnoreCase(role)) roleClass = "role-pill-delivery";
                            else if("ADMIN".equalsIgnoreCase(role)) roleClass = "role-pill-admin";
                        %>
                        <span class="kc-badge <%= roleClass %>"><%= role %></span>
                    </td>
                    <td>
                        <% if(status.equalsIgnoreCase("ACTIVE")){ %>
                            <span class="kc-badge badge-active">
                                <span class="kc-badge-dot"></span> ACTIVE
                            </span>
                        <% } else { %>
                            <span class="kc-badge badge-inactive">
                                <span class="kc-badge-dot"></span> INACTIVE
                            </span>
                        <% } %>
                    </td>
                    <td style="text-align: right;">
                        <!-- ORIGINAL ACTION LINKS (UNCHANGED LOGIC & ONCLICK CONFIRM) -->
                        <% if(status.equalsIgnoreCase("ACTIVE")){ %>
                            <a class="btn-action-disable"
                               href="disableUser?userId=<%= userId %>"
                               onclick="return confirm('Disable this user?')">
                               <i class="fa-solid fa-user-slash"></i> Disable
                            </a>
                        <% } else { %>
                            <a class="btn-action-enable"
                               href="enableUser?userId=<%= userId %>"
                               onclick="return confirm('Enable this user?')">
                               <i class="fa-solid fa-user-check"></i> Enable
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
        if(!found){
%>
    <div style="padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200); margin-top: 1.5rem;">
        <i class="fa-solid fa-user-xmark" style="font-size: 3rem; color: #cbd5e1; margin-bottom: 1rem; display: block;"></i>
        <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Users Found</h3>
        <p style="color: var(--slate-500); font-size: 0.9rem;">No accounts match the current search or filter query.</p>
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