<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.Krushiconnect.model.User" %>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !user.getRole().equalsIgnoreCase("ADMIN")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Console | KrushiConnect Management</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .admin-hero {
            background: linear-gradient(135deg, #0f172a 0%, #1e1b4b 50%, #1e293b 100%);
            border-radius: var(--radius-xl);
            padding: 2.25rem 2.5rem;
            color: #ffffff;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 15px 30px -10px rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255, 255, 255, 0.1);
            position: relative;
            overflow: hidden;
        }

        .admin-hero::after {
            content: '👑';
            position: absolute;
            right: 2rem;
            bottom: -1rem;
            font-size: 8rem;
            opacity: 0.12;
            pointer-events: none;
        }

        .admin-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 1.5rem;
        }

        .admin-tile {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            padding: 2rem 1.75rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 1.25rem;
            transition: all var(--transition-normal);
            box-shadow: var(--shadow-sm);
        }

        .admin-tile:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
        }

        .admin-tile-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin-bottom: 0.5rem;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-admin">
    <div class="kc-brand">
        <div class="kc-brand-icon">👑</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.85;">| Super Admin</span></span>
    </div>

    <div class="kc-nav-user">
        <div class="kc-user-pill">
            <div class="kc-avatar" style="background: rgba(234, 179, 8, 0.25); color: #facc15;">👑</div>
            <span><%= user.getName() %></span>
        </div>

        <a href="logout" class="kc-btn kc-btn-danger kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-power-off"></i> Logout
        </a>
    </div>
</nav>

<!-- 🔥 MAIN CONTAINER -->
<div class="kc-container">

    <!-- ADMIN HERO BANNER -->
    <div class="admin-hero">
        <div>
            <span style="background: rgba(234, 179, 8, 0.2); border: 1px solid rgba(234, 179, 8, 0.35); color: #facc15; padding: 0.35rem 0.85rem; border-radius: 9999px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: inline-block; margin-bottom: 0.75rem;">
                🛡️ Platform Governance
            </span>
            <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 0.5rem; color: #ffffff;">Executive Master Dashboard</h1>
            <p style="font-size: 0.95rem; color: #cbd5e1; max-width: 620px; line-height: 1.6;">
                Central operations hub to audit user registries, moderate catalog listings, oversee vendor commission settlement, and inspect system volume.
            </p>
        </div>
    </div>

    <!-- ADMIN CONTROLS GRID (UNCHANGED LOGIC) -->
    <div class="kc-card">
        <h2 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 0.25rem;">
            <i class="fa-solid fa-sliders" style="color: #6366f1; margin-right: 8px;"></i> Management Modules
        </h2>
        <p style="color: var(--slate-500); font-size: 0.9rem; margin-bottom: 1.75rem;">Select an administrative control domain below.</p>

        <div class="admin-grid">

            <!-- 1. MANAGE USERS -->
            <div class="admin-tile" style="border-top: 4px solid #0284c7;">
                <div>
                    <div class="admin-tile-icon" style="background: #e0f2fe; color: #0284c7;">
                        <i class="fa-solid fa-users-gear"></i>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-900); margin-bottom: 0.35rem;">Manage Users</h3>
                    <p style="color: var(--slate-500); font-size: 0.875rem; line-height: 1.5;">
                        View all farmers, vendors, labour crew and delivery partners. Enable or disable user accounts.
                    </p>
                </div>
                <a href="viewUsers.jsp" style="text-decoration: none;">
                    <button class="kc-btn kc-btn-secondary kc-btn-block">
                        <i class="fa-solid fa-arrow-up-right-from-square"></i> Open User Directory
                    </button>
                </a>
            </div>

            <!-- 2. MANAGE PRODUCTS -->
            <div class="admin-tile" style="border-top: 4px solid #16a34a;">
                <div>
                    <div class="admin-tile-icon" style="background: #dcfce7; color: #16a34a;">
                        <i class="fa-solid fa-boxes-stacked"></i>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-900); margin-bottom: 0.35rem;">Manage Products</h3>
                    <p style="color: var(--slate-500); font-size: 0.875rem; line-height: 1.5;">
                        Audit vendor catalog items, moderate agricultural input listings, and toggle active/inactive status.
                    </p>
                </div>
                <a href="adminProducts.jsp" style="text-decoration: none;">
                    <button class="kc-btn kc-btn-primary kc-btn-block">
                        <i class="fa-solid fa-arrow-up-right-from-square"></i> Open Catalog Moderation
                    </button>
                </a>
            </div>

            <!-- 3. ANALYTICS -->
            <div class="admin-tile" style="border-top: 4px solid #f59e0b;">
                <div>
                    <div class="admin-tile-icon" style="background: #fef3c7; color: #d97706;">
                        <i class="fa-solid fa-chart-line"></i>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-900); margin-bottom: 0.35rem;">Financial Analytics</h3>
                    <p style="color: var(--slate-500); font-size: 0.875rem; line-height: 1.5;">
                        Track total marketplace transactions, 10% platform commission revenue, vendor totals, and labour settlements.
                    </p>
                </div>
                <a href="adminAnalytics.jsp" style="text-decoration: none;">
                    <button class="kc-btn kc-btn-amber kc-btn-block">
                        <i class="fa-solid fa-chart-pie"></i> View Platform Analytics
                    </button>
                </a>
            </div>

            <!-- 4. LOGOUT -->
            <div class="admin-tile" style="border-top: 4px solid #ef4444;">
                <div>
                    <div class="admin-tile-icon" style="background: #fee2e2; color: #dc2626;">
                        <i class="fa-solid fa-lock"></i>
                    </div>
                    <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-900); margin-bottom: 0.35rem;">Sign Out</h3>
                    <p style="color: var(--slate-500); font-size: 0.875rem; line-height: 1.5;">
                        Terminate super administrative session and revoke access on this workstation securely.
                    </p>
                </div>
                <a href="logout" style="text-decoration: none;">
                    <button class="kc-btn kc-btn-danger kc-btn-block">
                        <i class="fa-solid fa-power-off"></i> Secure Logout
                    </button>
                </a>
            </div>

        </div>
    </div>

</div>

</body>
</html>