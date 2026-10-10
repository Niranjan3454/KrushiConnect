<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html>

    <head>

        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>AI Mandi Recommendation - KrushiConnect</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <style>
            body {
                background: #f4f7f5;
            }

            .header {
                background: linear-gradient(135deg, #198754, #146c43);
                color: white;
                padding: 35px 0;
            }

            .main-card {
                border: none;
                border-radius: 18px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            }

            .result-card {
                border: none;
                border-radius: 18px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
            }

            .result-box {
                border: 1px solid #dee2e6;
                border-radius: 12px;
                padding: 18px;
                height: 100%;
                background: white;
            }

            .label {
                color: #6c757d;
                font-size: 14px;
                margin-bottom: 5px;
            }

            .value {
                font-size: 18px;
                font-weight: 600;
            }

            .recommendation {
                font-size: 22px;
                font-weight: 700;
            }

            .btn-success {
                padding: 12px;
                font-weight: 600;
            }
        </style>

    </head>

    <body>


        <!-- HEADER -->

        <div class="header">

            <div class="container">

                <h2 class="fw-bold mb-2">
                    AI Mandi Recommendation
                </h2>

                <p class="mb-0">
                    Get a personalized mandi recommendation using
                    current market prices, ML prediction and transport cost.
                </p>

            </div>

        </div>


        <div class="container py-4">


            <!-- INPUT FORM -->

            <div class="card main-card p-4 mb-4">

                <h4 class="fw-bold mb-4">
                    Enter Farmer Details
                </h4>


                <form method="post" action="<%= request.getContextPath() %>/mandi-recommendation">


                    <div class="row g-3">


                        <!-- CROP -->

                        <div class="col-md-6">

                            <label class="form-label fw-semibold">
                                Select Crop
                            </label>

                            <select name="crop" class="form-select" required>

                                <option value="">
                                    -- Select Crop --
                                </option>

                                <option value="Arhar">
                                    Arhar
                                </option>

                                <option value="Black Gram">
                                    Black Gram
                                </option>

                                <option value="Cowpea">
                                    Cowpea
                                </option>

                                <option value="Green Gram">
                                    Green Gram
                                </option>

                                <option value="Green Peas">
                                    Green Peas
                                </option>

                                <option value="Lentil">
                                    Lentil
                                </option>

                                <option value="Maize">
                                    Maize
                                </option>

                                <option value="Rice">
                                    Rice
                                </option>

                                <option value="Soyabean">
                                    Soyabean
                                </option>

                                <option value="Wheat">
                                    Wheat
                                </option>

                            </select>

                        </div>


                        <!-- QUANTITY -->

                        <div class="col-md-6">

                            <label class="form-label fw-semibold">
                                Quantity (kg)
                            </label>

                            <input type="number" name="quantity" class="form-control" min="1" step="1"
                                placeholder="Example: 100" required>

                        </div>


                        <!-- LOCATION -->

                        <div class="col-12">

                            <label class="form-label fw-semibold">
                                Farm / Village / City Location
                            </label>

                            <input type="text" name="location" class="form-control" placeholder="Example: Kharadi, Pune"
                                required>

                            <div class="form-text">

                                Enter the farmer's actual location.
                                The system will calculate distance and estimated
                                transport cost to supported mandis.

                            </div>

                        </div>


                        <!-- BUTTON -->

                        <div class="col-12">

                            <button type="submit" class="btn btn-success w-100">

                                Generate AI Recommendation

                            </button>

                        </div>


                    </div>

                </form>

            </div>


            <% Object resultObject=request.getAttribute("aiResult"); if (resultObject !=null) { String
                json=resultObject.toString(); String success=extractJson(json, "success" ); if
                ("true".equalsIgnoreCase(success)) { String crop=extractJson(json, "crop" ); String
                quantity=extractJson(json, "quantity_kg" ); String farmerLocation=extractJson(json, "farmer_location" );
                String market=extractJson(json, "recommended_market" ); String distance=extractJson(json, "distance_km"
                ); String currentPrice=extractJson(json, "current_price" ); String
                predictedPrice=extractJson(json, "predicted_price" ); String
                transport=extractJson(json, "transport_cost" ); String
                predictedNet=extractJson(json, "predicted_net_realization" ); String
                advantage=extractJson(json, "advantage" ); String recommendation=extractJson(json, "recommendation" );
                String sellingSignal=extractJson(json, "selling_time_signal" ); %>


                <!-- RESULT -->

                <div class="card result-card p-4">


                    <div class="mb-4">

                        <h4 class="fw-bold mb-1">
                            AI Recommendation Result
                        </h4>

                        <p class="text-muted mb-0">
                            Personalized recommendation based on the
                            latest available mandi data.
                        </p>

                    </div>


                    <div class="row g-3">


                        <!-- CROP -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Crop
                                </div>

                                <div class="value">
                                    <%= crop %>
                                </div>

                            </div>

                        </div>


                        <!-- QUANTITY -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Quantity
                                </div>

                                <div class="value">
                                    <%= quantity %> kg
                                </div>

                            </div>

                        </div>


                        <!-- FARMER LOCATION -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Farmer Location
                                </div>

                                <div class="value">
                                    <%= farmerLocation %>
                                </div>

                            </div>

                        </div>


                        <!-- RECOMMENDED MARKET -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Recommended Mandi
                                </div>

                                <div class="value text-success">
                                    <%= market %>
                                </div>

                            </div>

                        </div>


                        <!-- DISTANCE -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Distance
                                </div>

                                <div class="value">
                                    <%= distance %> km
                                </div>

                            </div>

                        </div>


                        <!-- TRANSPORT -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Estimated Transport Cost
                                </div>

                                <div class="value">
                                    Rs. <%= transport %>
                                </div>

                            </div>

                        </div>


                        <!-- CURRENT PRICE -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Current Price
                                </div>

                                <div class="value">
                                    Rs. <%= currentPrice %> / quintal
                                </div>

                            </div>

                        </div>


                        <!-- PREDICTED PRICE -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Predicted Next Price
                                </div>

                                <div class="value">
                                    Rs. <%= predictedPrice %> / quintal
                                </div>

                            </div>

                        </div>


                        <!-- NET REALIZATION -->

                        <div class="col-md-4">

                            <div class="result-box">

                                <div class="label">
                                    Predicted Net Realization
                                </div>

                                <div class="value text-success">
                                    Rs. <%= predictedNet %>
                                </div>

                            </div>

                        </div>


                        <!-- ADVANTAGE -->

                        <div class="col-md-6">

                            <div class="result-box">

                                <div class="label">
                                    Advantage
                                </div>

                                <div class="value">

                                    <% if (advantage==null || advantage.trim().isEmpty() || "null"
                                        .equalsIgnoreCase(advantage.trim())) { %>

                                        No comparison available

                                        <% } else { %>

                                            Rs. <%= advantage %>

                                                <% } %>

                                </div>

                            </div>

                        </div>


                        <!-- SELLING SIGNAL -->

                        <div class="col-md-6">

                            <div class="result-box">

                                <div class="label">
                                    Selling-Time Signal
                                </div>

                                <div class="value">
                                    <%= sellingSignal %>
                                </div>

                            </div>

                        </div>


                    </div>


                    <!-- FINAL RECOMMENDATION -->

                    <div class="alert alert-success mt-4 mb-0">

                        <div class="label">
                            Selling Location Decision
                        </div>

                        <div class="recommendation">
                            <%= recommendation %>
                        </div>

                    </div>


                </div>


                <% } else { String error=extractJson(json, "error" ); String details=extractJson(json, "details" ); if
                    (error==null || error.trim().isEmpty()) { error="Unable to generate AI recommendation." ; } %>


                    <!-- ERROR -->

                    <div class="alert alert-danger">

                        <h5 class="fw-bold">
                            AI Recommendation Error
                        </h5>

                        <p>
                            <%= error %>
                        </p>

                        <% if (details !=null && !details.trim().isEmpty()) { %>

                            <hr>

                            <small>
                                <%= details %>
                            </small>

                            <% } %>

                    </div>


                    <% } } %>


        </div>


        <!-- JSON EXTRACTION FUNCTION -->

        <%! private String extractJson(String json, String key) { try { if (json==null || key==null) { return "" ; } /*
            * Create the JSON key without directly * writing quote characters in Java code. * * 34="
         */
        String quote =
            String.valueOf((char) 34);

        String search =
            quote + key + quote;


        int keyIndex =
            json.indexOf(search);

        if (keyIndex == -1) {
            return "";
        }


        /*
         * 58 = :
         */
        int colonIndex =
            json.indexOf(
                (char) 58,
                keyIndex
            );

        if (colonIndex == -1) {
            return "";
        }


        int start =
            colonIndex + 1;


        while (
            start < json.length()
            &&
            Character.isWhitespace(
                json.charAt(start)
            )
        ) {

            start++;

        }


        if (start >= json.length()) {
            return "";
        }


        /*
         * 34 = " */ if ( json.charAt(start)==(char) 34 ) { start++; StringBuilder value=new StringBuilder(); boolean
            escaped=false; for ( int i=start; i < json.length(); i++ ) { char c=json.charAt(i); /* * 92=backslash */ if
            (escaped) { /* * 110=n */ if (c==(char) 110) { value.append('\n'); } /* * 114=r */ else if (c==(char) 114) {
            value.append('\r'); } /* * 116=t */ else if (c==(char) 116) { value.append('\t'); } else { value.append(c);
            } escaped=false; } /* * Backslash */ else if (c==(char) 92) { escaped=true; } /* * Double quote */ else if
            (c==(char) 34) { break; } else { value.append(c); } } return value.toString(); } /* * Numeric / boolean
            value * * 44=comma * 125=} */ int end=start; while ( end < json.length() && json.charAt(end) !=(char) 44 &&
            json.charAt(end) !=(char) 125 ) { end++; } return json.substring( start, end ).trim(); } catch (Exception e)
            { return "" ; } } %>

    </body>

    </html>