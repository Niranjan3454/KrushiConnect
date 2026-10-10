<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if(user == null || !user.getRole().equalsIgnoreCase("FARMER")){
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = user.getUserId();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    class NotificationData{
        String message;
        String time;
        boolean isRead;

        NotificationData(String message, String time, boolean isRead){
            this.message = message;
            this.time = time;
            this.isRead = isRead;
        }
    }

    ArrayList<NotificationData> notifications = new ArrayList<>();
    int unreadCount = 0;

    try {
        conn = DBConnection.getConnection();

        // 🔥 MARK ALL AS READ (UNCHANGED LOGIC)
        if("true".equals(request.getParameter("markRead"))){
            String updateSql = "UPDATE notifications SET is_read=1 WHERE user_id=?";
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, userId);
            updatePs.executeUpdate();
            updatePs.close();
            response.sendRedirect("farmerDashboard.jsp");
            return;
        }

        String sql = "SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 5";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        rs = ps.executeQuery();

        while(rs.next()){
            String message = rs.getString("message");
            Timestamp timestamp = rs.getTimestamp("created_at");
            boolean isRead = rs.getBoolean("is_read");

            if(!isRead){
                unreadCount++;
            }

            String timeAgo = "Just now";
            if(timestamp != null) {
                long diff = System.currentTimeMillis() - timestamp.getTime();
                long minutes = diff / (1000 * 60);
                if(minutes < 1){
                    timeAgo = "Just now";
                } else if(minutes < 60){
                    timeAgo = minutes + " min ago";
                } else if(minutes < 1440){
                    timeAgo = (minutes / 60) + " hr ago";
                } else {
                    timeAgo = (minutes / 1440) + " day ago";
                }
            }

            notifications.add(new NotificationData(message, timeAgo, isRead));
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        try { if(rs != null) rs.close(); } catch(Exception e) {}
        try { if(ps != null) ps.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Dashboard | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .farmer-welcome-banner {
            background: linear-gradient(135deg, #15803d 0%, #166534 50%, #0f381e 100%);
            border-radius: var(--radius-xl);
            padding: 2.25rem 2.5rem;
            color: #ffffff;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 15px 30px -10px rgba(21, 128, 61, 0.4);
            position: relative;
            overflow: hidden;
        }

        .farmer-welcome-banner::after {
            content: '🌾';
            position: absolute;
            right: 2rem;
            bottom: -1rem;
            font-size: 8rem;
            opacity: 0.12;
            pointer-events: none;
        }

        .welcome-title {
            font-size: 2rem;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 0.5rem;
        }

        .welcome-desc {
            font-size: 1rem;
            color: #bbf7d0;
            max-width: 600px;
            line-height: 1.6;
        }

        .action-cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-top: 1.5rem;
        }

        .action-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            padding: 1.75rem;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            gap: 1.25rem;
            transition: all var(--transition-normal);
            box-shadow: var(--shadow-sm);
        }

        .action-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            border-color: #86efac;
        }

        .action-card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .action-icon-box {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            flex-shrink: 0;
        }

        .action-title {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--slate-900);
        }

        .action-subtitle {
            font-size: 0.875rem;
            color: var(--slate-500);
            line-height: 1.5;
        }

        .action-btn {
            width: 100%;
            padding: 0.8rem 1.25rem;
            border-radius: var(--radius-md);
            font-weight: 600;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            cursor: pointer;
            border: none;
            transition: all var(--transition-fast);
        }

        .action-btn-green {
            background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
            color: #ffffff;
        }
        .action-btn-green:hover {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
        }

        .action-btn-blue {
            background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
            color: #ffffff;
        }
        .action-btn-blue:hover {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
        }

        .action-btn-amber {
            background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
            color: #ffffff;
        }
        .action-btn-amber:hover {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
        }

        .action-btn-purple {
            background: linear-gradient(135deg, #7e22ce 0%, #6b21a8 100%);
            color: #ffffff;
        }
        .action-btn-purple:hover {
            background: linear-gradient(135deg, #9333ea 0%, #7e22ce 100%);
        }

        .action-btn-red {
            background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
            color: #ffffff;
        }
        .action-btn-red:hover {
            background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
        }

        @media (max-width: 768px) {
            .farmer-welcome-banner {
                padding: 1.5rem;
                flex-direction: column;
                align-items: flex-start;
            }
            .welcome-title { font-size: 1.5rem; }
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-farmer">
    <div class="kc-brand">
        <div class="kc-brand-icon">🌱</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Farmer Hub</span></span>
    </div>

    <div class="kc-nav-user">
        <div class="kc-user-pill">
            <div class="kc-avatar">🌾</div>
            <span><%= user.getName() %></span>
        </div>

        <!-- 🔔 NOTIFICATION BELL -->
        <div class="kc-notif-wrapper">
            <button class="kc-bell-btn" onclick="toggleNotifications()" title="Notifications">
                <i class="fa-solid fa-bell"></i>
                <% if(unreadCount > 0){ %>
                    <span class="kc-bell-badge"><%= unreadCount %></span>
                <% } %>
            </button>

            <!-- NOTIFICATION PANEL -->
            <div class="kc-notif-panel" id="notificationPanel">
                <div class="kc-notif-header">
                    <span><i class="fa-solid fa-bell" style="color: #16a34a; margin-right: 6px;"></i> Notifications</span>
                    <a href="farmerDashboard.jsp?markRead=true" style="font-size: 0.8rem; color: #16a34a; text-decoration: none; font-weight: 600;">
                        Mark all as read
                    </a>
                </div>

                <div class="kc-notif-list">
                    <% if(notifications.isEmpty()){ %>
                        <div style="padding: 2rem; text-align: center; color: #94a3b8; font-size: 0.875rem;">
                            <i class="fa-regular fa-bell-slash" style="font-size: 1.75rem; margin-bottom: 0.5rem; display: block;"></i>
                            No notifications yet
                        </div>
                    <% } else {
                        for(NotificationData n : notifications){ %>
                        <div class="kc-notif-item <%= n.isRead ? "" : "unread" %>">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 0.5rem;">
                                <div style="font-size: 0.875rem; color: #1e293b; font-weight: <%= n.isRead ? "500" : "700" %>;">
                                    <%= n.message %>
                                </div>
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: <%= n.isRead ? "#cbd5e1" : "#16a34a" %>; flex-shrink: 0; margin-top: 5px;"></span>
                            </div>
                            <span class="kc-notif-time"><i class="fa-regular fa-clock" style="font-size: 0.7rem;"></i> <%= n.time %></span>
                        </div>
                    <% }} %>
                </div>
            </div>
        </div>

        <a href="logout" class="kc-btn kc-btn-danger kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-power-off"></i> Logout
        </a>
    </div>
</nav>

<!-- 🔥 MAIN CONTAINER -->
<div class="kc-container">

    <!-- WELCOME HERO -->
    <div class="farmer-welcome-banner">
        <div>
            <span style="background: rgba(255,255,255,0.2); padding: 0.35rem 0.85rem; border-radius: 9999px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: inline-block; margin-bottom: 0.75rem;">
                🌾 Direct Agri Marketplace
            </span>
            <h1 class="welcome-title">Welcome back, <%= user.getName() %>!</h1>
            <p class="welcome-desc">
                Source certified seeds, fertilizers, and farm equipment directly from authorized vendors, or hire verified skilled labour and machinery on-demand for your agricultural fields.
            </p>
        </div>
    </div>

    <!-- QUICK STATS TILES -->
    <div class="kc-stats-grid">
        <div class="kc-stat-card">
            <div class="kc-stat-icon green"><i class="fa-solid fa-wheat-awn"></i></div>
            <div>
                <div class="kc-stat-value">Seeds & Fertilizers</div>
                <div class="kc-stat-label">Marketplace Inputs</div>
            </div>
        </div>

        <div class="kc-stat-card blue">
            <div class="kc-stat-icon blue"><i class="fa-solid fa-cart-shopping"></i></div>
            <div>
                <div class="kc-stat-value">Cart & Orders</div>
                <div class="kc-stat-label">Order Tracking</div>
            </div>
        </div>

        <div class="kc-stat-card amber">
            <div class="kc-stat-icon amber"><i class="fa-solid fa-person-digging"></i></div>
            <div>
                <div class="kc-stat-value">Labour Services</div>
                <div class="kc-stat-label">On-Demand Crews</div>
            </div>
        </div>

        <div class="kc-stat-card purple">
            <div class="kc-stat-icon purple"><i class="fa-solid fa-truck-fast"></i></div>
            <div>
                <div class="kc-stat-value">Doorstep Delivery</div>
                <div class="kc-stat-label">Rural Logistics</div>
            </div>
        </div>
    </div>

    <!-- DASHBOARD ACTIONS GRID (UNCHANGED LOGIC) -->
    <div class="kc-card" style="margin-top: 1.5rem;">
        <h2 style="font-size: 1.35rem; font-weight: 700; margin-bottom: 0.25rem;">
            <i class="fa-solid fa-compass" style="color: #16a34a; margin-right: 8px;"></i> Farm Operations & Services
        </h2>
        <p style="color: var(--slate-500); font-size: 0.9rem; margin-bottom: 1.5rem;">Access all your agricultural procurement, bookings, and logistical services.</p>

        <div class="action-cards-grid">

            <!-- 1. BUY PRODUCTS -->
            <div class="action-card">
                <div class="action-card-header">
                    <div class="action-icon-box" style="background: #dcfce7; color: #16a34a;">
                        <i class="fa-solid fa-store"></i>
                    </div>
                    <div>
                        <div class="action-title">Agri Marketplace</div>
                        <div class="action-subtitle">Browse certified seeds, fertilizers & crop chemicals</div>
                    </div>
                </div>
                <a href="viewProducts.jsp" style="text-decoration: none;">
                    <button class="action-btn action-btn-green">
                        <i class="fa-solid fa-basket-shopping"></i> View Products
                    </button>
                </a>
            </div>

            <!-- 2. CART -->
            <div class="action-card">
                <div class="action-card-header">
                    <div class="action-icon-box" style="background: #e0f2fe; color: #0284c7;">
                        <i class="fa-solid fa-cart-shopping"></i>
                    </div>
                    <div>
                        <div class="action-title">Shopping Cart</div>
                        <div class="action-subtitle">Review items, quantities, and proceed to checkout</div>
                    </div>
                </div>
                <a href="cart.jsp" style="text-decoration: none;">
                    <button class="action-btn action-btn-blue">
                        <i class="fa-solid fa-receipt"></i> View Cart
                    </button>
                </a>
            </div>

            <!-- 3. MY ORDERS -->
            <div class="action-card">
                <div class="action-card-header">
                    <div class="action-icon-box" style="background: #fef3c7; color: #d97706;">
                        <i class="fa-solid fa-truck-fast"></i>
                    </div>
                    <div>
                        <div class="action-title">My Orders</div>
                        <div class="action-subtitle">Track dispatch status, payment confirmation & deliveries</div>
                    </div>
                </div>
                <a href="myOrders.jsp" style="text-decoration: none;">
                    <button class="action-btn action-btn-amber">
                        <i class="fa-solid fa-box-open"></i> My Orders
                    </button>
                </a>
            </div>

            <!-- 4. LABOUR BOOKINGS -->
            <div class="action-card">
                <div class="action-card-header">
                    <div class="action-icon-box" style="background: #f3e8ff; color: #7e22ce;">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <div>
                        <div class="action-title">My Labour Bookings</div>
                        <div class="action-subtitle">Manage hired harvesting & farm labor appointments</div>
                    </div>
                </div>
                <a href="myBookings.jsp" style="text-decoration: none;">
                    <button class="action-btn action-btn-purple">
                        <i class="fa-solid fa-clock-rotate-left"></i> Labour Bookings
                    </button>
                </a>
            </div>

            <!-- 5. HIRE LABOUR SERVICES -->
            <div class="action-card">
                <div class="action-card-header">
                    <div class="action-icon-box" style="background: #d1fae5; color: #059669;">
                        <i class="fa-solid fa-person-digging"></i>
                    </div>
                    <div>
                        <div class="action-title">Hire Labour / Machinery</div>
                        <div class="action-subtitle">Find available farming crews, tractor & harvester operators</div>
                    </div>
                </div>
                <a href="viewServices.jsp" style="text-decoration: none;">
                    <button class="action-btn action-btn-green">
                        <i class="fa-solid fa-handshake"></i> View Labour Services
                    </button>
                </a>
            </div>

            <!-- 6. AI MANDI RECOMMENDATION -->
            <div class="action-card" style="border: 1.5px solid #fde68a;">
                <div class="action-card-header">
                    <div class="action-icon-box" style="background: #fef9c3; color: #ca8a04;">
                        <i class="fa-solid fa-robot"></i>
                    </div>
                    <div>
                        <div class="action-title">AI Mandi Advisor</div>
                        <div class="action-subtitle">Get AI-powered mandi price prediction &amp; best selling location</div>
                    </div>
                </div>
                <a href="<%= request.getContextPath() %>/mandi-recommendation" style="text-decoration: none;">
                    <button class="action-btn" style="background: linear-gradient(135deg, #ca8a04 0%, #a16207 100%); color: #ffffff;">
                        <i class="fa-solid fa-chart-line"></i> AI Recommendation
                    </button>
                </a>
            </div>

            <!-- 7. LOGOUT -->
            <div class="action-card">
                <div class="action-card-header">
                    <div class="action-icon-box" style="background: #fee2e2; color: #dc2626;">
                        <i class="fa-solid fa-arrow-right-from-bracket"></i>
                    </div>
                    <div>
                        <div class="action-title">Secure Sign Out</div>
                        <div class="action-subtitle">End active session safely from this workstation</div>
                    </div>
                </div>
                <a href="logout" class="logout" style="text-decoration: none;">
                    <button class="action-btn action-btn-red">
                        <i class="fa-solid fa-power-off"></i> Logout
                    </button>
                </a>
            </div>

        </div>
    </div>

</div>

<script>
    function toggleNotifications(){
        let panel = document.getElementById("notificationPanel");
        if(panel.style.display === "block"){
            panel.style.display = "none";
        } else {
            panel.style.display = "block";
        }
    }

    // Close on outside click
    window.onclick = function(event){
        let panel = document.getElementById("notificationPanel");
        let bell = document.querySelector(".kc-bell-btn");
        if(panel && bell && !panel.contains(event.target) && !bell.contains(event.target)){
            panel.style.display = "none";
        }
    }
</script>

</body>
</html>