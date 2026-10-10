package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.dao.UserDAO;
import com.Krushiconnect.model.CartItem;
import com.Krushiconnect.model.User;
import com.Krushiconnect.util.DBConnection;
import com.Krushiconnect.util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = PasswordUtil.hashPassword(request.getParameter("password"));

        UserDAO dao = new UserDAO();
        User user = dao.loginUser(email, password);

        if (user != null) {

            // 🔥 BLOCK DISABLED USERS
            if(user.getStatus() != null &&
               user.getStatus().equalsIgnoreCase("INACTIVE")){

            	response.sendRedirect("login.jsp?error=disabled");
            	return;
            }

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            String role = user.getRole().trim().toUpperCase();
            String path = request.getContextPath();

            response.setContentType("text/html");

            if (role.equals("FARMER")) {

                try {
                    Connection conn = DBConnection.getConnection();

                    String sql = "SELECT c.product_id, c.quantity, p.name, p.price " +
                                 "FROM cart c JOIN products p ON c.product_id = p.product_id " +
                                 "WHERE c.farmer_id=?";

                    PreparedStatement ps = conn.prepareStatement(sql);
                    ps.setInt(1, user.getUserId());

                    ResultSet rs = ps.executeQuery();

                    List<CartItem> cart = new ArrayList<>();

                    while (rs.next()) {
                        CartItem item = new CartItem();
                        item.setProductId(rs.getInt("product_id"));
                        item.setName(rs.getString("name"));
                        item.setPrice(rs.getDouble("price"));
                        item.setQuantity(rs.getInt("quantity"));
                        cart.add(item);
                    }

                    session.setAttribute("cart", cart);

                } catch (Exception e) {
                    e.printStackTrace();
                }

                response.sendRedirect(path + "/farmerDashboard.jsp");
                return;

            } else if (role.equals("VENDOR")) {
                response.sendRedirect(path + "/vendorDashboard.jsp");
                return;

            } else if (role.equals("LABOUR")) {
                response.sendRedirect(path + "/labourDashboard.jsp");
                return;

            } else if (role.equals("DELIVERY")) {

                response.sendRedirect(path + "/deliveryDashboard.jsp");
                return;

            } else {
                response.sendRedirect(path + "/adminDashboard.jsp");
                return;
            }

        } else {
        	response.sendRedirect("login.jsp?error=invalid");
        }
    }
}