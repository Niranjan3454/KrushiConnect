<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product | KrushiConnect Vendor</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, rgba(15, 23, 42, 0.88) 0%, rgba(3, 105, 161, 0.82) 100%),
                        url('https://images.unsplash.com/photo-1606788075761-9d4f0a4f6d0c?auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2.5rem 1.5rem;
            color: #ffffff;
        }

        .product-form-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 26px;
            padding: 2.75rem 2.5rem;
            width: 100%;
            max-width: 600px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.6);
            animation: kcSlideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1);
        }

        .form-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .header-icon {
            width: 58px;
            height: 58px;
            background: rgba(2, 132, 199, 0.25);
            border: 1.5px solid rgba(56, 189, 248, 0.4);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: #38bdf8;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 16px rgba(0,0,0,0.2);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.15rem;
        }

        .col-span-2 {
            grid-column: span 2;
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
            transition: all 0.25s ease;
        }

        .glass-input:focus {
            background: #ffffff;
            border-color: #0284c7;
            box-shadow: 0 0 0 4px rgba(2, 132, 199, 0.35);
        }

        .file-upload-box {
            background: rgba(255, 255, 255, 0.15);
            border: 2px dashed rgba(255, 255, 255, 0.4);
            border-radius: 14px;
            padding: 1.25rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.25s ease;
        }

        .file-upload-box:hover {
            background: rgba(255, 255, 255, 0.25);
            border-color: #38bdf8;
        }

        .btn-submit {
            width: 100%;
            margin-top: 1.5rem;
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

        .btn-submit:hover {
            background: linear-gradient(135deg, #0ea5e9 0%, #0284c7 100%);
            transform: translateY(-2px);
            box-shadow: 0 12px 24px -4px rgba(2, 132, 199, 0.65);
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
            .col-span-2 { grid-column: span 1; }
            .product-form-card { padding: 2rem 1.5rem; }
        }
    </style>
</head>

<body>

<% String errorMsg = request.getParameter("error"); %>

<div class="product-form-card">

    <% if("true".equals(errorMsg)){ %>
        <div style="background: rgba(239,68,68,0.18); border: 1.5px solid rgba(239,68,68,0.5); color: #fecaca; padding: 0.85rem 1.1rem; border-radius: 12px; margin-bottom: 1.25rem; font-size: 0.9rem; font-weight: 600; display: flex; align-items: center; gap: 0.5rem;">
            <i class="fa-solid fa-circle-exclamation"></i>
            Failed to save product. Please check all fields and try again.
        </div>
    <% } %>

    <div class="form-header">
        <div class="header-icon"><i class="fa-solid fa-box-open"></i></div>
        <h2 style="font-size: 1.85rem; font-weight: 800; color: #ffffff; letter-spacing: -0.02em;">Add New Product</h2>
        <p style="font-size: 0.88rem; color: #cbd5e1; margin-top: 0.35rem;">List agricultural seeds, fertilizer, chemicals or equipment</p>
    </div>

    <!-- ORIGINAL FORM (UNCHANGED LOGIC & ENCTYPE) -->
    <form action="addProduct" method="post" enctype="multipart/form-data">

        <div class="form-grid">

            <div class="col-span-2">
                <label class="field-label">Product Name</label>
                <input type="text" name="name" class="glass-input" placeholder="e.g. NPK 19-19-19 Water Soluble Fertilizer" required>
            </div>

            <div class="col-span-2">
                <label class="field-label">Description</label>
                <input type="text" name="description" class="glass-input" placeholder="Detailed product specifications, usage instructions..." required>
            </div>

            <div>
                <label class="field-label">Price (₹ INR)</label>
                <input type="text" name="price" class="glass-input" placeholder="e.g. 850.00" required>
            </div>

            <div>
                <label class="field-label">Pack Quantity</label>
                <input type="number" step="0.1" name="quantityValue" class="glass-input" placeholder="e.g. 1, 5, 500" required>
            </div>

            <div>
                <label class="field-label">Measurement Unit</label>
                <select name="unit" class="glass-input" required>
                    <option value="KG">KG (Kilogram)</option>
                    <option value="Gram">Gram</option>
                    <option value="Litre">Litre</option>
                    <option value="ML">ML (Millilitre)</option>
                </select>
            </div>

            <div>
                <label class="field-label">Available Stock</label>
                <input type="text" name="stock" class="glass-input" placeholder="Units in inventory" required>
            </div>

            <div>
                <label class="field-label">Category</label>
                <input type="text" name="category" class="glass-input" placeholder="e.g. Fertilizer, Seeds, Pesticides" required>
            </div>

            <div>
                <label class="field-label">Manufacturer / Brand</label>
                <input type="text" name="manufacturer" class="glass-input" placeholder="e.g. IFFCO, Bayer, Syngenta" required>
            </div>

            <div class="col-span-2">
                <label class="field-label">Product Image</label>
                <div class="file-upload-box">
                    <i class="fa-solid fa-cloud-arrow-up" style="font-size: 1.75rem; color: #38bdf8; margin-bottom: 0.5rem; display: block;"></i>
                    <span style="font-size: 0.85rem; color: #e0f2fe; display: block; margin-bottom: 0.5rem;">Select image file (.jpg, .png)</span>
                    <input type="file" name="image" style="background: rgba(255,255,255,0.9); padding: 0.4rem; border-radius: 8px; color: #0f172a; width: 100%; font-size: 0.85rem;" required>
                </div>
            </div>

        </div>

        <button type="submit" class="btn-submit">
            <i class="fa-solid fa-plus-circle"></i> Save & Publish Product
        </button>

    </form>

    <div style="text-align: center; margin-top: 1.5rem; padding-top: 1.25rem; border-top: 1px solid rgba(255, 255, 255, 0.15); font-size: 0.9rem;">
        <a href="vendorDashboard.jsp" style="color: #38bdf8; text-decoration: none; font-weight: 600; display: inline-flex; align-items: center; gap: 0.4rem;">
            <i class="fa-solid fa-arrow-left"></i> Return to Vendor Dashboard
        </a>
    </div>

</div>

</body>
</html>