<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.Krushiconnect.util.DBConnection" %>
<%@ page import="com.Krushiconnect.model.User" %>

<%
    Connection conn = null;
    Statement stmt = null;

    double total = 0;
    double vendor = 0;
    double labour = 0;
    double totalAdmin = 0;
    double vendorTotal = 0;
    double labourTotal = 0;
    double adminVendor = 0;
    double adminLabour = 0;

    try {
        conn = DBConnection.getConnection();
        stmt = conn.createStatement();

        String vTotalSql = "SELECT SUM(amount) FROM vendor_payments WHERE payment_status='PAID'";
        ResultSet vTotalRs = stmt.executeQuery(vTotalSql);
        vendorTotal = vTotalRs.next() ? vTotalRs.getDouble(1) : 0;
        vTotalRs.close();

        String lTotalSql = "SELECT SUM(total_amount) FROM labour_payments WHERE payment_status='PAID'";
        ResultSet lTotalRs = stmt.executeQuery(lTotalSql);
        labourTotal = lTotalRs.next() ? lTotalRs.getDouble(1) : 0;
        lTotalRs.close();

        total = vendorTotal + labourTotal;

        String vendorSql = "SELECT SUM(final_amount) FROM vendor_payments WHERE payment_status='PAID'";
        ResultSet rs2 = stmt.executeQuery(vendorSql);
        if (rs2.next()) vendor = rs2.getDouble(1);
        rs2.close();

        String labourSql = "SELECT SUM(final_amount) FROM labour_payments WHERE payment_status='PAID'";
        ResultSet rs3 = stmt.executeQuery(labourSql);
        if (rs3.next()) labour = rs3.getDouble(1);
        rs3.close();

        String adminVendorSql = "SELECT SUM(commission) FROM vendor_payments WHERE payment_status='PAID'";
        ResultSet rs4 = stmt.executeQuery(adminVendorSql);
        adminVendor = rs4.next() ? rs4.getDouble(1) : 0;
        rs4.close();

        String adminLabourSql = "SELECT SUM(commission) FROM labour_payments WHERE payment_status='PAID'";
        ResultSet rs5 = stmt.executeQuery(adminLabourSql);
        adminLabour = rs5.next() ? rs5.getDouble(1) : 0;
        rs5.close();

        totalAdmin = adminVendor + adminLabour;

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if(stmt != null) stmt.close(); } catch(Exception e) {}
        try { if(conn != null) conn.close(); } catch(Exception e) {}
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Analytics | KrushiConnect Super Admin</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .analytics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .metric-card {
            border-radius: var(--radius-lg);
            padding: 1.75rem;
            color: #ffffff;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
            transition: all var(--transition-normal);
        }

        .metric-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl);
        }

        .metric-total  { background: linear-gradient(135deg, #15803d 0%, #16a34a 100%); }
        .metric-vendor { background: linear-gradient(135deg, #0369a1 0%, #0284c7 100%); }
        .metric-labour { background: linear-gradient(135deg, #4338ca 0%, #6366f1 100%); }
        .metric-admin  { background: linear-gradient(135deg, #7e22ce 0%, #9333ea 100%); }

        .metric-label {
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-weight: 700;
            opacity: 0.9;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .metric-value {
            font-family: var(--font-heading);
            font-size: 2.25rem;
            font-weight: 800;
            line-height: 1.2;
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-admin">
    <div class="kc-brand">
        <div class="kc-brand-icon">📊</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.85;">| Financial Intelligence</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="adminProducts.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-boxes-stacked"></i> Products
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

    <div style="margin-bottom: 2rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-chart-pie" style="color: #6366f1; margin-right: 8px;"></i> Platform Revenue & Settlement Analytics
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Gross marketplace merchandise value, merchant payouts, and 10% platform commission revenue.</p>
    </div>

    <!-- 4 KPI CARDS (UNCHANGED VALUES & CALCULATIONS) -->
    <div class="analytics-grid">

        <!-- 1. TOTAL TURNOVER -->
        <div class="metric-card metric-total">
            <div class="metric-label">
                <i class="fa-solid fa-arrow-trend-up"></i> Total Gross Turnover
            </div>
            <div class="metric-value">₹ <%= total %></div>
            <div style="font-size: 0.8rem; opacity: 0.85; margin-top: 0.5rem;">
                Combined product sales & labour contracts
            </div>
        </div>

        <!-- 2. VENDOR EARNINGS -->
        <div class="metric-card metric-vendor">
            <div class="metric-label">
                <i class="fa-solid fa-shop"></i> Vendor Net Payout
            </div>
            <div class="metric-value">₹ <%= vendor %></div>
            <div style="font-size: 0.8rem; opacity: 0.85; margin-top: 0.5rem;">
                Paid to merchants after 10% fee deduction
            </div>
        </div>

        <!-- 3. LABOUR EARNINGS -->
        <div class="metric-card metric-labour">
            <div class="metric-label">
                <i class="fa-solid fa-person-digging"></i> Labour Net Payout
            </div>
            <div class="metric-value">₹ <%= labour %></div>
            <div style="font-size: 0.8rem; opacity: 0.85; margin-top: 0.5rem;">
                Paid to crew leaders for field services
            </div>
        </div>

        <!-- 4. ADMIN COMMISSION -->
        <div class="metric-card metric-admin">
            <div class="metric-label">
                <i class="fa-solid fa-sack-dollar"></i> Admin Platform Revenue
            </div>
            <div class="metric-value">₹ <%= totalAdmin %></div>
            <div style="font-size: 0.8rem; opacity: 0.85; margin-top: 0.5rem;">
                Net 10% commission retained by platform
            </div>
        </div>

    </div>

    <!-- REVENUE BREAKDOWN AUDIT TABLE -->
    <div class="kc-card">
        <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.5rem;">
            <i class="fa-solid fa-table-list" style="color: #6366f1;"></i> Revenue Streams Breakdown
        </h3>

        <div class="kc-table-wrapper">
            <table class="kc-table">
                <thead>
                    <tr>
                        <th>Revenue Channel</th>
                        <th>Gross Order Volume</th>
                        <th>Partner Net Payout (90%)</th>
                        <th>Platform Fee Retained (10%)</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>
                            <div style="font-weight: 700; color: var(--slate-900);">
                                <i class="fa-solid fa-basket-shopping" style="color: #0284c7; margin-right: 6px;"></i> Agro-Product Sales
                            </div>
                            <div style="font-size: 0.8rem; color: var(--slate-500);">Fertilizers, seeds, crop nutrients</div>
                        </td>
                        <td style="font-weight: 700; color: var(--slate-800);">₹ <%= vendorTotal %></td>
                        <td style="font-weight: 700; color: #0284c7;">₹ <%= vendor %></td>
                        <td style="font-weight: 800; color: #15803d;">₹ <%= adminVendor %></td>
                        <td><span class="kc-badge badge-paid">PAID & SETTLED</span></td>
                    </tr>
                    <tr>
                        <td>
                            <div style="font-weight: 700; color: var(--slate-900);">
                                <i class="fa-solid fa-person-digging" style="color: #4338ca; margin-right: 6px;"></i> Farm Labour Hiring
                            </div>
                            <div style="font-size: 0.8rem; color: var(--slate-500);">Field work, tractor & harvester crews</div>
                        </td>
                        <td style="font-weight: 700; color: var(--slate-800);">₹ <%= labourTotal %></td>
                        <td style="font-weight: 700; color: #4338ca;">₹ <%= labour %></td>
                        <td style="font-weight: 800; color: #15803d;">₹ <%= adminLabour %></td>
                        <td><span class="kc-badge badge-paid">PAID & SETTLED</span></td>
                    </tr>
                    <tr style="background: #f8fafc; font-weight: 800;">
                        <td><strong>TOTAL REVENUE RECONCILIATION</strong></td>
                        <td style="color: var(--slate-900);">₹ <%= total %></td>
                        <td style="color: var(--slate-900);">₹ <%= vendor + labour %></td>
                        <td style="color: #15803d; font-size: 1.1rem;">₹ <%= totalAdmin %></td>
                        <td><span class="kc-badge badge-active">AUDITED</span></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div>

</body>
</html>