<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Labour Service | KrushiConnect</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.88) 0%, rgba(55, 48, 163, 0.82) 100%),
                        url('https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1.5rem;
            color: #ffffff;
        }

        .service-form-card {
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

        .header-box {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header-icon {
            width: 58px;
            height: 58px;
            background: rgba(99, 102, 241, 0.25);
            border: 1.5px solid rgba(129, 140, 248, 0.4);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: #818cf8;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
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
            padding: 0.8rem 1rem;
            background: rgba(255, 255, 255, 0.92);
            color: #0f172a;
            border: 1.5px solid rgba(255, 255, 255, 0.5);
            border-radius: 12px;
            font-size: 0.925rem;
            font-family: var(--font-body);
            font-weight: 500;
            outline: none;
            margin-bottom: 1.15rem;
            transition: all 0.25s ease;
        }

        .glass-input:focus {
            background: #ffffff;
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.35);
        }

        .btn-submit {
            width: 100%;
            margin-top: 0.5rem;
            padding: 0.95rem;
            border-radius: 12px;
            font-size: 1.05rem;
            font-weight: 700;
            background: linear-gradient(135deg, #4f46e5 0%, #4338ca 100%);
            color: #ffffff;
            border: 1px solid rgba(129, 140, 248, 0.4);
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.6rem;
            box-shadow: 0 8px 20px -4px rgba(79, 70, 229, 0.5);
            transition: all 0.25s ease;
        }

        .btn-submit:hover {
            background: linear-gradient(135deg, #6366f1 0%, #4f46e5 100%);
            transform: translateY(-2px);
        }
    </style>
</head>

<body>

<div class="service-form-card">

    <div class="header-box">
        <div class="header-icon"><i class="fa-solid fa-person-digging"></i></div>
        <h2 style="font-size: 1.75rem; font-weight: 800; color: #ffffff; letter-spacing: -0.02em;">Add Labour Service</h2>
        <p style="font-size: 0.88rem; color: #cbd5e1; margin-top: 0.35rem;">Register your crew for agricultural farm hire</p>
    </div>

    <!-- ORIGINAL FORM (UNCHANGED LOGIC) -->
    <form action="addService" method="post">

        <label class="field-label">Service Type / Operation</label>
        <input type="text" name="serviceType" class="glass-input" placeholder="e.g. Paddy Harvesting, Tractor Tilling, Sugarcane Cutting" required>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
            <div>
                <label class="field-label">Team / Crew Size</label>
                <input type="number" name="teamSize" class="glass-input" placeholder="e.g. 5" min="1" required>
            </div>
            <div>
                <label class="field-label">Daily Wage (₹ / Day)</label>
                <input type="number" step="0.01" name="price" class="glass-input" placeholder="e.g. 1200.00" required>
            </div>
        </div>

        <label class="field-label">Service Description</label>
        <textarea name="description" class="glass-input" style="height: 85px; resize: none;" placeholder="Details about equipment provided, work timings, field requirements..." required></textarea>

        <button type="submit" class="btn-submit">
            <i class="fa-solid fa-plus-circle"></i> Publish Labour Listing
        </button>

    </form>

    <div style="text-align: center; margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid rgba(255, 255, 255, 0.15); font-size: 0.9rem;">
        <a href="labourDashboard.jsp" style="color: #a5b4fc; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 0.4rem;">
            <i class="fa-solid fa-arrow-left"></i> Return to Labour Dashboard
        </a>
    </div>

</div>

</body>
</html>