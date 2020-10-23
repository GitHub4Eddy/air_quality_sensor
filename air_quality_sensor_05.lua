-- QUICKAPP AIR QUALITY SENSOR

-- This QuickApp reads the PM2.5, PM10, Temperature, Humidity and Aur Pressure values directly from a sensor. 
-- With this sensor you can measure air quality yourself. 
-- This QuickApp will send notifications when PM2.5 or PM10 readings reach a breakpoint. 


-- Version 0.5 (23rd October 2020) 

-- Changes version 0.5
   -- With the new firmware and API function, solved a small bug in presenting WiFi dBm
   -- Changed humidity and air pressure values to zero decimals
   -- Added air pressure unit text "hPa"
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
   -- Nova SDS011 air quality sensor
   -- BME280 temperature, humidity and pressure sensor

-- See also https://luftdaten.info
-- See also https://sensor.community/en/sensors/airrohr/ how to simply build the air quality sensor yourself
-- See also for map of measurements: https://sensor.community/en/
-- See also for CVS files: https://archive.luftdaten.info
-- See also https://github.com/opendata-stuttgart/

-- Variables (mandatory): 
   -- ipAddress = IP address of your sensor
   -- path = Path behind the IP address, normally /data.json
   -- interval = Number in seconds, the sensor normally is updated every 145 seconds
   -- userID = User id to notify of PM2.5 / PM10 breakpoints
   -- bme280Sensor = true or false use of BME280 temperature, humidity and air pressure sensor
   -- icon = User defined icon number (add the icon via an other device and lookup the number)

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


-- No editing of this code is needed 

class 'PolutionSensorTemp'(QuickAppChild)
function PolutionSensorTemp:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Temperature sensor initiated, deviceId:",self.id)
end

function PolutionSensorTemp:updateValue(data,userID) 
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

class 'PolutionSensorPressure'(QuickAppChild)
function PolutionSensorPressure:__init(dev)
  QuickAppChild.__init(self,dev)
  --self:trace("Air Quality Pressure sensor initiated, deviceId:",self.id)
end

function PolutionSensorPressure:updateValue(data,userID) 
  self:updateProperty("value",tonumber(data.pressure)) 
  self:updateProperty("unit", "hPa")
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
      self:debug("PM2.5 level EVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm25 .." µg/m³")
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
      self:debug("PPM10 level MODERATELY POLLUTED Breathing discomfort to asthma patients, elderly and children",pm10 .." µg/m³")
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
      self:debug("PM10 level EVERE (Health impact even on light physical work. Serious impact on people with heart/lung disease)",pm10 .." µg/m³")
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

local function getChildVariable(child,varName)
  for _,v in ipairs(child.properties.quickAppVariables or {}) do
    if v.name==varName then return v.value end
  end
  return ""
end


function QuickApp:getQuickAppVariables()
  ipAddress = self:getVariable("ipAddress")
  path = self:getVariable("path")
  interval = tonumber(self:getVariable("interval")) 
  userID = tonumber(self:getVariable("userID")) 
  bme280Sensor = self:getVariable("bme280Sensor")
  icon = tonumber(self:getVariable("icon")) 

  -- Check existence of the mandatory variables, if not, create them with default values
  if ipAddress == "" or ipAddress == nil then
    ipAddress = "192.168.4.1" -- Default IP address is 192.168.4.1
    self:setVariable("ipAddress",ipAddress)
    self:trace("Added QuickApp variable ipAddress")
  end
  if path =="" or path == nil then
    path = "/data.json" -- Default path is /data.json
    self:setVariable("path",path)
    self:trace("Added QuickApp variable path")
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
  if bme280Sensor == "" or bme280Sensor == nil then 
    bme280Sensor = "true" -- Default bme280Sensor
    self:setVariable("bme280Sensor",bme280Sensor)
    self:trace("Added QuickApp variable bme280Sensor")
  end

  if bme280Sensor == "true" then 
    bme280Sensor = true 
  elseif bme280Sensor == "false" then 
    bme280Sensor = false
  end

  if icon == "" or icon == nil then 
    icon = "0" -- Default icon
    self:setVariable("icon",icon)
    self:trace("Added QuickApp variable icon")
    icon = tonumber(icon)
  end
end


function QuickApp:onInit()
  __TAG = "AIR_QUALITY_SENSOR_"..self.id
  self:debug("onInit") 
  self:getQuickAppVariables() 

  if icon ~= 0 then 
    self:updateProperty("deviceIcon", icon) -- set user defined icon
  end

  local cdevs = api.get("/devices?parentId="..self.id) or {} -- Pick up all Child Devices
  function self:initChildDevices() end -- Null function, else Fibaro calls it after onInit()...

  if #cdevs == 0 then -- If no Child Devices, create them
      local initChildData = { 
        {className="PolutionSensorTemp", name="AQ Temperature", type="com.fibaro.temperatureSensor", value=0, unit="°C"},
        {className="PolutionSensorHumid", name="AQ Humidity", type="com.fibaro.humiditySensor", value=0, unit="%"},
        {className="PolutionSensorPressure", name="AQ Pressure", type="com.fibaro.multilevelSensor", value=0, unit="hPa"},
        {className="PolutionSensorPM25", name="AQ PM2.5", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
        {className="PolutionSensorPM10", name="AQ PM10", type="com.fibaro.multilevelSensor", value=0, unit="µg/m³"},
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

-- Start of reading the data from the sensor
  local http = net.HTTPClient({timeout=5000})

  local pm25prev,pm10prev = 0,0
  local pm10Text,pm25Text,pm25Trend,pm10Trend = "","","",""
  local url = "http://" ..ipAddress ..path

  --self:debug("-------------- QUICKAPP AIR QUALITY SENSOR--------------")


  local function collectData()
    http:request(url, {
        options={
          headers = {
            Accept = "application/json"
          }, 
          method = 'GET'
        },        
        success = function(response)
          --self:debug("response status:", response.status) 
          --self:debug("headers:", response.headers["Content-Type"]) 
          local apiResult = response.data
          --self:debug("Api result: ",apiResult) 

          local jsonTable = json.decode(apiResult) -- JSON decode from api to lua-table
          local data  = {}

          -- Get the values
          data.pm10 = jsonTable.sensordatavalues[1].value
          data.pm25 = jsonTable.sensordatavalues[2].value
          data.temperature = jsonTable.sensordatavalues[3].value
          if bme280Sensor then 
            data.pressure = string.format("%.0f",tonumber(jsonTable.sensordatavalues[4].value)/100)
            data.humidity = string.format("%.0f",tonumber(jsonTable.sensordatavalues[5].value))
            data.wifisignal = jsonTable.sensordatavalues[10].value
          else
            data.humidity = string.format("%.0f",tonumber(jsonTable.sensordatavalues[4].value))
            data.wifisignal = jsonTable.sensordatavalues[9].value
          end
          data.age = jsonTable.age
          data.firmware = jsonTable.software_version

          -- Create labelText
          data.labelText = "Measurement: " ..os.date("%d-%m-%Y %X", os.time()-data.age) .."\n" .."\n"
          data.labelText = data.labelText .."PM2.5: " ..data.pm25 .." µg/m³" .."\n"
          data.labelText = data.labelText .."PM10: " ..data.pm10 .." µg/m³" .."\n"
          data.labelText = data.labelText .."Temperature: " ..data.temperature .." °C" .."\n"
          data.labelText = data.labelText .."Humidity: " ..data.humidity .." %" .."\n"
          if bme280Sensor then
            data.labelText = data.labelText .."Pressure: " ..data.pressure .." hPa" .."\n"
          end
          data.labelText = data.labelText .."\n" .."WiFi signal: " ..data.wifisignal .." dBm" .."\n"
          data.labelText = data.labelText .."Firmware version:  " ..data.firmware 

          -- Update label
          self:updateView("label", "text", data.labelText)

          -- Update properties
          self:updateProperty("log", os.date("%d-%m-%Y %X", os.time()-data.age) .."\nWiFi " ..data.wifisignal .."dBm")

          data.pm25prev=pm25prev
          data.pm10prev=pm10prev

          for id,child in pairs(self.childDevices) do 
            child:updateValue(data,userID) 
          end

          pm25prev = tonumber(data.pm25)
          pm10prev = tonumber(data.pm10)

          --self:debug("Measurements:  ", data.labelText)
          --self:debug("--------------------- END --------------------")
        end,
        error = function(error)
          self:error("error: " ..json.encode(error))
          self:updateProperty("log", "error: " ..json.encode(error))
        end
      }) 

    fibaro.setTimeout(interval*1000, collectData) -- Check every [interval] seconds for new data
  end

  collectData() -- start checking data 
end
