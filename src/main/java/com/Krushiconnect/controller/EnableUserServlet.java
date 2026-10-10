package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.model.User;
import com.Krushiconnect.util.DBConnection;

@WebServlet("/enableUser")
public class EnableUserServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {

            HttpSession session = request.getSession();
            User currentUser = (User) session.getAttribute("user");

            // 🔐 Only ADMIN
            if (currentUser == null || !currentUser.getRole().equalsIgnoreCase("ADMIN")) {
                response.sendRedirect("login.jsp");
                return;
            }

            int userId = Integer.parseInt(request.getParameter("userId"));

            Connection conn = DBConnection.getConnection();

            String sql = "UPDATE users SET status='ACTIVE' WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, userId);

            ps.executeUpdate();

            response.sendRedirect("viewUsers.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("❌ Error enabling user");
        }
    }
}