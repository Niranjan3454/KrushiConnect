<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.Krushiconnect.dao.ProductDAO, com.Krushiconnect.model.Product, com.Krushiconnect.model.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Agri Marketplace | KrushiConnect Products</title>

    <link rel="stylesheet" href="css/krushiconnect.css">

    <style>
        .filter-section {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            padding: 1.25rem 1.5rem;
            margin-bottom: 2rem;
            box-shadow: var(--shadow-sm);
        }

        .filter-form {
            display: flex;
            gap: 1rem;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input-box {
            flex: 1;
            min-width: 260px;
            position: relative;
        }

        .search-input-box i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        .search-field {
            width: 100%;
            padding: 0.75rem 1rem 0.75rem 2.75rem;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--slate-200);
            font-family: var(--font-body);
            font-size: 0.95rem;
            outline: none;
            transition: all var(--transition-fast);
        }

        .search-field:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px var(--primary-glow);
        }

        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 1.75rem;
        }

        .product-card {
            background: #ffffff;
            border-radius: var(--radius-lg);
            border: 1px solid var(--slate-200);
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all var(--transition-normal);
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
            border-color: #86efac;
        }

        .product-image-container {
            width: 100%;
            height: 200px;
            background: #f8fafc;
            overflow: hidden;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .product-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .product-card:hover .product-img {
            transform: scale(1.05);
        }

        .product-body {
            padding: 1.25rem;
            flex: 1;
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }

        .product-title {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--slate-900);
            line-height: 1.3;
        }

        .product-price {
            font-family: var(--font-heading);
            font-size: 1.45rem;
            font-weight: 800;
            color: #15803d;
        }

        .product-pack-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            background: #f1f5f9;
            color: var(--slate-700);
            padding: 0.25rem 0.65rem;
            border-radius: var(--radius-sm);
            font-size: 0.8rem;
            font-weight: 600;
            width: fit-content;
        }

        .product-desc {
            font-size: 0.875rem;
            color: var(--slate-600);
            line-height: 1.5;
            margin-top: 0.25rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .product-footer {
            padding: 1rem 1.25rem;
            background: var(--slate-50);
            border-top: 1px solid var(--slate-100);
        }

        .cart-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .qty-input {
            width: 65px;
            padding: 0.55rem;
            border-radius: var(--radius-sm);
            border: 1.5px solid var(--slate-300);
            font-size: 0.95rem;
            font-weight: 700;
            text-align: center;
            outline: none;
        }

        .qty-input:focus {
            border-color: var(--primary);
        }
    </style>
</head>

<body>

<%
    User user = (User) session.getAttribute("user");

    String search = request.getParameter("search");
    String categoryFilter = request.getParameter("category");
    String added = request.getParameter("added");

    if(search == null) search = "";
    if(categoryFilter == null) categoryFilter = "";

    ProductDAO dao = new ProductDAO();
    List<Product> list;

    if(user != null && user.getRole().equalsIgnoreCase("VENDOR")){
        list = dao.getProductsByVendor(user.getUserId());
    } else {
        list = dao.getAllProducts();
    }

    Set<String> categories = new HashSet<>();
    for(Product temp : list){
        if(temp.getCategory() != null){
            categories.add(temp.getCategory());
        }
    }
%>

<!-- 🔥 TOP NAVBAR -->
<div class="kc-navbar <%= (user != null && user.getRole().equalsIgnoreCase("VENDOR")) ? "navbar-vendor" : "navbar-farmer" %>">
    <div class="kc-brand">
        <div class="kc-brand-icon">🌱</div>
        <span>KrushiConnect <span style="font-size: 0.85rem; font-weight: 500; opacity: 0.9;">| Marketplace</span></span>
    </div>

    <div style="display: flex; align-items: center; gap: 1rem;">
        <% if(user != null && user.getRole().equalsIgnoreCase("FARMER")){ %>
            <a href="cart.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
                <i class="fa-solid fa-cart-shopping"></i> My Cart
            </a>
        <% } %>

        <div class="back-btn">
            <%
                if(user != null){
                    if(user.getRole().equalsIgnoreCase("FARMER")){
            %>
                        <a href="farmerDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
                            <i class="fa-solid fa-arrow-left"></i> Dashboard
                        </a>
            <%
                    } else if(user.getRole().equalsIgnoreCase("VENDOR")){
            %>
                        <a href="vendorDashboard.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
                            <i class="fa-solid fa-arrow-left"></i> Dashboard
                        </a>
            <%
                    }
                } else {
            %>
                <a href="login.jsp" class="kc-btn kc-btn-outline-white kc-btn-sm" style="border-radius: var(--radius-full);">
                    <i class="fa-solid fa-right-to-bracket"></i> Login
                </a>
            <% } %>
        </div>
    </div>
</div>

<div class="kc-container">

    <!-- PAGE HEADER -->
    <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
        <div>
            <h1 style="font-size: 1.85rem; font-weight: 800; color: var(--slate-900);">
                <%= (user != null && user.getRole().equalsIgnoreCase("VENDOR")) ? "🏪 Your Listed Products" : "🌱 Agricultural Products Catalog" %>
            </h1>
            <p style="color: var(--slate-500); font-size: 0.95rem;">High-yield seeds, fertilizers, crop nutrients & farm inputs</p>
        </div>

        <% if(user != null && user.getRole().equalsIgnoreCase("VENDOR")){ %>
            <a href="addProduct.jsp" class="kc-btn kc-btn-secondary">
                <i class="fa-solid fa-plus"></i> Add New Product
            </a>
        <% } %>
    </div>

    <!-- SUCCESS ALERT (UNCHANGED LOGIC) -->
    <% if("true".equals(added)){ %>
        <div style="background: #dcfce7; border: 1.5px solid #86efac; color: #166534; padding: 1rem 1.25rem; border-radius: var(--radius-md); margin-bottom: 1.5rem; display: flex; align-items: center; justify-content: space-between; font-weight: 600; box-shadow: var(--shadow-sm);">
            <div style="display: flex; align-items: center; gap: 0.75rem;">
                <i class="fa-solid fa-circle-check" style="font-size: 1.25rem; color: #16a34a;"></i>
                <span>Product added to your cart successfully!</span>
            </div>
            <a href="cart.jsp" class="kc-btn kc-btn-primary kc-btn-sm">
                View Cart & Checkout <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>
    <% } %>

    <!-- FILTER / SEARCH TOOLBAR (UNCHANGED LOGIC) -->
    <div class="filter-section">
        <form method="get" class="filter-form">
            <div class="search-input-box">
                <i class="fa-solid fa-magnifying-glass"></i>
                <input type="text"
                       name="search"
                       class="search-field"
                       placeholder="Search fertilizers, seeds, chemicals..."
                       value="<%= search %>">
            </div>

            <select name="category" class="kc-select" style="width: auto; min-width: 180px; padding: 0.75rem 1rem;">
                <option value="">All Categories</option>
                <% for(String cat : categories){ %>
                    <option value="<%= cat %>" <%= categoryFilter.equalsIgnoreCase(cat) ? "selected" : "" %>>
                        <%= cat %>
                    </option>
                <% } %>
            </select>

            <button type="submit" class="kc-btn kc-btn-primary" style="padding: 0.75rem 1.5rem;">
                <i class="fa-solid fa-filter"></i> Apply Filter
            </button>

            <% if(!search.isEmpty() || !categoryFilter.isEmpty()){ %>
                <a href="viewProducts.jsp" class="kc-btn kc-btn-outline" style="padding: 0.75rem 1rem;">
                    Reset
                </a>
            <% } %>
        </form>
    </div>

    <!-- PRODUCTS GRID (UNCHANGED FILTERING & CARDS LOGIC) -->
    <div class="products-grid">
    <%
        int visibleCount = 0;
        for(Product p : list){
            boolean matchesSearch = search.isEmpty() || p.getName().toLowerCase().contains(search.toLowerCase());
            boolean matchesCategory = categoryFilter.isEmpty() || p.getCategory().equalsIgnoreCase(categoryFilter);
            String status = p.getStatus();
            boolean visibleToFarmer = status != null && status.equalsIgnoreCase("ACTIVE");
            boolean visibleToVendor = true;

            if(matchesSearch && matchesCategory && (
                (user != null && user.getRole().equalsIgnoreCase("VENDOR") && visibleToVendor) ||
                ((user == null || user.getRole().equalsIgnoreCase("FARMER")) && visibleToFarmer)
            )){
                visibleCount++;
    %>
        <div class="product-card">
            <div>
                <div class="product-image-container">
                    <img src="<%= request.getContextPath() + "/" + p.getImagePath() %>"
                         class="product-img"
                         alt="<%= p.getName() %>"
                         onerror="this.src='https://images.unsplash.com/photo-1592417817098-8f3d69106093?auto=format&fit=crop&w=400&q=80';">
                </div>

                <div class="product-body">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; gap: 0.5rem;">
                        <h3 class="product-title"><%= p.getName() %></h3>
                    </div>

                    <div class="product-price">₹ <%= p.getPrice() %></div>

                    <div class="product-pack-badge">
                        <i class="fa-solid fa-box-archive" style="color: #64748b;"></i>
                        Pack: <strong><%= p.getQuantityValue() %> <%= p.getUnit() %></strong>
                    </div>

                    <p class="product-desc"><%= p.getDescription() %></p>

                    <div style="font-size: 0.8rem; color: #64748b; margin-top: auto;">
                        <i class="fa-solid fa-industry" style="margin-right: 4px;"></i>
                        Company: <strong><%= p.getManufacturer() != null ? p.getManufacturer() : "N/A" %></strong>
                    </div>

                    <!-- VENDOR STATUS BADGE -->
                    <% if(user != null && user.getRole().equalsIgnoreCase("VENDOR")){ %>
                        <div style="margin-top: 0.5rem;">
                            <% if(status != null && status.equalsIgnoreCase("ACTIVE")){ %>
                                <span class="kc-badge badge-active">
                                    <span class="kc-badge-dot"></span> ACTIVE (LISTED)
                                </span>
                            <% } else { %>
                                <span class="kc-badge badge-inactive">
                                    <span class="kc-badge-dot"></span> DISABLED BY ADMIN
                                </span>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            </div>

            <!-- FARMER ADD TO CART FORM (UNCHANGED LOGIC) -->
            <% if(user != null && user.getRole().equalsIgnoreCase("FARMER")){ %>
                <div class="product-footer">
                    <form action="addToCart" method="post" class="cart-row">
                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                        <input type="hidden" name="name" value="<%= p.getName() %>">
                        <input type="hidden" name="price" value="<%= p.getPrice() %>">

                        <span style="font-size: 0.85rem; font-weight: 600; color: var(--slate-600);">Qty:</span>
                        <input type="number" name="quantity" value="1" min="1" class="qty-input">

                        <button type="submit" class="kc-btn kc-btn-primary kc-btn-sm" style="flex: 1; padding: 0.65rem 1rem;">
                            <i class="fa-solid fa-cart-plus"></i> Add to Cart
                        </button>
                    </form>
                </div>
            <% } %>
        </div>
    <%
            }
        }
        if(visibleCount == 0){
    %>
        <div style="grid-column: 1 / -1; padding: 4rem 1.5rem; text-align: center; background: #ffffff; border-radius: var(--radius-lg); border: 1px solid var(--slate-200);">
            <i class="fa-solid fa-box-open" style="font-size: 3.5rem; color: #cbd5e1; margin-bottom: 1rem; display: block;"></i>
            <h3 style="font-size: 1.25rem; font-weight: 700; color: var(--slate-800);">No Matching Products Found</h3>
            <p style="color: var(--slate-500); font-size: 0.9rem; margin-top: 0.35rem;">Try adjusting your keyword or select a different category filter.</p>
        </div>
    <% } %>
    </div>

</div>

</body>
</html>