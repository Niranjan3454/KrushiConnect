package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.Krushiconnect.model.User;
import com.Krushiconnect.util.DBConnection;

@WebServlet("/addService")
public class AddServiceServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");

            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            int leaderId = user.getUserId();

            String serviceType = request.getParameter("serviceType");
            int teamSize = Integer.parseInt(request.getParameter("teamSize"));
            double price = Double.parseDouble(request.getParameter("price"));
            String description = request.getParameter("description");

            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO labour_services(leader_id, team_size, service_type, price_per_day, description) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, leaderId);
            ps.setInt(2, teamSize);
            ps.setString(3, serviceType);
            ps.setDouble(4, price);
            ps.setString(5, description);

            ps.executeUpdate();

            response.sendRedirect("labourDashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}