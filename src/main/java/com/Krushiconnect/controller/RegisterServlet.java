package com.Krushiconnect.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.Krushiconnect.dao.UserDAO;
import com.Krushiconnect.model.User;
import com.Krushiconnect.util.PasswordUtil;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = new User();

        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));

        String hashedPassword = PasswordUtil.hashPassword(request.getParameter("password"));
        user.setPassword(hashedPassword);

        user.setRole(request.getParameter("role"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));

        UserDAO dao = new UserDAO();

        if (dao.registerUser(user)) {
            response.sendRedirect("login.jsp");
        } else {
            response.getWriter().println("Registration Failed");
        }
    }
}