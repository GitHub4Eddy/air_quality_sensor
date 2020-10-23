# air_quality_sensor

This QuickApp reads the PM2.5, PM10, Temperature and Humidity values directly from a sensor. With this sensor you can measure air quality yourself. This QuickApp will send notifications when PM2.5 or PM10 readings reach a breakpoint.


Changes version 0.5 (23rd October 2020)
· With the new firmware and API function, solved a small bug in presenting WiFi dBm
· Changed humidity and air pressure values to zero decimals
· Added air pressure unit text "hPa"
· Changed the master device to "Generic Device" 
· Added QuickApp Variable for user defined icon master device
· Solved a bug preventing creation of QuickApp Variable bme280Sensor
   
Changes version 0.4 (17th October 2020)
· Added support for BME280 sensor (temperature, humidity and air pressure)
· Added QuickApp Variable bme280Sensor (true or false) to indicate the pressence of a BME280 sensor otherwise a DHT22 sensor is assumed
· Reduced the amount of labels, now only one label
· Removed the firmware version from the log under the icon
   
Changes version 0.3 (16th August 2020) 
· Error message instead of debug message in case of an error 
· Changed method of adding QuickApp variables, so they can be edited 
· Added network error to log (under icon)

Changes version 0.2 (15th July 2020): 
· Changed label6 from "age" to time of the measurement 
· Added automatic creation of child devices for Temperature, Humidity, PM2.5 and PM10 (with great help from @jgab from forum.fibaro.com) 
· Added the value (Temperature, Humidity, PM2.5 and PM10) to the child devices, This can be used in, for instance, extra scenes and shows in the mobile app and dashboard. 
· Added a short text of the air quality (GOOD, SATISFACTORY, etc.) to the icons in the dashboard (with great help of @petergebruers and @10der from forum.fibaro.com) 
· Added the trend (up, down, equal) to the short text of the air quality

My configuration of the DIY air quality sensor: 
· Nova SDS011 air quality sensor 
· NodeMCU ESP8266 V2 opensource WiFi board 
· BME280 temperature, humidity and pressure sensor

See also https://luftdaten.info 
See also https://sensor.community/en/sensors/airrohr/ how to simply build the air quality sensor yourself 
See also for map of measurements: https://sensor.community/en/ 
See also for CVS files: https://archive.luftdaten.info See also https://github.com/opendata-stuttgart/

Variables (mandatory): IPaddress = [IP address of your sensor] Path = [Path behind the IP address, normally /data.json] Interval = [Number in seconds, the sensor normally is updated every 145 seconds] UserID = [User id to notify of PM2.5 / PM10 breakpoints]

PM2.5 breakpoints 0 - 30 GOOD (Minimal) 
31 - 60 SATISFACTORY (Minor breathing discomfort to sensitive people) 
61 - 90 MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children 
91 - 120 POOR (Breathing discomfort to all) 
121 - 250 VERY POOR (Respiratory illness on prolonged exposure) 
250+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)

PM10 breakpoints 0 - 50 GOOD (Minimal) 
51 - 100 SATISFACTORY (Minor breathing discomport to sensitive people) 
101 - 250 MODERATELY POLLUTED Breathing discomfoort to asthma patients, elderly and children 
251 - 350 POOR (Breathing discomfort to all) 
351 - 430 VERY POOR (Respiratory illness on prolonged exposure) 
430+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
