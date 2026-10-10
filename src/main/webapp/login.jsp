<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | KrushiConnect Portal</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.85) 0%, rgba(20, 83, 45, 0.8) 100%),
                        url('https://images.unsplash.com/photo-1492496913980-501348b61469?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            color: #ffffff;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 24px;
            padding: 2.75rem 2.25rem;
            width: 100%;
            max-width: 430px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-brand-icon {
            width: 60px;
            height: 60px;
            background: rgba(34, 197, 94, 0.25);
            border: 1.5px solid rgba(74, 222, 128, 0.4);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.85rem;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        .login-title {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .login-subtitle {
            font-size: 0.9rem;
            color: #cbd5e1;
            margin-top: 0.35rem;
        }

        .input-wrapper {
            position: relative;
            margin-bottom: 1.25rem;
        }

        .input-icon {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 1rem;
            pointer-events: none;
            transition: color 0.2s ease;
        }

        .kc-glass-input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.85rem;
            background: rgba(255, 255, 255, 0.92);
            color: #0f172a;
            border: 1.5px solid rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            font-size: 0.95rem;
            font-family: var(--font-body);
            font-weight: 500;
            outline: none;
            transition: all 0.25s ease;
        }

        .kc-glass-input:focus {
            background: #ffffff;
            border-color: #22c55e;
            box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.35);
        }

        .kc-glass-input:focus + .input-icon,
        .input-wrapper:focus-within .input-icon {
            color: #16a34a;
        }

        .toggle-pwd {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #64748b;
            cursor: pointer;
            padding: 0;
            font-size: 1rem;
        }

        .error-alert {
            background: rgba(239, 68, 68, 0.2);
            border: 1px solid rgba(248, 113, 113, 0.6);
            color: #fecaca;
            padding: 0.85rem 1rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 0.875rem;
            font-weight: 600;
            animation: kcShake 0.4s ease-in-out;
        }

        .btn-submit {
            width: 100%;
            padding: 0.95rem;
            border-radius: 12px;
            font-size: 1.05rem;
            font-weight: 700;
            background: linear-gradient(135deg, #16a34a 0%, #15803d 100%);
            color: #ffffff;
            border: 1px solid rgba(74, 222, 128, 0.4);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            box-shadow: 0 8px 20px -4px rgba(22, 163, 74, 0.5);
            transition: all 0.25s ease;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            transform: translateY(-2px);
            box-shadow: 0 12px 24px -4px rgba(22, 163, 74, 0.65);
        }

        .login-links {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin: 1.5rem 0 1rem;
            font-size: 0.875rem;
        }

        .login-links a {
            color: #86efac;
            text-decoration: none;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        .login-links a:hover {
            color: #bbf7d0;
            text-decoration: underline;
        }

        .register-cta {
            text-align: center;
            padding-top: 1.25rem;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            font-size: 0.9rem;
            color: #cbd5e1;
        }

        .register-cta a {
            color: #4ade80;
            font-weight: 700;
            text-decoration: none;
            margin-left: 0.25rem;
        }

        .register-cta a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="login-card <%= error != null ? "kc-shake" : "" %>">

    <div class="login-header">
        <div class="login-brand-icon">🌱</div>
        <h2 class="login-title">Welcome Back</h2>
        <p class="login-subtitle">Log in to manage farming, sales, or logistics</p>
    </div>

    <!-- 🔥 ERROR MESSAGE (UNCHANGED LOGIC) -->
    <%
        if(error != null){
            String message = "";
            String iconClass = "fa-circle-exclamation";
            if(error.equals("invalid")){
                message = "Invalid Email or Password. Please verify credentials.";
            } else if(error.equals("disabled")){
                message = "Your account has been deactivated by the Administrator.";
                iconClass = "fa-ban";
            }
    %>
        <div class="error-alert">
            <i class="fa-solid <%= iconClass %>"></i>
            <span><%= message %></span>
        </div>
    <%
        }
    %>

    <!-- ORIGINAL FORM (UNCHANGED LOGIC) -->
    <form action="login" method="post">

        <label style="font-size: 0.85rem; font-weight: 600; margin-bottom: 0.35rem; display: block; color: #f1f5f9;">Email Address</label>
        <div class="input-wrapper">
            <input type="email"
                   name="email"
                   class="kc-glass-input"
                   placeholder="e.g. farmer@krushi.com"
                   required>
            <i class="fa-solid fa-envelope input-icon"></i>
        </div>

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.35rem;">
            <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9;">Password</label>
            <a href="forgotPassword.jsp" style="font-size: 0.8rem; color: #86efac; text-decoration: none; font-weight: 600;">Forgot Password?</a>
        </div>
        <div class="input-wrapper">
            <input type="password"
                   id="passwordInput"
                   name="password"
                   class="kc-glass-input"
                   placeholder="Enter your account password"
                   required>
            <i class="fa-solid fa-lock input-icon"></i>
            <button type="button" class="toggle-pwd" onclick="togglePasswordVisibility()">
                <i class="fa-regular fa-eye" id="eyeIcon"></i>
            </button>
        </div>

        <button type="submit" class="btn-submit">
            <i class="fa-solid fa-arrow-right-to-bracket"></i> Login to Portal
        </button>

    </form>

    <div class="register-cta">
        Don't have an account yet?
        <a href="register.jsp">Create Account</a>
    </div>

</div>

<script>
    function togglePasswordVisibility() {
        const pwd = document.getElementById('passwordInput');
        const icon = document.getElementById('eyeIcon');
        if (pwd.type === 'password') {
            pwd.type = 'text';
            icon.classList.remove('fa-eye');
            icon.classList.add('fa-eye-slash');
        } else {
            pwd.type = 'password';
            icon.classList.remove('fa-eye-slash');
            icon.classList.add('fa-eye');
        }
    }
</script>

</body>
</html>