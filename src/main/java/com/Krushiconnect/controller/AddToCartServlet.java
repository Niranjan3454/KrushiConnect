package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.model.CartItem;
import com.Krushiconnect.model.User;
import com.Krushiconnect.util.DBConnection;

// 🔥 NEW IMPORT
import com.Krushiconnect.util.NotificationUtil;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int farmerId = user.getUserId();

        List<CartItem> cart =
                (List<CartItem>) session.getAttribute("cart");

        if (cart == null) {
            cart = new ArrayList<>();
        }

        int productId =
                Integer.parseInt(request.getParameter("productId"));

        String name = request.getParameter("name");

        double price =
                Double.parseDouble(request.getParameter("price"));

        int quantity =
                Integer.parseInt(request.getParameter("quantity"));

        // 🔹 SESSION CART
        boolean found = false;

        for (CartItem ci : cart) {

            if (ci.getProductId() == productId) {

                ci.setQuantity(
                        ci.getQuantity() + quantity);

                found = true;
                break;
            }
        }

        if (!found) {

            CartItem item = new CartItem();

            item.setProductId(productId);
            item.setName(name);
            item.setPrice(price);
            item.setQuantity(quantity);

            cart.add(item);
        }

        session.setAttribute("cart", cart);

        // 🔹 DATABASE CART
        try {

            Connection conn = DBConnection.getConnection();

            String checkSql =
                    "SELECT * FROM cart " +
                    "WHERE farmer_id=? AND product_id=?";

            PreparedStatement check =
                    conn.prepareStatement(checkSql);

            check.setInt(1, farmerId);
            check.setInt(2, productId);

            ResultSet rs = check.executeQuery();

            if (rs.next()) {

                String updateSql =
                        "UPDATE cart " +
                        "SET quantity = quantity + ? " +
                        "WHERE farmer_id=? AND product_id=?";

                PreparedStatement update =
                        conn.prepareStatement(updateSql);

                update.setInt(1, quantity);
                update.setInt(2, farmerId);
                update.setInt(3, productId);

                update.executeUpdate();

            } else {

                String insertSql =
                        "INSERT INTO cart" +
                        "(farmer_id, product_id, quantity) " +
                        "VALUES (?, ?, ?)";

                PreparedStatement insert =
                        conn.prepareStatement(insertSql);

                insert.setInt(1, farmerId);
                insert.setInt(2, productId);
                insert.setInt(3, quantity);

                insert.executeUpdate();
            }

            // 🔥 AUTO NOTIFICATION
            NotificationUtil.sendNotification(
                    farmerId,
                    "PRODUCT_ADDED",
                    productId
            );

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("viewProducts.jsp?added=true");
    }
}