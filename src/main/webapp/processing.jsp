<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Processing Payment | KrushiConnect Secure Pay</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.9) 0%, rgba(20, 83, 45, 0.85) 100%),
                        url('https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            color: #ffffff;
        }

        .process-box {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 26px;
            padding: 3.5rem 2.5rem;
            width: 100%;
            max-width: 440px;
            text-align: center;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .spinner-ring {
            width: 72px;
            height: 72px;
            border: 5px solid rgba(255, 255, 255, 0.2);
            border-top: 5px solid #22c55e;
            border-right: 5px solid #4ade80;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 1.75rem;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .steps-box {
            background: rgba(0, 0, 0, 0.2);
            border-radius: 14px;
            padding: 1rem 1.25rem;
            margin: 1.5rem 0;
            text-align: left;
            font-size: 0.85rem;
            color: #cbd5e1;
        }

        .step-item {
            display: flex;
            align-items: center;
            gap: 0.65rem;
            margin-bottom: 0.5rem;
        }

        .step-item:last-child {
            margin-bottom: 0;
        }
    </style>

    <!-- 🔥 AUTO REDIRECT AFTER 2.5 SEC (UNCHANGED LOGIC) -->
    <script>
        setTimeout(function(){
            document.getElementById("payForm").submit();
        }, 2500);
    </script>
</head>

<body>

<div class="process-box">

    <div class="spinner-ring"></div>

    <h2 style="font-size: 1.65rem; font-weight: 800; color: #ffffff; margin-bottom: 0.5rem;">
        Processing Payment...
    </h2>

    <p style="font-size: 0.9rem; color: #cbd5e1;">
        Communicating with banking node. Please do not refresh or close this window.
    </p>

    <div class="steps-box">
        <div class="step-item">
            <i class="fa-solid fa-check" style="color: #22c55e;"></i>
            <span>Verifying customer account token</span>
        </div>
        <div class="step-item">
            <i class="fa-solid fa-arrows-rotate fa-spin" style="color: #38bdf8;"></i>
            <span>Confirming multi-vendor split settlement</span>
        </div>
        <div class="step-item">
            <i class="fa-regular fa-clock" style="color: #94a3b8;"></i>
            <span>Auto-dispatching rural delivery agent</span>
        </div>
    </div>

    <!-- 🔥 HIDDEN FORM (UNCHANGED LOGIC & INPUTS) -->
    <form id="payForm" action="placeOrder" method="post">
        <input type="hidden" name="paymentMode" value="ONLINE">
        <input type="hidden" name="address" value="<%= request.getParameter("address") != null ? request.getParameter("address") : "" %>">
    </form>

</div>

</body>
</html>