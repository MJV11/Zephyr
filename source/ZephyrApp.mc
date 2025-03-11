import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Communications;

class ZephyrApp extends WatchUi.DataField {
    private var windSpeed as String = "--";
    private var windDirection as String = "--";
    private var nextRain as String = "--";
    private var latitude as Numeric = 0;
    private var longitude as Numeric = 0;
    private var lastFetchTime as Number = 0;
    private var fetchInterval as Number = 900000; // 15 minutes in milliseconds

    function initialize() {
        DataField.initialize();
        System.println("initializing");
    }

    // This is called when the data field is shown and whenever data is updated
    function compute(info) {        
        try {
            // Check if we have position info in the Activity info
            if (info has :position && info.position != null) {
                var positionInfo = info.position;
                
                // Position format varies depending on the device
                if (positionInfo has :lat && positionInfo has :lon) {
                    // Use different property names to avoid confusion
                    self.latitude = positionInfo.lat;
                    self.longitude = positionInfo.lon;
                } else if (positionInfo has :toDegrees) {
                    // Format used by other devices
                    var degreePos = positionInfo.toDegrees();
                    if (degreePos instanceof Array && degreePos.size() >= 2) {
                        self.latitude = degreePos[0] as Float;
                        self.longitude = degreePos[1] as Float;
                    }
                } else if (positionInfo instanceof Array && positionInfo.size() >= 2) {
                    // Raw array format
                    self.latitude = positionInfo[0] as Float;
                    self.longitude = positionInfo[1] as Float;
                }
                
                // Check if we should fetch weather
                var currentTime = System.getTimer();
                if (self.latitude != null && self.longitude != null && 
                    (lastFetchTime == 0 || currentTime - lastFetchTime > fetchInterval)) {
                    fetchWeather();
                    lastFetchTime = currentTime;
                }
            }
        } catch(ex) {
            System.println("Exception in compute: " + ex.getErrorMessage());
        }
        
        return null;  // No direct value to return for a data field
    }

    function fetchWeather() {
        if (latitude == null || longitude == null) {
            System.println("No valid GPS location available");
            return;
        }

        var apiUrl = "https://api.openweathermap.org/data/2.5/weather?lat=" + latitude + "&lon=" + longitude + "&appid=b41de566500a5ee62781237dbe46f055&units=imperial";
        var options = {
            :method => Communications.HTTP_REQUEST_METHOD_GET,
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        // The Edge 530 expects a different callback signature
        Communications.makeWebRequest(apiUrl, null, options, method(:onWeatherResponse));
    }

    // Fixed callback signature - needs to match what Edge 530 expects
    function onWeatherResponse(responseCode as Number, data as Dictionary or String or Null) as Void {
        if (responseCode == 200 && data != null && data instanceof Dictionary) {
            try {
                var dataDictionary = data as Dictionary<String, Object>;
                
                if (dataDictionary.hasKey("wind") && dataDictionary.get("wind") instanceof Dictionary) {
                    var windData = dataDictionary.get("wind") as Dictionary<String, Object>;
                    
                    if (windData.hasKey("speed")) {
                        var speed = windData.get("speed") as Numeric;
                        windSpeed = speed.format("%.1f");
                    }
                    
                    if (windData.hasKey("deg")) {
                        var direction = windData.get("deg") as Numeric;
                        windDirection = direction.toString();
                    }
                }
                
                // Safely check if rain data exists
                if (dataDictionary.hasKey("rain") && dataDictionary.get("rain") instanceof Dictionary) {
                    var rainData = dataDictionary.get("rain") as Dictionary<String, Object>;
                    if (rainData.hasKey("1h")) {
                        var rainAmount = rainData.get("1h") as Numeric;
                        nextRain = rainAmount.toString() + " in";
                    }
                } else {
                    nextRain = "No rain";
                }

                WatchUi.requestUpdate();
            } catch (e) {
                System.println("Parse Error: " + e.getErrorMessage());
            }
        } else {
            System.println("Weather Request Failed: " + responseCode);
        }
    }


    // Add error callback
    function onWeatherError(error as Number) as Void {
        System.println("Weather Request Error: " + error);
        WatchUi.requestUpdate();
    }

    function onUpdate(dc) {
        // Call parent's onUpdate
        DataField.onUpdate(dc);
        
        // Get the field dimensions
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        // Set up the background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0, width, height);
        
        // Draw the weather data
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 10, Graphics.FONT_MEDIUM, "Wind: " + windSpeed + " mph", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 40, Graphics.FONT_MEDIUM, "Dir: " + windDirection + "°", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(width / 2, 70, Graphics.FONT_MEDIUM, "Rain: " + nextRain, Graphics.TEXT_JUSTIFY_CENTER);
    }
}