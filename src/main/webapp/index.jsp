<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KrushiConnect | Smart Agriculture & Rural Ecosystem</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.78) 0%, rgba(20, 83, 45, 0.72) 100%),
                        url('https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: #ffffff;
            overflow-x: hidden;
        }

        .landing-header {
            padding: 1.5rem 3rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(15, 23, 42, 0.35);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .hero-section {
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem 1.5rem;
        }

        .hero-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 28px;
            padding: 3.5rem 3rem;
            max-width: 680px;
            width: 100%;
            text-align: center;
            box-shadow: 0 30px 60px -12px rgba(0, 0, 0, 0.55);
            animation: kcSlideUp 0.8s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .badge-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: rgba(34, 197, 94, 0.2);
            border: 1px solid rgba(34, 197, 94, 0.4);
            color: #86efac;
            padding: 0.45rem 1.25rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            margin-bottom: 1.5rem;
        }

        .hero-title {
            font-size: 2.75rem;
            font-weight: 800;
            line-height: 1.15;
            color: #ffffff;
            margin-bottom: 1.25rem;
            letter-spacing: -0.03em;
        }

        .hero-title span {
            background: linear-gradient(135deg, #4ade80 0%, #a3e635 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-subtitle {
            font-size: 1.1rem;
            color: #e2e8f0;
            line-height: 1.6;
            margin-bottom: 2.25rem;
            font-weight: 400;
        }

        .role-chips {
            display: flex;
            justify-content: center;
            flex-wrap: wrap;
            gap: 0.65rem;
            margin-bottom: 2.5rem;
        }

        .role-chip {
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 12px;
            padding: 0.5rem 1rem;
            font-size: 0.85rem;
            font-weight: 600;
            color: #f1f5f9;
            display: flex;
            align-items: center;
            gap: 0.45rem;
            transition: all 0.25s ease;
        }

        .role-chip:hover {
            background: rgba(255, 255, 255, 0.22);
            transform: translateY(-2px);
        }

        .cta-group {
            display: flex;
            gap: 1.25rem;
            justify-content: center;
        }

        .btn-cta {
            flex: 1;
            padding: 1rem 1.75rem;
            font-size: 1.05rem;
            font-weight: 700;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.65rem;
            transition: all 0.25s ease;
            text-decoration: none;
        }

        .btn-register {
            background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
            color: #ffffff;
            box-shadow: 0 10px 25px -5px rgba(22, 163, 74, 0.5);
            border: 1px solid rgba(74, 222, 128, 0.4);
        }

        .btn-register:hover {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 15px 30px -5px rgba(22, 163, 74, 0.65);
        }

        .btn-login {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            color: #ffffff;
            border: 1.5px solid rgba(255, 255, 255, 0.4);
        }

        .btn-login:hover {
            background: rgba(255, 255, 255, 0.28);
            border-color: #ffffff;
            transform: translateY(-3px) scale(1.02);
        }

        .landing-footer {
            padding: 1.25rem 2rem;
            text-align: center;
            font-size: 0.875rem;
            color: #94a3b8;
            background: rgba(15, 23, 42, 0.4);
            border-top: 1px solid rgba(255, 255, 255, 0.08);
        }

        @media (max-width: 640px) {
            .landing-header { padding: 1rem 1.5rem; }
            .hero-card { padding: 2.25rem 1.5rem; }
            .hero-title { font-size: 2rem; }
            .cta-group { flex-direction: column; }
        }
    </style>
</head>

<body>

    <header class="landing-header">
        <div class="kc-brand">
            <div class="kc-brand-icon">🌱</div>
            <span>KrushiConnect</span>
        </div>
        <div style="font-size: 0.9rem; color: #cbd5e1; font-weight: 500;">
            <i class="fa-solid fa-seedling" style="color: #4ade80; margin-right: 6px;"></i> Agri-Tech Platform
        </div>
    </header>

    <main class="hero-section">
        <div class="hero-card">
            <div class="badge-pill">
                <i class="fa-solid fa-wheat-awn"></i> Empowering Agriculture & Rural Enterprise
            </div>

            <h1 class="hero-title">
                Smart Digital Farming, <span>Connected</span>
            </h1>

            <p class="hero-subtitle">
                A unified ecosystem linking <strong>Farmers</strong>, <strong>Agro-Vendors</strong>, <strong>Skilled Labour</strong>, and <strong>Express Delivery</strong> for maximized harvest yield and direct rural trade.
            </p>

            <div class="role-chips">
                <div class="role-chip"><i class="fa-solid fa-tractor" style="color:#4ade80;"></i> Farmers</div>
                <div class="role-chip"><i class="fa-solid fa-shop" style="color:#60a5fa;"></i> Agro Vendors</div>
                <div class="role-chip"><i class="fa-solid fa-person-digging" style="color:#facc15;"></i> Farm Labour</div>
                <div class="role-chip"><i class="fa-solid fa-truck-fast" style="color:#f87171;"></i> Doorstep Delivery</div>
                <div class="role-chip"><i class="fa-solid fa-shield-halved" style="color:#c084fc;"></i> Admin Moderated</div>
            </div>

            <!-- ORIGINAL LINKS (UNCHANGED LOGIC) -->
            <div class="cta-group">
                <a href="register.jsp" class="btn-cta btn-register">
                    <i class="fa-solid fa-user-plus"></i> Register
                </a>
                <a href="login.jsp" class="btn-cta btn-login">
                    <i class="fa-solid fa-right-to-bracket"></i> Login
                </a>
            </div>
        </div>
    </main>

    <footer class="landing-footer">
        Empowering agriculture with technology &bull; 🚜 KrushiConnect &copy; 2026. All rights reserved.
    </footer>

</body>
</html>