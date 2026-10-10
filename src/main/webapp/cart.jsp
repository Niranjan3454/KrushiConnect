<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.Krushiconnect.model.CartItem, com.Krushiconnect.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if(user == null){
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .cart-layout {
            display: grid;
            grid-template-columns: 1.6fr 1fr;
            gap: 2rem;
            align-items: start;
        }

        .cart-item-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            padding: 1.5rem;
            margin-bottom: 1.25rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: var(--shadow-sm);
            transition: all var(--transition-fast);
        }

        .cart-item-card:hover {
            border-color: #86efac;
            box-shadow: var(--shadow-md);
        }

        .checkout-summary-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            padding: 1.75rem;
            box-shadow: var(--shadow-sm);
            position: sticky;
            top: 5rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0.75rem 0;
            border-bottom: 1px solid var(--slate-100);
            font-size: 0.95rem;
            color: var(--slate-600);
        }

        .summary-total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.25rem 0;
            font-family: var(--font-heading);
            font-size: 1.35rem;
            font-weight: 800;
            color: var(--slate-900);
            border-top: 2px dashed var(--slate-200);
            margin-top: 0.5rem;
        }

        .payment-radio-label {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.85rem 1rem;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--slate-200);
            background: var(--slate-50);
            cursor: pointer;
            margin-bottom: 0.75rem;
            font-weight: 600;
            color: var(--slate-800);
            transition: all var(--transition-fast);
        }

        .payment-radio-label:hover {
            background: #f0fdf4;
            border-color: #86efac;
        }

        @media (max-width: 840px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>

<!-- 🔥 NAVBAR -->
<nav class="kc-navbar navbar-farmer">
    <div class="kc-brand">
        <div class="kc-brand-icon">🌱</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Shopping Cart</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <a href="viewProducts.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-store"></i> Continue Shopping
        </a>
        <a href="farmerDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
            <i class="fa-solid fa-arrow-left"></i> Dashboard
        </a>
    </div>
</nav>

<div class="kc-container">

    <div style="margin-bottom: 1.75rem;">
        <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
            <i class="fa-solid fa-cart-shopping" style="color: #16a34a; margin-right: 8px;"></i> Your Farm Procurement Cart
        </h1>
        <p style="color: var(--slate-500); font-size: 0.95rem;">Review selected agricultural items and complete your delivery request.</p>
    </div>

<%
    List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

    if (cart == null || cart.isEmpty()) {
%>
    <!-- EMPTY CART STATE -->
    <div class="kc-card" style="padding: 4.5rem 2rem; text-align: center; max-width: 600px; margin: 2rem auto;">
        <div style="width: 80px; height: 80px; border-radius: 50%; background: #f1f5f9; color: #94a3b8; display: flex; align-items: center; justify-content: center; font-size: 2.5rem; margin: 0 auto 1.5rem;">
            <i class="fa-solid fa-cart-arrow-down"></i>
        </div>
        <h2 style="font-size: 1.5rem; font-weight: 800; color: var(--slate-800); margin-bottom: 0.5rem;">Your Cart is Empty</h2>
        <p style="color: var(--slate-500); font-size: 0.95rem; margin-bottom: 2rem;">
            You have not added any agricultural seeds, fertilizers, or tools yet.
        </p>
        <a href="viewProducts.jsp" class="kc-btn kc-btn-primary kc-btn-lg">
            <i class="fa-solid fa-basket-shopping"></i> Explore Marketplace
        </a>
    </div>
<%
    } else {
        double total = 0;
%>

    <div class="cart-layout">

        <!-- LEFT: ITEMS LIST -->
        <div>
        <%
            for (CartItem item : cart) {
                double subtotal = item.getPrice() * item.getQuantity();
                total += subtotal;
        %>
            <div class="cart-item-card">
                <div style="display: flex; align-items: center; gap: 1.25rem;">
                    <div style="width: 52px; height: 52px; border-radius: 14px; background: #dcfce7; color: #16a34a; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                        <i class="fa-solid fa-box-open"></i>
                    </div>
                    <div>
                        <div style="font-size: 1.15rem; font-weight: 700; color: var(--slate-900); margin-bottom: 0.25rem;">
                            <%= item.getName() %>
                        </div>
                        <div style="font-size: 0.85rem; color: var(--slate-500);">
                            Unit Price: <strong>₹ <%= item.getPrice() %></strong> &bull; Qty: <strong><%= item.getQuantity() %></strong>
                        </div>
                        <div style="font-size: 1rem; font-weight: 700; color: #15803d; margin-top: 0.35rem;">
                            Subtotal: ₹ <%= subtotal %>
                        </div>
                    </div>
                </div>

                <!-- REMOVE FORM (UNCHANGED LOGIC) -->
                <form action="removeFromCart" method="post">
                    <input type="hidden" name="productId" value="<%= item.getProductId() %>">
                    <button type="submit" class="kc-btn kc-btn-outline kc-btn-sm" style="border-color: #fee2e2; color: #dc2626;" title="Remove Item">
                        <i class="fa-regular fa-trash-can"></i> Remove
                    </button>
                </form>
            </div>
        <%
            }
            double deliveryFee = 50;
            double finalTotal = total + deliveryFee;
        %>
        </div>

        <!-- RIGHT: CHECKOUT & ADDRESS SUMMARY (UNCHANGED LOGIC) -->
        <div>
            <div class="checkout-summary-card">
                <h3 style="font-size: 1.25rem; font-weight: 700; margin-bottom: 1.25rem; display: flex; align-items: center; gap: 0.5rem;">
                    <i class="fa-solid fa-receipt" style="color: #16a34a;"></i> Order Summary
                </h3>

                <div class="summary-row">
                    <span>Marketplace Total</span>
                    <strong style="color: var(--slate-800);">₹ <%= total %></strong>
                </div>

                <div class="summary-row">
                    <span>Doorstep Rural Delivery Fee</span>
                    <strong style="color: var(--slate-800);">₹ <%= deliveryFee %></strong>
                </div>

                <div class="summary-total-row">
                    <span>Total Amount</span>
                    <span style="color: #15803d;">₹ <%= finalTotal %></span>
                </div>

                <!-- CHECKOUT FORM TO payment.jsp (UNCHANGED LOGIC & INPUTS) -->
                <form action="payment.jsp" method="post" style="margin-top: 1.5rem;">

                    <label class="kc-label" style="margin-bottom: 0.35rem;">
                        <i class="fa-solid fa-location-dot" style="color: #dc2626; margin-right: 4px;"></i> Delivery Address / Farm Location
                    </label>
                    <textarea name="address"
                              class="kc-textarea"
                              placeholder="House No, Village/Taluka, Landmark, Pin code"
                              style="height: 85px; margin-bottom: 1.25rem;"
                              required></textarea>

                    <label class="kc-label" style="margin-bottom: 0.5rem;">
                        <i class="fa-solid fa-credit-card" style="color: #0284c7; margin-right: 4px;"></i> Select Payment Option
                    </label>

                    <label class="payment-radio-label">
                        <input type="radio" name="paymentMode" value="COD" checked>
                        <span>💵 Cash on Delivery (COD)</span>
                    </label>

                    <label class="payment-radio-label">
                        <input type="radio" name="paymentMode" value="ONLINE">
                        <span>💳 Online Payment (UPI / Debit / Credit Card)</span>
                    </label>

                    <!-- ORIGINAL HIDDEN PARAMS (UNCHANGED LOGIC) -->
                    <input type="hidden" name="totalAmount" value="<%= total %>">
                    <input type="hidden" name="deliveryFee" value="50">

                    <button type="submit" class="kc-btn kc-btn-primary kc-btn-lg kc-btn-block" style="margin-top: 1rem;">
                        <i class="fa-solid fa-lock"></i> Proceed to Secure Payment
                    </button>

                </form>

            </div>
        </div>

    </div>

<% } %>

</div>

</body>
</html>