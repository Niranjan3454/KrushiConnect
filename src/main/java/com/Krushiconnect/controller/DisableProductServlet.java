package com.Krushiconnect.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.Krushiconnect.util.DBConnection;

@WebServlet("/disableProduct")
public class DisableProductServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws IOException {

        try {

            int productId =
            Integer.parseInt(request.getParameter("productId"));

            Connection conn = DBConnection.getConnection();

            String sql =
            "UPDATE products SET status='INACTIVE' WHERE product_id=?";

            PreparedStatement ps =
            conn.prepareStatement(sql);

            ps.setInt(1, productId);

            ps.executeUpdate();

            response.sendRedirect("adminProducts.jsp");

        } catch (Exception e) {

            e.printStackTrace();

        }
    }
}