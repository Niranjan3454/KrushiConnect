package com.Krushiconnect.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.Krushiconnect.dao.ProductDAO;
import com.Krushiconnect.model.Product;

@WebServlet("/addProduct")
@MultipartConfig

public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        com.Krushiconnect.model.User user =
                (com.Krushiconnect.model.User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int vendorId = user.getUserId();

        String name = request.getParameter("name");
        String description = request.getParameter("description");

        double price = Double.parseDouble(request.getParameter("price"));

        double quantityValue =
                Double.parseDouble(request.getParameter("quantityValue"));

        String unit = request.getParameter("unit");

        int stock = Integer.parseInt(request.getParameter("stock"));

        String category = request.getParameter("category");
        String manufacturer = request.getParameter("manufacturer");

        Part filePart = request.getPart("image");

        String originalFileName = filePart.getSubmittedFileName();
        String fileName = System.currentTimeMillis() + "_" + originalFileName;

        // 🔥 SAVE DIRECTLY TO TOMCAT DEPLOYED FOLDER (works at runtime)
        String deployedPath =
            request.getServletContext().getRealPath("/images/products");

        File deployedDir = new File(deployedPath);
        if (!deployedDir.exists()) {
            deployedDir.mkdirs();
        }

        String savedFilePath = deployedPath + File.separator + fileName;
        filePart.write(savedFilePath);

        // 🔥 ALSO MIRROR TO SOURCE PROJECT FOLDER (so it persists across redeploys)
        String sourcePath =
            "C:/Krushiconnect/src/main/webapp/images/products";

        File sourceDir = new File(sourcePath);
        if (!sourceDir.exists()) {
            sourceDir.mkdirs();
        }

        Files.copy(
            new File(savedFilePath).toPath(),
            new File(sourcePath + File.separator + fileName).toPath(),
            StandardCopyOption.REPLACE_EXISTING
        );

        String imagePath = "images/products/" + fileName;

        Product p = new Product();

        p.setVendorId(vendorId);
        p.setName(name);
        p.setDescription(description);
        p.setPrice(price);

        p.setQuantityValue(quantityValue);
        p.setUnit(unit);

        p.setStock(stock);
        p.setCategory(category);
        p.setManufacturer(manufacturer);
        p.setImagePath(imagePath);

        ProductDAO dao = new ProductDAO();

        if (dao.addProduct(p)) {
            response.sendRedirect("viewProducts.jsp?added=true");
        } else {
            response.sendRedirect("addProduct.jsp?error=true");
        }
    }
}