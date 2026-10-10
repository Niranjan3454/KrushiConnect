<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String bookingId = request.getParameter("bookingId");
    String amount = request.getParameter("amount");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Labour Settlement | KrushiConnect Secure Pay</title>

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

        .payment-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 26px;
            padding: 2.75rem 2.25rem;
            width: 100%;
            max-width: 460px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
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

        .method-picker {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.5rem;
            margin: 0.75rem 0 1.25rem;
        }

        .method-choice {
            background: rgba(255, 255, 255, 0.15);
            border: 1.5px solid rgba(255, 255, 255, 0.3);
            border-radius: 12px;
            padding: 0.75rem 0.5rem;
            text-align: center;
            cursor: pointer;
            font-size: 0.85rem;
            font-weight: 700;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.35rem;
            transition: all var(--transition-fast);
        }

        .method-choice:hover {
            background: rgba(255, 255, 255, 0.25);
            border-color: #4ade80;
        }

        .glass-input {
            width: 100%;
            padding: 0.8rem 1rem;
            background: rgba(255, 255, 255, 0.92);
            color: #0f172a;
            border: 1.5px solid rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            font-size: 0.95rem;
            font-family: var(--font-body);
            font-weight: 500;
            outline: none;
            margin-bottom: 0.85rem;
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
            font-size: 1.05rem;
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
            margin-top: 1rem;
        }

        .btn-pay:hover {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            transform: translateY(-2px);
        }
    </style>
</head>

<body>

<div class="payment-card">

    <div style="text-align: center; margin-bottom: 1.5rem;">
        <div style="font-size: 1.75rem; margin-bottom: 0.35rem;">💳</div>
        <h2 style="font-size: 1.75rem; font-weight: 800; color: #ffffff;">Labour Fee Settlement</h2>
        <p style="font-size: 0.85rem; color: #cbd5e1;">Booking Reference #LBK-<%= bookingId %></p>
    </div>

    <!-- AMOUNT DISPLAY -->
    <div class="amount-display">
        <div style="font-size: 0.8rem; color: #bbf7d0; text-transform: uppercase; letter-spacing: 0.05em; font-weight: 700;">
            Payable Amount
        </div>
        <div class="amount-val">₹ <%= amount %></div>
    </div>

    <!-- ORIGINAL FORM (UNCHANGED LOGIC) -->
    <form action="processLabourPayment.jsp" method="post">

        <input type="hidden" name="bookingId" value="<%= bookingId %>">

        <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9; display: block;">Select Payment Mode</label>
        
        <div class="method-picker">
            <label class="method-choice">
                <input type="radio" name="method" value="CASH" checked onclick="toggle()">
                <span>💵 Direct Cash</span>
            </label>
            <label class="method-choice">
                <input type="radio" name="method" value="UPI" onclick="toggle()">
                <span>📱 Online UPI</span>
            </label>
            <label class="method-choice">
                <input type="radio" name="method" value="CARD" onclick="toggle()">
                <span>💳 Debit Card</span>
            </label>
        </div>

        <!-- 📱 UPI SECTION -->
        <div id="upiSection" style="display:none; margin-top: 0.5rem;">
            <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9; display: block; margin-bottom: 0.25rem;">UPI ID</label>
            <input type="text" name="upi" class="glass-input" placeholder="e.g. mobile@upi">

            <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9; display: block; margin-bottom: 0.25rem;">UPI MPIN</label>
            <input type="password" name="upiPass" class="glass-input" placeholder="Enter PIN">
        </div>

        <!-- 💳 CARD SECTION -->
        <div id="cardSection" style="display:none; margin-top: 0.5rem;">
            <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9; display: block; margin-bottom: 0.25rem;">Debit / Credit Card Number</label>
            <input type="text" name="card" class="glass-input" placeholder="16 digit card number" maxlength="19">

            <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9; display: block; margin-bottom: 0.25rem;">CVV Security Code</label>
            <input type="password" name="cvv" class="glass-input" placeholder="3 digits" maxlength="4">
        </div>

        <button type="submit" class="btn-pay">
            <i class="fa-solid fa-circle-check"></i> Authorize & Complete Payment
        </button>

    </form>

    <div style="text-align: center; margin-top: 1.25rem;">
        <a href="myBookings.jsp" style="font-size: 0.85rem; color: #86efac; text-decoration: none; font-weight: 600;">
            <i class="fa-solid fa-arrow-left"></i> Cancel and Return to Bookings
        </a>
    </div>

</div>

<script>
function toggle(){
    let method = document.querySelector('input[name="method"]:checked').value;
    document.getElementById("upiSection").style.display = (method=="UPI") ? "block" : "none";
    document.getElementById("cardSection").style.display = (method=="CARD") ? "block" : "none";
}
</script>

</body>
</html>