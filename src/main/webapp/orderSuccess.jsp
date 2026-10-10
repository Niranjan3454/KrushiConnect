<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmed | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.9) 0%, rgba(20, 83, 45, 0.85) 100%),
                        url('https://images.unsplash.com/photo-1499529112087-3cb3b73cec95?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            color: #ffffff;
        }

        .success-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            border-radius: 28px;
            padding: 3.5rem 2.5rem;
            text-align: center;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .celebrate-icon {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: rgba(34, 197, 94, 0.25);
            border: 2px solid #4ade80;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: #4ade80;
            margin: 0 auto 1.5rem;
            animation: kcPulse 2s infinite;
        }

        .success-title {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 0.75rem;
            letter-spacing: -0.02em;
        }

        .success-desc {
            font-size: 0.95rem;
            color: #cbd5e1;
            line-height: 1.6;
            margin-bottom: 2rem;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            flex-direction: column;
        }
    </style>
</head>

<body>

<div class="success-card">

    <div class="celebrate-icon">
        <i class="fa-solid fa-check"></i>
    </div>

    <h2 class="success-title">Order Placed Successfully!</h2>

    <p class="success-desc">
        Your agricultural supplies order has been registered and scheduled for dispatch. The assigned delivery partner will arrive at your farm location soon.
    </p>

    <!-- ORIGINAL ACTION LINK (UNCHANGED LOGIC) -->
    <div class="cta-buttons">
        <a href="myOrders.jsp" style="text-decoration: none;">
            <button class="kc-btn kc-btn-primary kc-btn-lg kc-btn-block">
                <i class="fa-solid fa-truck-fast"></i> Track Order Status
            </button>
        </a>

        <a href="farmerDashboard.jsp" style="text-decoration: none;">
            <button class="kc-btn kc-btn-outline-white kc-btn-block">
                <i class="fa-solid fa-house"></i> Return to Farmer Dashboard
            </button>
        </a>
    </div>

</div>

</body>
</html>