<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | KrushiConnect Portal</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.88) 0%, rgba(20, 83, 45, 0.82) 100%),
                        url('https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1.5rem;
            color: #ffffff;
        }

        .register-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 26px;
            padding: 2.75rem 2.5rem;
            width: 100%;
            max-width: 540px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .register-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .register-brand-icon {
            width: 58px;
            height: 58px;
            background: rgba(34, 197, 94, 0.25);
            border: 1.5px solid rgba(74, 222, 128, 0.4);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        .register-title {
            font-size: 1.85rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
        }

        .register-subtitle {
            font-size: 0.9rem;
            color: #cbd5e1;
            margin-top: 0.35rem;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.15rem;
        }

        .col-span-2 {
            grid-column: span 2;
        }

        .field-group {
            margin-bottom: 0.25rem;
        }

        .field-label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: #f1f5f9;
            margin-bottom: 0.35rem;
        }

        .input-box {
            position: relative;
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
            padding: 0.8rem 1rem 0.8rem 2.75rem;
            background: rgba(255, 255, 255, 0.92);
            color: #0f172a;
            border: 1.5px solid rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            font-size: 0.925rem;
            font-family: var(--font-body);
            font-weight: 500;
            outline: none;
            transition: all 0.25s ease;
        }

        .glass-input:focus {
            background: #ffffff;
            border-color: #22c55e;
            box-shadow: 0 0 0 4px rgba(34, 197, 94, 0.35);
        }

        select.glass-input {
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23475569' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            background-size: 1em;
            padding-right: 2.5rem;
        }

        .btn-register-submit {
            width: 100%;
            margin-top: 1.5rem;
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
            gap: 0.6rem;
            box-shadow: 0 8px 20px -4px rgba(22, 163, 74, 0.5);
            transition: all 0.25s ease;
        }

        .btn-register-submit:hover {
            background: linear-gradient(135deg, #22c55e 0%, #16a34a 100%);
            transform: translateY(-2px);
            box-shadow: 0 12px 24px -4px rgba(22, 163, 74, 0.65);
        }

        .register-footer {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.25rem;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            font-size: 0.9rem;
            color: #cbd5e1;
        }

        .register-footer a {
            color: #4ade80;
            font-weight: 700;
            text-decoration: none;
            margin-left: 0.25rem;
        }

        .register-footer a:hover {
            text-decoration: underline;
        }

        @media (max-width: 600px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            .col-span-2 {
                grid-column: span 1;
            }
            .register-card {
                padding: 2rem 1.5rem;
            }
        }
    </style>
</head>

<body>

<div class="register-card">

    <div class="register-header">
        <div class="register-brand-icon">🌱</div>
        <h2 class="register-title">Create Account</h2>
        <p class="register-subtitle">Join the KrushiConnect digital agricultural network</p>
    </div>

    <!-- ORIGINAL FORM (UNCHANGED LOGIC) -->
    <form action="register" method="post">

        <div class="form-grid">

            <div class="field-group">
                <label class="field-label">Full Name</label>
                <div class="input-box">
                    <input type="text" name="name" class="glass-input" placeholder="e.g. Ramesh Patel" required>
                    <i class="fa-solid fa-user"></i>
                </div>
            </div>

            <div class="field-group">
                <label class="field-label">Email Address</label>
                <div class="input-box">
                    <input type="email" name="email" class="glass-input" placeholder="e.g. ramesh@farm.in" required>
                    <i class="fa-solid fa-envelope"></i>
                </div>
            </div>

            <div class="field-group">
                <label class="field-label">Password</label>
                <div class="input-box">
                    <input type="password" name="password" class="glass-input" placeholder="Min. 6 characters" required>
                    <i class="fa-solid fa-lock"></i>
                </div>
            </div>

            <div class="field-group">
                <label class="field-label">Platform Role</label>
                <div class="input-box">
                    <select name="role" class="glass-input" required>
                        <option value="FARMER">🌾 FARMER (Produce & Services)</option>
                        <option value="VENDOR">🏪 VENDOR (Agro Products)</option>
                        <option value="LABOUR">🚜 LABOUR (Service Provider)</option>
                        <option value="DELIVERY">🚚 DELIVERY (Logistics Partner)</option>
                    </select>
                    <i class="fa-solid fa-briefcase"></i>
                </div>
            </div>

            <div class="field-group">
                <label class="field-label">Phone Number</label>
                <div class="input-box">
                    <input type="text" name="phone" class="glass-input" placeholder="10-digit Mobile" required>
                    <i class="fa-solid fa-phone"></i>
                </div>
            </div>

            <div class="field-group">
                <label class="field-label">Village / Town Address</label>
                <div class="input-box">
                    <input type="text" name="address" class="glass-input" placeholder="Village, Taluka, District" required>
                    <i class="fa-solid fa-location-dot"></i>
                </div>
            </div>

        </div>

        <button type="submit" class="btn-register-submit">
            <i class="fa-solid fa-user-check"></i> Complete Registration
        </button>

    </form>

    <div class="register-footer">
        Already have an account? <a href="login.jsp">Login to Portal</a>
    </div>

</div>

</body>
</html>