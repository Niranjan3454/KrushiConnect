<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null || !user.getRole().equalsIgnoreCase("DELIVERY"))  {
        response.sendRedirect("login.jsp");
        return;
    }

    int deliveryId = user.getUserId();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    PreparedStatement notifPs = null;
    ResultSet notifRs = null;
    PreparedStatement earnPs = null;
    ResultSet earnRs = null;

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
    int totalDeliveries = 0;
    int completed = 0;
    double totalEarnings = 0;

    try {
        conn = DBConnection.getConnection();

        // 🔥 MARK ALL AS READ (UNCHANGED LOGIC)
        if("true".equals(request.getParameter("markRead"))){
            String updateSql = "UPDATE notifications SET is_read=1 WHERE user_id=?";
            PreparedStatement updatePs = conn.prepareStatement(updateSql);
            updatePs.setInt(1, deliveryId);
            updatePs.executeUpdate();
            updatePs.close();
            response.sendRedirect("deliveryDashboard.jsp");
            return;
        }

        // 🔥 NOTIFICATIONS
        String notifSql = "SELECT * FROM notifications WHERE user_id=? ORDER BY created_at DESC LIMIT 5";
        notifPs = conn.prepareStatement(notifSql);
        notifPs.setInt(1, deliveryId);
        notifRs = notifPs.executeQuery();

        while(notifRs.next()){
            String message = notifRs.getString("message");
            Timestamp timestamp = notifRs.getTimestamp("created_at");
            boolean isRead = notifRs.getBoolean("is_read");

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

        // DELIVERIES
        String sql = "SELECT * FROM deliveries WHERE delivery_person_id=?";
        ps = conn.prepareStatement(
                sql,
                ResultSet.TYPE_SCROLL_INSENSITIVE,
                ResultSet.CONCUR_READ_ONLY
        );
        ps.setInt(1, deliveryId);
        rs = ps.executeQuery();

        // EARNINGS
        String earnSql = "SELECT SUM(amount) FROM delivery_payments WHERE delivery_person_id=? AND payment_status='PAID'";
        earnPs = conn.prepareStatement(earnSql);
        earnPs.setInt(1, deliveryId);
        earnRs = earnPs.executeQuery();
        if (earnRs.next()) {
            totalEarnings = earnRs.getDouble(1);
        }

    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delivery Dashboard | KrushiConnect Logistics</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .delivery-hero {
            background: linear-gradient(135deg, #b45309 0%, #d97706 60%, #92400e 100%);
            border-radius: var(--radius-xl);
            padding: 2.25rem 2.5rem;
            color: #ffffff;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 15px 30px -10px rgba(217, 119, 6, 0.4);
            position: relative;
            overflow: hidden;
        }

        .delivery-hero::after {
            content: '🚚';
            position: absolute;
            right: 2rem;
            bottom: -1rem;
            font-size: 8rem;
            opacity: 0.12;
            pointer-events: none;
        }

        .tabs-header {
            display: flex;
            gap: 0.75rem;
            border-bottom: 2px solid var(--slate-100);
            padding-bottom: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .tab-btn {
            background: transparent;
            border: none;
            padding: 0.65rem 1.35rem;
            border-radius: var(--radius-full);
            font-family: var(--font-heading);
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--slate-500);
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            transition: all var(--transition-fast);
        }

        .tab-btn.active {
            background: #d97706;
            color: #ffffff;
            box-shadow: 0 4px 12px rgba(217, 119, 6, 0.35);
        }

        .delivery-card-item {
            background: #ffffff;
            border: 1px solid var(--slate-200);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1.25rem;
            box-shadow: var(--shadow-sm);
            transition: all var(--transition-fast);
        }

        .delivery-card-item:hover {
            border-color: #f59e0b;
            transform: translateY(-2px);
            box-shadow: var(--shadow-md);
        }

        .status-update-form {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .status-select {
            padding: 0.6rem 1rem;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--slate-300);
            font-family: var(--font-body);
            font-size: 0.9rem;
            font-weight: 600;
            background: var(--white);
            color: var(--slate-800);
            outline: none;
            cursor: pointer;
        }

        .status-select:focus {
            border-color: #d97706;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-delivery">
    <div class="kc-brand">
        <div class="kc-brand-icon">🚚</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Logistics Partner</span></span>
    </div>

    <div class="kc-nav-user">
        <div class="kc-user-pill">
            <div class="kc-avatar">🚚</div>
            <span><%= user.getName() %></span>
        </div>

        <!-- 🔔 NOTIFICATION WRAPPER -->
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
                    <span><i class="fa-solid fa-bell" style="color: #d97706; margin-right: 6px;"></i> Notifications</span>
                    <a href="deliveryDashboard.jsp?markRead=true" style="font-size: 0.8rem; color: #d97706; text-decoration: none; font-weight: 600;">
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
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: <%= n.isRead ? "#cbd5e1" : "#d97706" %>; flex-shrink: 0; margin-top: 5px;"></span>
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

    <!-- HERO BANNER -->
    <div class="delivery-hero">
        <div>
            <span style="background: rgba(255,255,255,0.2); padding: 0.35rem 0.85rem; border-radius: 9999px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: inline-block; margin-bottom: 0.75rem;">
                🚚 Doorstep Dispatch Crew
            </span>
            <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 0.5rem; color: #ffffff;">Delivery Console: <%= user.getName() %></h1>
            <p style="font-size: 0.95rem; color: #fef3c7; max-width: 600px; line-height: 1.6;">
                Dispatch and deliver farm input orders directly to rural farmers. Update fulfillment status and earn ₹50 payout per successful delivery.
            </p>
        </div>
    </div>

    <!-- MAIN CARD WITH TABS -->
    <div class="kc-card" style="margin-bottom: 2rem;">

        <!-- TABS HEADER -->
        <div class="tabs-header">
            <button class="tab-btn active" onclick="showTab('activeTab', this)">
                <i class="fa-solid fa-route"></i> Active Deliveries
            </button>
            <button class="tab-btn" onclick="showTab('historyTab', this)">
                <i class="fa-solid fa-clock-rotate-left"></i> Delivery History
            </button>
        </div>

        <!-- 📦 ACTIVE DELIVERIES TAB -->
        <div id="activeTab">
            <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-solid fa-boxes-packing" style="color: #d97706;"></i> Orders in Delivery Pipeline
            </h3>

            <%
                int activeCount = 0;
                if (rs != null) {
                    rs.beforeFirst();
                    while (rs.next()) {
                        String status = rs.getString("status");
                        if (!status.equalsIgnoreCase("DELIVERED")) {
                            totalDeliveries++;
                            activeCount++;
            %>
                <div class="delivery-card-item">
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 700; color: var(--slate-900); display: flex; align-items: center; gap: 0.65rem;">
                            <span>📦 Order #<%= rs.getInt("order_id") %></span>
                            <%
                                String badgeStyle = "badge-pending";
                                if("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) badgeStyle = "badge-out_for_delivery";
                                else if("PICKED".equalsIgnoreCase(status)) badgeStyle = "badge-delivery";
                            %>
                            <span class="kc-badge <%= badgeStyle %>">
                                <span class="kc-badge-dot"></span> <%= status.replace('_', ' ') %>
                            </span>
                        </div>
                        <div style="font-size: 0.85rem; color: #64748b; margin-top: 0.35rem;">
                            Delivery Tracking ID: <strong>#DLV-<%= rs.getInt("delivery_id") %></strong>
                        </div>
                    </div>

                    <!-- ORIGINAL UPDATE FORM (UNCHANGED LOGIC) -->
                    <form action="updateDeliveryStatus" method="post" class="status-update-form">
                        <input type="hidden" name="deliveryId" value="<%= rs.getInt("delivery_id") %>">

                        <select name="status" class="status-select">
                            <option value="ASSIGNED" <%= "ASSIGNED".equalsIgnoreCase(status) ? "selected" : "" %>>ASSIGNED</option>
                            <option value="PICKED" <%= "PICKED".equalsIgnoreCase(status) ? "selected" : "" %>>PICKED</option>
                            <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equalsIgnoreCase(status) ? "selected" : "" %>>OUT_FOR_DELIVERY</option>
                            <option value="DELIVERED" <%= "DELIVERED".equalsIgnoreCase(status) ? "selected" : "" %>>DELIVERED</option>
                        </select>

                        <button type="submit" class="kc-btn kc-btn-amber kc-btn-sm" style="padding: 0.65rem 1.25rem;">
                            <i class="fa-solid fa-arrows-rotate"></i> Update
                        </button>
                    </form>
                </div>
            <%
                        }
                    }
                }
                if (activeCount == 0) {
            %>
                <div style="padding: 3rem 1.5rem; text-align: center; color: #94a3b8;">
                    <i class="fa-solid fa-circle-check" style="font-size: 3rem; color: #10b981; margin-bottom: 1rem; display: block;"></i>
                    <div style="font-weight: 700; font-size: 1.15rem; color: var(--slate-800);">All Deliveries Completed!</div>
                    <p style="font-size: 0.9rem; margin-top: 0.35rem;">You currently have no pending orders assigned.</p>
                </div>
            <% } %>
        </div>

        <!-- 📜 DELIVERY HISTORY TAB -->
        <div id="historyTab" style="display:none;">
            <h3 style="font-size: 1.2rem; font-weight: 700; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.5rem;">
                <i class="fa-solid fa-circle-check" style="color: #10b981;"></i> Successfully Delivered Orders
            </h3>

            <%
                int historyCount = 0;
                if (rs != null) {
                    rs.beforeFirst();
                    while (rs.next()) {
                        String status = rs.getString("status");
                        if (status.equalsIgnoreCase("DELIVERED")) {
                            completed++;
                            historyCount++;
            %>
                <div class="delivery-card-item" style="border-left: 4px solid #10b981;">
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 700; color: var(--slate-900);">
                            📦 Order #<%= rs.getInt("order_id") %>
                        </div>
                        <div style="font-size: 0.85rem; color: #64748b; margin-top: 0.25rem;">
                            Delivery ID: #DLV-<%= rs.getInt("delivery_id") %> &bull; Status: Delivered to Farmer
                        </div>
                    </div>

                    <div style="display: flex; align-items: center; gap: 1rem;">
                        <span class="kc-badge badge-delivered">
                            <span class="kc-badge-dot"></span> DELIVERED
                        </span>
                        <span style="font-weight: 700; color: #15803d; font-size: 0.95rem;">
                            + ₹50 Earned
                        </span>
                    </div>
                </div>
            <%
                        }
                    }
                }
                if (historyCount == 0) {
            %>
                <div style="padding: 3rem 1.5rem; text-align: center; color: #94a3b8;">
                    <i class="fa-solid fa-box-open" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.4; display: block;"></i>
                    <div style="font-weight: 600; font-size: 1.1rem; color: var(--slate-700);">No Completed Deliveries Yet</div>
                </div>
            <% } %>
        </div>

    </div>

    <!-- 📊 PERFORMANCE & EARNINGS METRICS -->
    <div class="kc-card" style="margin-bottom: 2rem;">
        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.5rem;">
            <i class="fa-solid fa-chart-pie" style="color: #0284c7;"></i> Performance & Payout Metrics
        </h3>

        <div class="kc-stats-grid" style="margin-bottom: 1.5rem;">
            <div class="kc-stat-card">
                <div class="kc-stat-icon blue"><i class="fa-solid fa-boxes-stacked"></i></div>
                <div>
                    <div class="kc-stat-value"><%= totalDeliveries + completed %></div>
                    <div class="kc-stat-label">Total Assigned</div>
                </div>
            </div>

            <div class="kc-stat-card green">
                <div class="kc-stat-icon green"><i class="fa-solid fa-circle-check"></i></div>
                <div>
                    <div class="kc-stat-value"><%= completed %></div>
                    <div class="kc-stat-label">Delivered</div>
                </div>
            </div>

            <div class="kc-stat-card amber">
                <div class="kc-stat-icon amber"><i class="fa-solid fa-hourglass-half"></i></div>
                <div>
                    <div class="kc-stat-value"><%= totalDeliveries %></div>
                    <div class="kc-stat-label">Pending / In-Transit</div>
                </div>
            </div>

            <div class="kc-stat-card purple">
                <div class="kc-stat-icon purple"><i class="fa-solid fa-wallet"></i></div>
                <div>
                    <div class="kc-stat-value">₹ <%= totalEarnings %></div>
                    <div class="kc-stat-label">Total Paid Earnings</div>
                </div>
            </div>
        </div>
    </div>

    <!-- LOGOUT BUTTON (UNCHANGED LOGIC) -->
    <div style="text-align: right;">
        <a href="logout" class="kc-btn kc-btn-danger">
            <i class="fa-solid fa-power-off"></i> Logout
        </a>
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

    window.onclick = function(event){
        let panel = document.getElementById("notificationPanel");
        let bell = document.querySelector(".kc-bell-btn");
        if(panel && bell && !panel.contains(event.target) && !bell.contains(event.target)){
            panel.style.display = "none";
        }
    }

    function showTab(tabId, element){
        document.getElementById("activeTab").style.display = "none";
        document.getElementById("historyTab").style.display = "none";
        document.getElementById(tabId).style.display = "block";

        let buttons = document.querySelectorAll(".tab-btn");
        buttons.forEach(btn => btn.classList.remove("active"));
        element.classList.add("active");
    }
</script>

</body>
</html>
<%
    // Safe resource cleanup
    try { if (rs != null) rs.close(); } catch(Exception e) {}
    try { if (ps != null) ps.close(); } catch(Exception e) {}
    try { if (notifRs != null) notifRs.close(); } catch(Exception e) {}
    try { if (notifPs != null) notifPs.close(); } catch(Exception e) {}
    try { if (earnRs != null) earnRs.close(); } catch(Exception e) {}
    try { if (earnPs != null) earnPs.close(); } catch(Exception e) {}
    try { if (conn != null) conn.close(); } catch(Exception e) {}
%>