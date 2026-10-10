package com.Krushiconnect.controller;

import com.Krushiconnect.ai.MandiAIService;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/mandi-recommendation")
public class MandiRecommendationServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/mandiRecommendation.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String crop = request.getParameter("crop");
        String quantity = request.getParameter("quantity");
        String location = request.getParameter("location");

        if (crop == null || crop.trim().isEmpty()
                || quantity == null || quantity.trim().isEmpty()
                || location == null || location.trim().isEmpty()) {

            request.setAttribute(
                    "error",
                    "Please enter crop, quantity and farmer location.");

            request.getRequestDispatcher(
                    "/mandiRecommendation.jsp").forward(request, response);

            return;
        }

        try {

            double quantityValue = Double.parseDouble(quantity);

            if (quantityValue <= 0) {

                request.setAttribute(
                        "error",
                        "Quantity must be greater than 0.");

                request.getRequestDispatcher(
                        "/mandiRecommendation.jsp").forward(request, response);

                return;
            }

            String result = MandiAIService.getRecommendation(
                    crop,
                    quantity,
                    location);

            request.setAttribute("aiResult", result);

        } catch (NumberFormatException e) {

            request.setAttribute(
                    "error",
                    "Please enter a valid quantity.");

        } catch (Exception e) {

            e.printStackTrace();

            request.setAttribute(
                    "error",
                    "Unable to generate AI recommendation. "
                            + e.getMessage());
        }

        request.getRequestDispatcher(
                "/mandiRecommendation.jsp").forward(request, response);
    }
}