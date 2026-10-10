<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String totalAmount = request.getParameter("totalAmount");
    if (totalAmount == null) totalAmount = "0";

    String deliveryFee = request.getParameter("deliveryFee");
    if (deliveryFee == null) deliveryFee = "50";

    double finalTotal = Double.parseDouble(totalAmount) + Double.parseDouble(deliveryFee);

    String paymentMode = request.getParameter("paymentMode");
    String address = request.getParameter("address");

    // 🔥 COD FORWARD (UNCHANGED LOGIC)
    if ("COD".equalsIgnoreCase(paymentMode)) {
        request.setAttribute("paymentMode", paymentMode);
        request.setAttribute("address", address);
        request.getRequestDispatcher("placeOrder").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Gateway | KrushiConnect Secure Pay</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.88) 0%, rgba(20, 83, 45, 0.82) 100%),
                        url('https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 1.5rem;
            color: #ffffff;
        }

        .gateway-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 26px;
            padding: 2.75rem 2.25rem;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .gateway-header {
            text-align: center;
            margin-bottom: 1.75rem;
        }

        .amount-display {
            background: rgba(34, 197, 94, 0.2);
            border: 1.5px solid rgba(74, 222, 128, 0.4);
            border-radius: var(--radius-lg);
            padding: 1.25rem;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .amount-val {
            font-size: 2.25rem;
            font-weight: 800;
            color: #86efac;
            font-family: var(--font-heading);
            letter-spacing: -0.02em;
        }

        .method-toggle {
            display: flex;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .method-btn {
            flex: 1;
            padding: 0.85rem;
            border-radius: 12px;
            border: 1.5px solid rgba(255, 255, 255, 0.3);
            background: rgba(255, 255, 255, 0.15);
            color: #ffffff;
            font-weight: 700;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            transition: all var(--transition-fast);
        }

        .method-btn.active {
            background: #ffffff;
            color: #0f172a;
            border-color: #ffffff;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }

        .field-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #f1f5f9;
            margin-bottom: 0.35rem;
        }

        .glass-input {
            width: 100%;
            padding: 0.85rem 1rem;
            background: rgba(255, 255, 255, 0.92);
            color: #0f172a;
            border: 1.5px solid rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            font-size: 0.95rem;
            font-family: var(--font-body);
            font-weight: 500;
            outline: none;
            margin-bottom: 1rem;
            transition: all var(--transition-fast);
        }

        .glass-input:focus {
            background: #ffffff;
            border-color: #22c55e;
            box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.35);
        }

        .btn-pay {
            width: 100%;
            padding: 1rem;
            border-radius: 14px;
            font-size: 1.1rem;
            font-weight: 700;
            background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
            color: #ffffff;
            border: 1px solid rgba(74, 222, 128, 0.4);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            box-shadow: 0 10px 25px -5px rgba(22, 163, 74, 0.6);
            transition: all 0.25s ease;
        }

        .btn-pay:hover {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            transform: translateY(-2px);
        }

        .error-banner {
            background: rgba(239, 68, 68, 0.25);
            border: 1px solid #ef4444;
            color: #fee2e2;
            padding: 0.75rem 1rem;
            border-radius: 10px;
            margin-bottom: 1.25rem;
            font-size: 0.875rem;
            font-weight: 600;
            text-align: center;
        }
    </style>
</head>

<body>

<div class="gateway-card">

    <div class="gateway-header">
        <div style="font-size: 1.75rem; margin-bottom: 0.35rem;">🔒</div>
        <h2 style="font-size: 1.75rem; font-weight: 800; color: #ffffff;">Secure Payment Gateway</h2>
        <p style="font-size: 0.85rem; color: #cbd5e1;">256-Bit SSL Encrypted Agricultural Transaction</p>
    </div>

    <!-- AMOUNT DISPLAY -->
    <div class="amount-display">
        <div style="font-size: 0.8rem; color: #bbf7d0; text-transform: uppercase; letter-spacing: 0.05em; font-weight: 700;">
            Total Payable (Includes ₹<%= deliveryFee %> Delivery)
        </div>
        <div class="amount-val">₹ <%= finalTotal %></div>
    </div>

    <!-- SCRIPTLET VALIDATION CHECK & FORWARD (UNCHANGED LOGIC) -->
    <%
        String method = request.getParameter("method");

        if (method != null) {
            String errorMsg = null;

            if ("UPI".equals(method)) {
                String upi = request.getParameter("upi");
                String pass = request.getParameter("upiPassword");

                if (upi == null || !upi.contains("@")) {
                    errorMsg = "❌ Invalid UPI ID. Format should be user@upi";
                } else if (pass == null || pass.length() < 4) {
                    errorMsg = "❌ Invalid UPI PIN (min. 4 digits)";
                }
            } else if ("CARD".equals(method)) {
                String card = request.getParameter("card");
                String cvv = request.getParameter("cvv");

                if (card == null || card.length() < 12) {
                    errorMsg = "❌ Invalid Card Number (min. 12 digits)";
                } else if (cvv == null || cvv.length() != 3) {
                    errorMsg = "❌ Invalid CVV (3 digits required)";
                }
            }

            if(errorMsg != null){
    %>
                <div class="error-banner"><%= errorMsg %></div>
    <%
            } else {
                request.setAttribute("paymentMode", "ONLINE");
                request.setAttribute("address", address);
                request.getRequestDispatcher("processing.jsp").forward(request, response);
                return;
            }
        }
    %>

    <!-- ORIGINAL FORM (UNCHANGED LOGIC & ACTION) -->
    <form method="post" action="payment.jsp">

        <!-- PRESERVE ORIGINAL PARAMS -->
        <input type="hidden" name="totalAmount" value="<%= totalAmount %>">
        <input type="hidden" name="deliveryFee" value="<%= deliveryFee %>">
        <input type="hidden" name="address" value="<%= address != null ? address : "" %>">
        <input type="hidden" name="paymentMode" value="ONLINE">

        <!-- PAYMENT METHOD TABS -->
        <div style="margin-bottom: 1rem;">
            <label class="field-label">Select Online Method</label>
            <div style="display: flex; gap: 1rem; margin-bottom: 1.25rem;">
                <label style="flex: 1; display: flex; align-items: center; gap: 0.5rem; background: rgba(255,255,255,0.15); padding: 0.75rem 1rem; border-radius: 12px; cursor: pointer; border: 1.5px solid rgba(255,255,255,0.3); font-weight: 600;">
                    <input type="radio" name="method" value="UPI" checked onclick="toggleMethod('UPI')">
                    <span>📱 UPI (GPay/PhonePe)</span>
                </label>
                <label style="flex: 1; display: flex; align-items: center; gap: 0.5rem; background: rgba(255,255,255,0.15); padding: 0.75rem 1rem; border-radius: 12px; cursor: pointer; border: 1.5px solid rgba(255,255,255,0.3); font-weight: 600;">
                    <input type="radio" name="method" value="CARD" onclick="toggleMethod('CARD')">
                    <span>💳 Debit/Credit Card</span>
                </label>
            </div>
        </div>

        <!-- 📱 UPI SECTION -->
        <div id="upiSection">
            <label class="field-label">Virtual Payment Address (UPI ID)</label>
            <input type="text" name="upi" class="glass-input" placeholder="e.g. farmer@okhdfcbank" value="<%= request.getParameter("upi") != null ? request.getParameter("upi") : "" %>">

            <label class="field-label">UPI MPIN</label>
            <input type="password" name="upiPassword" class="glass-input" placeholder="Enter 4 or 6 digit PIN">
        </div>

        <!-- 💳 CARD SECTION -->
        <div id="cardSection" style="display: none;">
            <label class="field-label">16-Digit Card Number</label>
            <input type="text" name="card" class="glass-input" placeholder="XXXX XXXX XXXX XXXX" maxlength="19" value="<%= request.getParameter("card") != null ? request.getParameter("card") : "" %>">

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div>
                    <label class="field-label">CVV / CVC</label>
                    <input type="password" name="cvv" class="glass-input" placeholder="3 digits" maxlength="4">
                </div>
                <div>
                    <label class="field-label">Expiry (MM/YY)</label>
                    <input type="text" class="glass-input" placeholder="12/28">
                </div>
            </div>
        </div>

        <button type="submit" class="btn-pay">
            <i class="fa-solid fa-lock"></i> Authorize & Pay ₹<%= finalTotal %>
        </button>

    </form>

    <div style="text-align: center; margin-top: 1.25rem;">
        <a href="cart.jsp" style="font-size: 0.85rem; color: #86efac; text-decoration: none; font-weight: 600;">
            <i class="fa-solid fa-arrow-left"></i> Cancel and Return to Cart
        </a>
    </div>

</div>

<script>
function toggleMethod(type) {
    if (type === "UPI") {
        document.getElementById("upiSection").style.display = "block";
        document.getElementById("cardSection").style.display = "none";
    } else {
        document.getElementById("upiSection").style.display = "none";
        document.getElementById("cardSection").style.display = "block";
    }
}
</script>

</body>
</html>