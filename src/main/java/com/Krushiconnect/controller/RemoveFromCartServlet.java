package com.Krushiconnect.controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.model.CartItem;

@WebServlet("/removeFromCart")
public class RemoveFromCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession();

        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        int productId = Integer.parseInt(request.getParameter("productId"));

        if (cart != null) {
            cart.removeIf(item -> item.getProductId() == productId);
        }

        session.setAttribute("cart", cart);

        response.sendRedirect("cart.jsp");
    }
}