<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>
<%@ page import="com.Krushiconnect.dao.LabourDAO" %>

<%
    User user = (User) session.getAttribute("user");

    if(user == null || !user.getRole().equalsIgnoreCase("LABOUR")){
        response.sendRedirect("login.jsp");
        return;
    }

    int userId = user.getUserId();

    LabourDAO dao = new LabourDAO();
    double earnings = dao.getLabourEarnings(userId);

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
            response.sendRedirect("labourDashboard.jsp");
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
    <title>Labour Dashboard | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .labour-hero {
            background: linear-gradient(135deg, #3730a3 0%, #4338ca 60%, #312e81 100%);
            border-radius: var(--radius-xl);
            padding: 2.25rem 2.5rem;
            color: #ffffff;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 15px 30px -10px rgba(67, 56, 202, 0.4);
            position: relative;
            overflow: hidden;
        }

        .labour-hero::after {
            content: '🚜';
            position: absolute;
            right: 2rem;
            bottom: -1rem;
            font-size: 8rem;
            opacity: 0.12;
            pointer-events: none;
        }

        .earnings-box {
            background: linear-gradient(135deg, #ffffff 0%, #f5f3ff 100%);
            border: 1.5px solid #ddd6fe;
            border-radius: var(--radius-lg);
            padding: 1.75rem;
            box-shadow: var(--shadow-sm);
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .earnings-val {
            font-size: 2.5rem;
            font-weight: 800;
            color: #4338ca;
            font-family: var(--font-heading);
            letter-spacing: -0.02em;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-labour">
    <div class="kc-brand">
        <div class="kc-brand-icon">🚜</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Labour Provider</span></span>
    </div>

    <div class="kc-nav-user">
        <div class="kc-user-pill">
            <div class="kc-avatar">👷</div>
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
                    <span><i class="fa-solid fa-bell" style="color: #4338ca; margin-right: 6px;"></i> Notifications</span>
                    <a href="labourDashboard.jsp?markRead=true" style="font-size: 0.8rem; color: #4338ca; text-decoration: none; font-weight: 600;">
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
                                <span style="width: 8px; height: 8px; border-radius: 50%; background: <%= n.isRead ? "#cbd5e1" : "#4338ca" %>; flex-shrink: 0; margin-top: 5px;"></span>
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
    <div class="labour-hero">
        <div>
            <span style="background: rgba(255,255,255,0.2); padding: 0.35rem 0.85rem; border-radius: 9999px; font-size: 0.8rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em; display: inline-block; margin-bottom: 0.75rem;">
                👷 Certified Service Crew Leader
            </span>
            <h1 style="font-size: 2rem; font-weight: 800; margin-bottom: 0.5rem; color: #ffffff;">Welcome, <%= user.getName() %></h1>
            <p style="font-size: 0.95rem; color: #e0e7ff; max-width: 600px; line-height: 1.6;">
                Manage agricultural service listings, review farmer booking requests, confirm daily work assignments, and track direct bank payouts.
            </p>
        </div>
    </div>

    <!-- 💰 EARNINGS (UNCHANGED LOGIC) -->
    <div class="earnings-box">
        <div style="display: flex; align-items: center; gap: 1.5rem;">
            <div style="width: 68px; height: 68px; border-radius: 18px; background: #ede9fe; color: #4338ca; display: flex; align-items: center; justify-content: center; font-size: 2rem;">
                <i class="fa-solid fa-coins"></i>
            </div>
            <div>
                <div style="font-size: 0.85rem; color: #64748b; font-weight: 700; text-transform: uppercase; letter-spacing: 0.05em;">
                    Total Released Labour Earnings
                </div>
                <div class="earnings-val">
                    ₹ <%= earnings %>
                </div>
                <div style="font-size: 0.8rem; color: #16a34a; font-weight: 600;">
                    <i class="fa-solid fa-circle-check"></i> Net earnings released for completed & approved work
                </div>
            </div>
        </div>
    </div>

    <!-- 🚀 ACTIONS (UNCHANGED LOGIC) -->
    <div class="kc-card">
        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.5rem;">
            <i class="fa-solid fa-screwdriver-wrench" style="color: #4338ca;"></i> Labour & Service Controls
        </h3>

        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1.25rem;">

            <!-- ADD SERVICE -->
            <a href="addService.jsp" style="text-decoration: none;">
                <div class="kc-card kc-card-clickable" style="border-color: #ddd6fe; background: #faf5ff; display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: #6366f1; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                        <i class="fa-solid fa-circle-plus"></i>
                    </div>
                    <div>
                        <div style="font-weight: 700; color: #4338ca; font-size: 1.05rem;">Add New Service</div>
                        <div style="font-size: 0.8rem; color: #64748b;">Post harvesting, tilling or tractor service</div>
                    </div>
                </div>
            </a>

            <!-- MY SERVICES -->
            <a href="viewLabourServices.jsp" style="text-decoration: none;">
                <div class="kc-card kc-card-clickable" style="border-color: #bbf7d0; background: #f0fdf4; display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: #16a34a; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                        <i class="fa-solid fa-list-check"></i>
                    </div>
                    <div>
                        <div style="font-weight: 700; color: #15803d; font-size: 1.05rem;">My Active Services</div>
                        <div style="font-size: 0.8rem; color: #64748b;">View and update daily rates & service info</div>
                    </div>
                </div>
            </a>

            <!-- VIEW BOOKING REQUESTS -->
            <a href="viewBookings.jsp" style="text-decoration: none;">
                <div class="kc-card kc-card-clickable" style="border-color: #fde68a; background: #fffbeb; display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: #d97706; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                        <i class="fa-solid fa-calendar-check"></i>
                    </div>
                    <div>
                        <div style="font-weight: 700; color: #b45309; font-size: 1.05rem;">Booking Requests</div>
                        <div style="font-size: 0.8rem; color: #64748b;">Accept or reject farmer job requests</div>
                    </div>
                </div>
            </a>

            <!-- LOGOUT -->
            <a href="logout" class="logout" style="text-decoration: none;">
                <div class="kc-card kc-card-clickable" style="border-color: #fecaca; background: #fef2f2; display: flex; align-items: center; gap: 1rem; padding: 1.25rem;">
                    <div style="width: 48px; height: 48px; border-radius: 12px; background: #dc2626; color: white; display: flex; align-items: center; justify-content: center; font-size: 1.25rem;">
                        <i class="fa-solid fa-power-off"></i>
                    </div>
                    <div>
                        <div style="font-weight: 700; color: #b91c1c; font-size: 1.05rem;">Logout</div>
                        <div style="font-size: 0.8rem; color: #64748b;">Safely exit provider portal</div>
                    </div>
                </div>
            </a>

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