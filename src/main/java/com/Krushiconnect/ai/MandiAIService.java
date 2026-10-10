package com.Krushiconnect.ai;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;

public class MandiAIService {

    private static final String PYTHON = "C:\\Users\\NIRANJAN\\Desktop\\mandi-ai\\venv\\Scripts\\python.exe";

    private static final String BRIDGE = "C:\\Users\\NIRANJAN\\Desktop\\mandi-ai\\java_mandi_api.py";

    public static String getRecommendation(String crop,
            String quantity,
            String location) throws Exception {

        ProcessBuilder processBuilder = new ProcessBuilder(
                PYTHON,
                BRIDGE,
                crop,
                quantity,
                location);

        processBuilder.redirectErrorStream(true);

        Process process = processBuilder.start();

        StringBuilder output = new StringBuilder();

        BufferedReader reader = new BufferedReader(
                new InputStreamReader(
                        process.getInputStream(),
                        StandardCharsets.UTF_8));

        String line;

        while ((line = reader.readLine()) != null) {
            output.append(line).append("\n");
        }

        int exitCode = process.waitFor();

        if (exitCode != 0) {
            throw new Exception(
                    "AI process failed.\n" + output.toString());
        }

        String[] lines = output.toString().split("\\r?\\n");

        // The bridge prints the JSON result as the final line.
        for (int i = lines.length - 1; i >= 0; i--) {

            String currentLine = lines[i].trim();

            if (currentLine.startsWith("{")
                    && currentLine.endsWith("}")) {

                return currentLine;
            }
        }

        throw new Exception(
                "AI returned no valid JSON result.\n"
                        + output.toString());
    }
}