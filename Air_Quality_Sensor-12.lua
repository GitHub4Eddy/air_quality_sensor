-- QUICKAPP AIR QUALITY SENSOR

-- This QuickApp reads the PM1, PM2.5, PM4, PM10, Temperature, Humidity and AirPressure values directly from a sensor. 
-- With this sensor you can measure air quality yourself. 
-- This QuickApp will send notifications when PM2.5 or PM10 readings reach a breakpoint. 

-- Changes version 1.2 (11th April 2021)
  -- Added support (child devices) for PM1 and PM4 levels (Plantower and Sensirion sensors)
  -- Added support for BMP280 sensor

-- Changes version 1.1 (31th Januari 2021)
   -- Added support for Plantower Air Quality Sensor (for now without PM1.0)
   -- Added Airpressuretext to log of Child Device Airpressure
   -- Added Quickapp variable for debug level (1=some, 2=few, 3=all). Recommended default value is 1.
   -- Removed QuickApp Variable bme280Sensor (no need for that anymore)
   -- Removed QuickApp Variable path (is now fixed)

-- Changes version 1.0 (23rd January 2021)
   -- Added Child Device for Absolute Humidity
   -- Added "Refresh" button

-- Changes version 0.5 (23rd October 2020)
   -- With the new firmware and API function, solved a small bug in presenting WiFi dBm
   -- Changed humidity and airpressure values to zero decimals
   -- Added airpressure unit text "hPa"
   -- Changed the master device to "Generic Device" 
   -- Added QuickApp Variable for user defined icon master device
   -- Solved a bug preventing creation of QuickApp Variable bme280Sensor

-- Changes version 0.4
   -- Added support for BME280 sensor (temperature, humidity and air pressure)
   -- Added QuickApp Variable bme280Sensor (true or false) to indicate the pressence of a BME280 sensor otherwise a DHT22 sensor is assumed
   -- Reduced the amount of labels, now only one label
   -- Removed the firmware version from the log under the icon

-- Changes version 0.3
   -- error message instead of debug message in case of an error
   -- Changed method of adding QuickApp variables, so they can be edited
   -- Added network error to log (under icon)

-- Changes version 0.2
   -- Changed label6 from "age" to time of the measurement
   -- Added automatic creation of child devices for Temperature, Humidity, PM2.5 and PM10 (with great help from @jgab from forum.fibaro.com)
   -- Added the value (Temperature, Humidity, PM2.5 and PM10) to the child devices, This can be used in, for instance, extra scenes and shows in the mobile app and dashboard. 
   -- Added a short text of the air quality (GOOD, SATISFACTORY, etc.) to the icons in the dashboard (with great help of @petergebruers and 10der from forum.fibaro.com)
   -- Added the trend (up, down, equal) to the sort text of the air quality

-- My configuration of the DIY air quality sensor:
   -- NodeMCU ESP8266 V2 opensource WiFi board
   -- Nova SDS011 or Sensirion SPS30 air quality sensor
   -- BME280 temperature, humidity and airpressure sensor

-- See also https://luftdaten.info
-- See also https://sensor.community/en/sensors/airrohr/ how to simply build the air quality sensor yourself
-- See also for map of measurements: https://sensor.community/en/
-- See also for CVS files: https://archive.luftdaten.info
-- See also https://github.com/opendata-stuttgart/

-- Variables (mandatory): 
   -- ipAddress = IP address of your sensor
   -- interval = Number in seconds, the sensor normally is updated every 145 seconds
   -- userID = User id to notify of PM2.5 / PM10 breakpoints
   -- icon = User defined icon number (add the icon via an other device and lookup the number)
   -- debugLevel = Number (1=some, 2=few, 3=all) (default = 1)

-- Absolute humidity is the measure of water vapor (moisture) in the air, regardless of temperature. It is expressed as grams of moisture per cubic meter of air (g/m3) 

-- PM2.5 breakpoints
   -- 0 - 30    GOOD (Minimal)
   -- 31 - 60   SATISFACTORY (Minor breathing discomfort to sensitive people)
   -- 61 - 90   MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
   -- 91 - 120  POOR (Breathing discomfort to all)
   -- 121 - 250 VERY POOR (Respiratory illness on prolonged exposure)
   -- 250+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)

-- PM10 breakpoints
   -- 0 - 50    GOOD (Minimal)
   -- 51 - 100  SATISFACTORY (Minor breathing discomport to sensitive people)
   -- 101 - 250 MODERATELY POLLUTED Breathing discomfoort to asthma patients, elderly and children
   -- 251 - 350 POOR (Breathing discomfort to all)
   -- 351 - 430 VERY POOR (Respiratory illness on prolonged exposure)
   -- 430+      SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)

-- Example json output SDS011 / BME280
-- {"software_version": "NRZ-2020-133", "age":"42", "sensordatavalues":[{"value_type":"SDS_P1","value":"23.85"},{"value_type":"SDS_P2","value":"12.93"},{"value_type":"BME280_temperature","value":"-2.94"},{"value_type":"BME280_pressure","value":"100731.91"},{"value_type":"BME280_humidity","value":"92.88"},{"value_type":"samples","value":"4952487"},{"value_type":"min_micro","value":"28"},{"value_type":"max_micro","value":"20074"},{"value_type":"interval","value":"145000"},{"value_type":"signal","value":"-76"}]}

-- Example json output Plantower / BME280
-- {"software_version": "NRZ-2020-133", "age":"143", "sensordatavalues":[{"value_type":"PMS_P0","value":"7.25"},{"value_type":"PMS_P1","value":"16.75"},{"value_type":"PMS_P2","value":"15.00"},{"value_type":"BME280_temperature","value":"25.32"},{"value_type":"BME280_pressure","value":"99718.44"},{"value_type":"BME280_humidity","value":"34.79"},{"value_type":"samples","value":"5062203"},{"value_type":"min_micro","value":"28"},{"value_type":"max_micro","value":"8816"},{"value_type":"interval","value":"145000"},{"value_type":"signal","value":"-61"}]}

-- Example json output Sensirion SPS30
-- {"software_version": "NRZ-2020-133", "age":"72", "sensordatavalues":[{"value_type":"SPS30_P0","value":"20.39"},{"value_type":"SPS30_P2","value":"23.44"},{"value_type":"SPS30_P4","value":"24.96"},{"value_type":"SPS30_P1","value":"25.27"},{"value_type":"SPS30_N05","value":"138.40"},{"value_type":"SPS30_N1","value":"160.18"},{"value_type":"SPS30_N25","value":"162.63"},{"value_type":"SPS30_N4","value":"163.13"},{"value_type":"SPS30_N10","value":"163.23"},{"value_type":"SPS30_TS","value":"0.66"},{"value_type":"samples","value":"4947724"},{"value_type":"min_micro","value":"28"},{"value_type":"max_micro","value":"6797"},{"value_type":"interval","value":"145000"},{"value_type":"signal","value":"-35"}]}

-- No editing of this code is needed 


class 'PolutionSensorTemp'(QuickAppChild)
function PolutionSensorTemp:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Temperature sensor initiated, deviceId:",self.id)
end
function PolutionSensorTemp:updateValue(data,userID) 
  --self:debug("Temperature: ",data.temperature)
  self:updateProperty("value",tonumber(data.temperature))
end

class 'PolutionSensorHumid'(QuickAppChild)
function PolutionSensorHumid:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Humidity sensor initiated, deviceId:",self.id)
end
function PolutionSensorHumid:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.humidity)) 
end

class 'PolutionSensorHumidAbs'(QuickAppChild)
function PolutionSensorHumidAbs:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Absolute Humidity sensor initiated, deviceId:",self.id)
end
function PolutionSensorHumidAbs:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.humidityabsolute)) 
  self:updateProperty("unit", "g/m³")
end

class 'PolutionSensorPressure'(QuickAppChild)
function PolutionSensorPressure:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Pressure sensor initiated, deviceId:",self.id)
end
function PolutionSensorPressure:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.airpressure)) 
  self:updateProperty("unit", "hPa")
  self:updateProperty("log", data.airpressuretext)
end

class 'PolutionSensorPM1'(QuickAppChild)
function PolutionSensorPM1:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality PM1 sensor initiated, deviceId:",self.id)
end
function PolutionSensorPM1:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.pm1)) 
  self:updateProperty("unit", "㎍/㎥")
end

class 'PolutionSensorPM4'(QuickAppChild)
function PolutionSensorPM4:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality PM4 sensor initiated, deviceId:",self.id)
end
function PolutionSensorPM4:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.pm4)) 
  self:updateProperty("unit", "㎍/㎥")
end

class 'PolutionSensorPM25'(QuickAppChild)
function PolutionSensorPM25:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality PM2.5 sensor initiated, deviceId:",self.id)
end

function PolutionSensorPM25:updateValue(data,userID)  

  local pm25,pm25prev = data.pm25,data.pm25prev

  -- Send notifications when PM2.5 level reach breakpoints 
  -- PM2.5 breakpoint 0 - 30 GOOD (Minimal)
  if (tonumber(pm25) > 0 and tonumber(pm25) <= 30) then
    pm25Text = "GOOD"
    if (pm25prev > 30) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level GOOD (Minimal)")
      self:debug("PM2.5 level GOOD (Minimal)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 31 - 60 SATISFACTORY (Minor breathing discomfort to sensitive people)
  if (tonumber(pm25) >= 31 and tonumber(pm25) <= 60) then
    pm25Text = "SATISFACTORY"
    if (pm25prev < 31 or pm25prev > 60) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level SATISFACTORY (Minor breathing discomfort to sensitive people)")
      self:debug("PM2.5 level SATISFACTORY (Minor breathing discomfort to sensitive people)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 61 - 90 MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
  if (tonumber(pm25) >= 61 and tonumber(pm25) <= 90) then
    pm25Text = "MODERATELY POLLUTED"
    if (pm25prev < 61 or pm25prev > 90) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children")
      self:debug("PM2.5 level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children",pm25 .." µg/m³")
    end 
  end
  -- PM2.5 breakpoint 91 - 120 POOR (Breathing discomfort to all)
  if (tonumber(pm25) >= 91 and tonumber(pm25) <= 120) then
    pm25Text = "POOR"
    if (pm25prev < 91 or pm25prev > 120) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level POOR (Breathing discomfort to all)")
      self:debug("PM2.5 level POOR (Breathing discomfort to all)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 120 - 250 VERY POOR (Respiratory illness on prolonged exposure)
  if (tonumber(pm25) >= 120 and tonumber(pm25) <= 250) then
    pm25Text = "VERY POOR"
    if (pm25prev < 121 or pm25prev > 250) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level VERY POOR (Respiratory illness on prolonged exposure)")
      self:debug("PM2.5 level VERY POOR (Respiratory illness on prolonged exposure)",pm25 .." µg/m³")
    end
  end
  -- PM2.5 breakpoint 250+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
  if (tonumber(pm25) >= 250 ) then
    pm25Text = "SEVERE"
    if (pm25prev < 250) then
      fibaro.alert("push", {userID}, "PM2.5 "..pm25 .." µg/m³" .." level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)")
      self:debug("PM2.5 level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm25 .." µg/m³")
    end
  end

  if tonumber(pm25) > tonumber(pm25prev) then
    pm25Trend = " ↑"
  elseif tonumber(pm25) < tonumber(pm25prev) then
    pm25Trend = " ↓"
  else
    pm25Trend = " ="
  end 

  -- Update properties for PM2.5 sensor
  self:updateProperty("value", tonumber(pm25)) 
  self:updateProperty("unit", "㎍/㎥")
  self:updateProperty("log", pm25Text ..pm25Trend)
end

class 'PolutionSensorPM10'(QuickAppChild)
function PolutionSensorPM10:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality PM10 sensor initiated, deviceId:",self.id)
end

function PolutionSensorPM10:updateValue(data,userID) 
  local pm10,pm10prev = data.pm10,data.pm10prev

  -- Send notifications when PM10 level reach breakpoints 
  -- PM10 breakpoint 0 - 50 GOOD (Minimal)
  if (tonumber(pm10) > 0 and tonumber(pm10) <= 50) then
    pm10Text = "GOOD"
    if (pm10prev > 50) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level GOOD (Minimal)")
      self:debug("PM10 level GOOD (Minimal)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 51 - 100 SATISFACTORY (Minor breathing discomfort to sensitive people)
  if (tonumber(pm10) >= 51 and tonumber(pm10) <= 100) then
    pm10Text = "SATISFACTORY"
    if (pm10prev < 51 or pm10prev > 100) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level SATISFACTORY (Minor breathing discomfort to sensitive people)")
      self:debug("PM10 level SATISFACTORY (Minor breathing discomfort to sensitive people)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 101 - 250 MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children
  if (tonumber(pm10) >= 101 and tonumber(pm10) <= 250) then
    pm10Text = "MODERATELY POLLUTED"
    if (pm10prev < 101 or pm10prev > 250) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children")
      self:debug("PM10 level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 251 - 350 POOR (Breathing discomfort to all)
  if (tonumber(pm10) >= 251 and tonumber(pm10) <= 350) then
    pm10Text = "POOR"
    if (pm10prev < 251 or pm10prev > 350) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level POOR (Breathing discomfort to all)")
      self:debug("PM10 level POOR (Breathing discomfort to all)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 351 - 430 VERY POOR (Respiratory illness on prolonged exposure)
  if (tonumber(pm10) >= 351 and tonumber(pm10) <= 439) then
    pm10Text = "VERY POOR"
    if (pm10prev < 351 or pm10prev > 430) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level VERY POOR (Respiratory illness on prolonged exposure)")
      self:debug("PM10 level VERY POOR (Respiratory illness on prolonged exposure)",pm10 .." µg/m³")
    end
  end
  -- PM10 breakpoint 430+ SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)
  if (tonumber(pm10) >= 439 ) then
    pm10Text = "SEVERE"
    if  (pm10prev < 430) then
      fibaro.alert("push", {userID}, "PM10 "..pm10 .." µg/m³" .." level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)")
      self:debug("PM10 level SEVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm10 .." µg/m³")
    end
  end

  if tonumber(pm10) > tonumber(pm10prev) then
    pm10Trend = " ↑"
  elseif tonumber(pm10) < tonumber(pm10prev) then
    pm10Trend = " ↓"
  else
    pm10Trend = " ="
  end

  -- Update properties for PM10 sensor
  self:updateProperty("value",tonumber(pm10)) 
  self:updateProperty("unit", "㎍/㎥")
  self:updateProperty("log", pm10Text ..pm10Trend)
end


-- QuickApp functions


local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


function QuickApp:logging(level,text) -- Logging function for debug
  if tonumber(debugLevel) >= tonumber(level) then 
      self:debug(text)
  end
end


function QuickApp:setPressuretext(text) -- Setup for airpressuretext
  self:logging(3,"setPressuretext")
  press = tonumber(text)
  if press < 974 then 
    return "Thunderstorms"
  elseif press < 990 then
    return "Stormy"
  elseif press < 1002 then
    return "Rain"
  elseif press < 1010 then
    return "Cloudy"
  elseif press < 1022 then
    return "Unstable"
  elseif press < 1035 then
    return "Stable"
  else
    return "Very dry"
  end
end


function QuickApp:button1Event()
  self:updateView("button1", "text", "Please wait...")
  self:getData()
  fibaro.setTimeout(5000, function() -- Pause for [timeout] seconds (default 5 seconds)
    self:updateView("button1", "text", "Refresh")
  end)
end


-- Calculate Absolute Humidity (based on Temperature, Relative Humidity and Airpressure)
function QuickApp:getHumidityAbs(hum,temp,press) -- Source from muhmuh at Fibaro forum
  self:logging(3,"getHumidityAbs")
  local EXP = 2.71828182845904523536028747135266249775724709369995
  local humidityAbs = 0.622 * hum/100 * (1.01325 * 10^(5.426651 - 2005.1 / (temp + 273.15) + 0.00013869 * ((temp + 273.15) * (temp + 273.15) - 293700) / (temp + 273.15) * (10^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) - 1) - 0.0044 * 10^((-0.0057148 * (374.11 - temp)^1.25))) + (((temp + 273.15) / 647.3) - 0.422) * (0.577 - ((temp + 273.15) / 647.3)) * EXP^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) * 0.00980665) / (press/1000 - hum/100 * (1.01325 * 10^(5.426651 - 2005.1 / (temp + 273.15) + 0.00013869 * ((temp + 273.15) * (temp + 273.15) - 293700) / (temp + 273.15) * (10^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) - 1) - 0.0044 * 10^((-0.0057148 * (374.11 - temp)^1.25))) + (((temp + 273.15) / 647.3) - 0.422) * (0.577 - ((temp + 273.15) / 647.3)) * EXP^(0.000000000011965 * ((temp + 273.15) * (temp + 273.15) - 293700) * ((temp + 273.15) * (temp + 273.15) - 293700)) * 0.00980665)) * press/1000 * 100000000 / ((temp + 273.15) * 287.1)
  self:logging(3,"Absolute humidty: " ..string.format("%.2f",humidityAbs))
  return string.format("%.2f",humidityAbs)
end


function QuickApp:updateProperties() -- Update properties
  self:logging(3,"updateProperties")
  self:updateProperty("log", os.date("%d-%m-%Y %X", os.time()-data.age) .."\nWiFi " ..data.wifisignal .."dBm")
end


function QuickApp:updateLabels() -- Update labels
  self:logging(3,"updateLabels")
  labelText = "Measurement: " ..os.date("%d-%m-%Y %X", os.time()-data.age) .."\n" .."\n"
  if data.pm1 ~= "0" then
    labelText = labelText .."PM1.0: " ..data.pm1 .." µg/m³" .."\n"
  end
  labelText = labelText .."PM2.5: " ..data.pm25 .." µg/m³" .."\n"
  if data.pm4 ~= "0" then
    labelText = labelText .."PM4.0: " ..data.pm4 .." µg/m³" .."\n"
  end
  labelText = labelText .."PM10: " ..data.pm10 .." µg/m³" .."\n"
  labelText = labelText .."Temperature: " ..data.temperature .." °C" .."\n"
  labelText = labelText .."Humidity: " ..data.humidity .." %" .."\n"
  labelText = labelText .."Absolute Humidity: " ..data.humidityabsolute .." g/m³" .."\n" 
  labelText = labelText .."Airpressure: " ..data.airpressure .." hPa (" ..data.airpressuretext ..")" .."\n" 
  labelText = labelText .."\n" .."WiFi signal: " ..data.wifisignal .." dBm" .."\n"
  labelText = labelText .."Firmware version:  " ..data.firmware 
  self:logging(2,"labelText: " ..labelText)
  self:updateView("label1", "text", labelText)
end


function QuickApp:getValues() -- Get the values
  self:logging(3,"getValues")
  local n = 19
  for i=1,n do

    --PM1 level
    if jsonTable.sensordatavalues[i].value_type == "PMS_P0" or jsonTable.sensordatavalues[i].value_type == "SPS30_P0" then
      data.pm1 = jsonTable.sensordatavalues[i].value

    -- PM2.5 level    
    elseif jsonTable.sensordatavalues[i].value_type == "SDS_P2" or jsonTable.sensordatavalues[i].value_type == "PMS_P2" or jsonTable.sensordatavalues[i].value_type == "SPS30_P2" then
      data.pm25 = jsonTable.sensordatavalues[i].value

    -- PM4 level
    elseif jsonTable.sensordatavalues[i].value_type == "SPS30_P4" then
      data.pm4 = jsonTable.sensordatavalues[i].value

    -- PM10 level
    elseif jsonTable.sensordatavalues[i].value_type == "SDS_P1" or jsonTable.sensordatavalues[i].value_type == "PMS_P1" or jsonTable.sensordatavalues[i].value_type == "SPS30_P1" then
      data.pm10 = jsonTable.sensordatavalues[i].value

    -- Temperature value
    elseif jsonTable.sensordatavalues[i].value_type == "BME280_temperature" or jsonTable.sensordatavalues[i].value_type == "temperature" or jsonTable.sensordatavalues[i].value_type == "BMP280_temperature" or jsonTable.sensordatavalues[i].value_type == "BMP_temperature" then
      data.temperature = jsonTable.sensordatavalues[i].value

    -- Humidity value
    elseif jsonTable.sensordatavalues[i].value_type == "BME280_humidity" or jsonTable.sensordatavalues[i].value_type == "humidity" or jsonTable.sensordatavalues[i].value_type == "BMP280_humidity" or jsonTable.sensordatavalues[i].value_type == "BMP_humidity" then
      data.humidity = string.format("%.0f",tonumber(jsonTable.sensordatavalues[i].value))

    -- Air Presssure
    elseif jsonTable.sensordatavalues[i].value_type == "BME280_pressure" or jsonTable.sensordatavalues[i].value_type == "pressure" or jsonTable.sensordatavalues[i].value_type == "BMP280_pressure" or jsonTable.sensordatavalues[i].value_type == "BMP_pressure" then
      data.airpressure = string.format("%.0f",tonumber(jsonTable.sensordatavalues[i].value)/100)

    -- WiFi signal
    elseif jsonTable.sensordatavalues[i].value_type == "signal" then
      data.wifisignal = jsonTable.sensordatavalues[i].value

      self:logging(3,"Values: PM1" ..data.pm1 .." PM25: " ..data.pm25 .." PM4: " ..data.pm4 .." PM10: " ..data.pm10 .." Temp: " ..data.temperature .." Hum: " ..data.humidity .." Press: " ..data.airpressure)

      -- Serveral other values
      data.age = jsonTable.age
      data.firmware = jsonTable.software_version
      data.humidityabsolute = self:getHumidityAbs(data.humidity,data.temperature,data.airpressure) -- Calculate Absolute Humidity
      data.airpressuretext = self:setPressuretext(data.airpressure) -- Setup airpressuretext
      return
    end
  end
end


function QuickApp:getData()
  self:logging(3,"Start getData")
  self:logging(2,"URL: " ..url)
  http:request(url, {
    options={headers = {Accept = "application/json"},method = 'GET'},   
      success = function(response)
        self:logging(3,"response status: " ..response.status)
        self:logging(3,"headers: " ..response.headers["Content-Type"])
        self:logging(2,"Response data: " ..response.data)

        if response.data == nil or response.data == "" or response.data == "[]" then -- Check for empty result
          self:warning("Temporarily no data from Air Quality Sensor")
          self:logging(3,"SetTimeout " ..interval .." seconds")
          fibaro.setTimeout(interval*1000, function() 
            self:getdata()
          end)
        end
        
        jsonTable = json.decode(response.data) -- JSON decode from api to lua-table

        self:getValues()
        self:updateLabels()
        self:updateProperties()
 
        data.pm25prev=pm25prev
        data.pm10prev=pm10prev

        for id,child in pairs(self.childDevices) do 
          child:updateValue(data,userID) 
        end

        pm25prev = tonumber(data.pm25)
        pm10prev = tonumber(data.pm10)

      end,
      error = function(error)
        self:error("error: " ..json.encode(error))
        self:updateProperty("log", "error: " ..json.encode(error))
      end
    }) 
  
  self:logging(3,"SetTimeout " ..interval .." seconds")
  fibaro.setTimeout(interval*1000, function() 
     self:getData()
  end)
end


function QuickApp:createVariables() -- Create all Variables 
  httpTimeout = 5 -- Default value for http Timeout
  pm25prev,pm10prev = 0,0
  pm10Text,pm25Text,pm25Trend,pm10Trend = "","","",""
  data = {}
  data.pm1 = "0"
  data.pm25 = "0"
  data.pm4 = "0"
  data.pm10 = "0"
  data.temperature = "21"
  data.humidity = "50"
  data.airpressure = "1013"
  data.wifisignal = "0"
  data.age = "0"
  data.firmware = ""
  data.humidityabsolute = "0"
  data.airpressuretext = ""
end


function QuickApp:getQuickAppVariables() -- Get all Quickapp Variables or create them
  local ipAddress = self:getVariable("ipAddress")
  local path = "/data.json" -- Default path is /data.json
  interval = tonumber(self:getVariable("interval")) 
  userID = tonumber(self:getVariable("userID")) 
  debugLevel = tonumber(self:getVariable("debugLevel"))
  local icon = tonumber(self:getVariable("icon")) 

  -- Check existence of the mandatory variables, if not, create them with default values
  if ipAddress == "" or ipAddress == nil then
    ipAddress = "192.168.4.1" -- Default IP address is 192.168.4.1
    self:setVariable("ipAddress",ipAddress)
    self:trace("Added QuickApp variable ipAddress")
  end
  if interval == "" or interval == nil then
    interval = "146" -- Default interval is 146, normally the sensor renews its readings every 145 seconds 
    self:setVariable("interval",interval)
    self:trace("Added QuickApp variable interval")
    interval = tonumber(interval)
  end
  if userID == "" or userID == nil then 
    userID = "2" -- Default userID
    self:setVariable("userID",userID)
    self:trace("Added QuickApp variable iserID")
    userID = tonumber(userID)
  end
  if debugLevel == "" or debugLevel == nil then
    debugLevel = "1" -- Default value for debugLevel
    self:setVariable("debugLevel",debugLevel)
    self:trace("Added QuickApp variable debugLevel")
    debugLevel = tonumber(debugLevel)
  end
  if icon == "" or icon == nil then 
    icon = "0" -- Default icon ID
    self:setVariable("icon",icon)
    self:trace("Added QuickApp variable icon")
    icon = tonumber(icon)
  end
  if icon ~= 0 then 
    self:updateProperty("deviceIcon", icon) -- set user defined icon 
  end
  url = "http://" ..ipAddress ..path
end


function QuickApp:setupChildDevices()
  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all Child Devices
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
      local initChildData = { 
        {className="PolutionSensorTemp", name="Temperature", type="com.fibaro.temperatureSensor", value=0, unit="°C"},
        {className="PolutionSensorHumid", name="Humidity", type="com.fibaro.humiditySensor", value=0, unit="%"},
        {className="PolutionSensorHumidAbs", name="Absolute Humidity", type="com.fibaro.multilevelSensor", value=0, unit="g/m³"},
        {className="PolutionSensorPressure", name="Airpressure", type="com.fibaro.multilevelSensor", value=0, unit="hPa"},
        {className="PolutionSensorPM1", name="PM1", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
        {className="PolutionSensorPM25", name="PM2.5", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
        {className="PolutionSensorPM4", name="PM4", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
        {className="PolutionSensorPM10", name="PM10", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
      }
    for _,c in ipairs(initChildData) do
      local child = self:createChildDevice(
        {name = c.name,
          type=c.type,
          value=c.value,
          unit=c.unit,
          initialInterfaces = {},
        },
        _G[c.className] -- Fetch class constructor from class name
      )
      child:setVariable("className",c.className)  -- Save class name so we know when we load it next time
    end   
  else 
    for _,child in ipairs(cdevs) do
      local className = getChildVariable(child,"className") -- Fetch child class name
      local childObject = _G[className](child) -- Create child object from the constructor name
      self.childDevices[child.id]=childObject
      childObject.parent = self -- Setup parent link to device controller 
    end
  end
end


function QuickApp:onInit()
  __TAG = fibaro.getName(plugin.mainDeviceId) .." ID:" ..plugin.mainDeviceId
  self:debug("onInit") 
  self:setupChildDevices()
  self:getQuickAppVariables() 
  self:createVariables()
  http = net.HTTPClient({timeout=httpTimeout*1000})
  self:getData()
end

--EOF