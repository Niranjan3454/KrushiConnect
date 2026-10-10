<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.88) 0%, rgba(20, 83, 45, 0.82) 100%),
                        url('https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1.5rem;
            color: #ffffff;
        }

        .reset-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 24px;
            padding: 2.75rem 2.25rem;
            width: 100%;
            max-width: 420px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .reset-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .reset-icon {
            width: 58px;
            height: 58px;
            background: rgba(2, 132, 199, 0.25);
            border: 1.5px solid rgba(56, 189, 248, 0.4);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.65rem;
            color: #38bdf8;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        .reset-title {
            font-size: 1.75rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .reset-subtitle {
            font-size: 0.88rem;
            color: #cbd5e1;
            margin-top: 0.35rem;
        }

        .input-box {
            position: relative;
            margin-bottom: 1.25rem;
        }

        .input-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            font-size: 0.95rem;
            pointer-events: none;
        }

        .glass-input {
            width: 100%;
            padding: 0.85rem 1rem 0.85rem 2.75rem;
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

        .glass-input:focus {
            background: #ffffff;
            border-color: #0284c7;
            box-shadow: 0 0 0 4px rgba(2, 132, 199, 0.35);
        }

        .btn-reset-submit {
            width: 100%;
            padding: 0.95rem;
            border-radius: 12px;
            font-size: 1.05rem;
            font-weight: 700;
            background: linear-gradient(135deg, #0284c7 0%, #0369a1 100%);
            color: #ffffff;
            border: 1px solid rgba(56, 189, 248, 0.4);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            box-shadow: 0 8px 20px -4px rgba(2, 132, 199, 0.5);
            transition: all 0.25s ease;
        }

        .btn-reset-submit:hover {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            transform: translateY(-2px);
            box-shadow: 0 12px 24px -4px rgba(2, 132, 199, 0.65);
        }

        .reset-footer {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            font-size: 0.9rem;
        }

        .reset-footer a {
            color: #86efac;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
        }

        .reset-footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>

<body>

<div class="reset-card">

    <div class="reset-header">
        <div class="reset-icon"><i class="fa-solid fa-key"></i></div>
        <h2 class="reset-title">Reset Password</h2>
        <p class="reset-subtitle">Enter your registered email and set a new password</p>
    </div>

    <!-- ORIGINAL FORM (UNCHANGED LOGIC) -->
    <form action="resetPassword" method="post">

        <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9; margin-bottom: 0.35rem; display: block;">Registered Email</label>
        <div class="input-box">
            <input type="email" name="email" class="glass-input" placeholder="e.g. yourname@domain.com" required>
            <i class="fa-solid fa-envelope"></i>
        </div>

        <label style="font-size: 0.85rem; font-weight: 600; color: #f1f5f9; margin-bottom: 0.35rem; display: block;">New Password</label>
        <div class="input-box">
            <input type="password" name="newPassword" class="glass-input" placeholder="Enter new strong password" required>
            <i class="fa-solid fa-lock"></i>
        </div>

        <button type="submit" class="btn-reset-submit">
            <i class="fa-solid fa-arrows-rotate"></i> Update Password
        </button>

    </form>

    <div class="reset-footer">
        <a href="login.jsp"><i class="fa-solid fa-arrow-left"></i> Return to Login</a>
    </div>

</div>

</body>
</html>