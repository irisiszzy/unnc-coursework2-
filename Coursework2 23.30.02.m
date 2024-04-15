%Zhiyuan Zheng_20513167.m
% Zhiyuan Zheng
% Your Email: ssyzz26@nottingham.edu.cn

% SETUP AND PRELIMINARIES

% Establishing communication with Arduino
a = arduino('COM3', 'Uno'); % Replace 'COM3' with the actual COM port

% Define LED pins
greenLedPin = 'D2';
yellowLedPin = 'D3';
redLedPin = 'D4';
ledPin= 'D2'

% Turn all LEDs off at the beginning
writeDigitalPin(a, greenLedPin, 0);
writeDigitalPin(a, yellowLedPin, 0);
writeDigitalPin(a, redLedPin, 0);

% Define sensor pin
sensorPin = 'A0';

% Blinking LED loop
for i = 1:10 % Blink for 10 cycles
    writeDigitalPin(a, ledPin, 1); % Turn LED on
    pause(0.5); % Wait for 0.5 seconds
    writeDigitalPin(a, ledPin, 0); % Turn LED off
    pause(0.5); % Wait for 0.5 seconds
end
% TASK 1 – READ TEMPERATURE DATA, CONTROL LEDs, AND WRITE TO A LOG FILE

% Data acquisition loop setup
duration = 600; % Acquisition time in seconds (e.g., 10 minutes)
timeInterval = 1; % Time interval to read data from sensor in seconds
numReadings = duration / timeInterval; % Number of readings to take
temperatureData = zeros(1, numReadings); % Array to store temperature values
timeData = 0:timeInterval:(duration - timeInterval); % Array to store time values in seconds

% Start the data acquisition and control loop
for i = 1:numReadings
    voltage = readVoltage(a, sensorPin); % Read voltage from sensor
    temperature = voltageToTemperature(voltage); % Convert voltage to temperature
    temperatureData(i) = temperature; % Store temperature in array
    
    % Control LEDs based on temperature
    if temperature >= 18 && temperature <= 24
        writeDigitalPin(a, greenLedPin, 1); % Turn green LED on
        writeDigitalPin(a, yellowLedPin, 0);
        writeDigitalPin(a, redLedPin, 0);
    elseif temperature < 18
        writeDigitalPin(a, yellowLedPin, 1); % Turn yellow LED on
    else % temperature > 24
        writeDigitalPin(a, redLedPin, 1); % Turn red LED on
    end
    
    pause(timeInterval); % Ensure correct timing for each loop iteration
end

% Turn off all LEDs after the data acquisition loop
writeDigitalPin(a, greenLedPin, 0);
writeDigitalPin(a, yellowLedPin, 0);
writeDigitalPin(a, redLedPin, 0);

% Plotting
figure;
plot(timeData, temperatureData);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Cabin Temperature Over Time');

% Calculate statistics
maxTemp = max(temperatureData);
minTemp = min(temperatureData);
avgTemp = mean(temperatureData);

% Convert timeData from seconds to minutes for logging purposes
timeDataMinutes = timeData / 60;

% Open the file
fileID = fopen('cabin_temperature_log.txt', 'w');

% Write the header information
fprintf(fileID, 'Table 1 - Output to screen formatting example\n');
fprintf(fileID, 'Data logging initiated - %s\n', datestr(now, 'dd/mm/yyyy HH:MM:SS'));
fprintf(fileID, 'Location - Nottingham\n\n');

% Write the data in a formatted table
fprintf(fileID, 'Minute\tTemperature (°C)\n');
for i = 1:numReadings
    % Only write data corresponding to the start of each minute
    if mod(timeData(i), 60) == 0
        fprintf(fileID, '%.2f\t%.2f\n', timeDataMinutes(i), temperatureData(i));
    end
end

% Write the statistics
fprintf(fileID, '\nMax temp\t%.2f °C\n', maxTemp);
fprintf(fileID, 'Min temp\t%.2f °C\n', minTemp);
fprintf(fileID, 'Average temp\t%.2f °C\n', avgTemp);

% Write the footer with dynamic end time
fprintf(fileID, '\nData logging terminated - %s\n', datestr(now, 'dd/mm/yyyy HH:MM:SS'));

% Close the file
fclose(fileID);

% Function to convert voltage to temperature
% Replace with the actual conversion formula based on your sensor's specifications
function temperature = voltageToTemperature(voltage)
    % Example conversion formula - adjust as necessary for your sensor
    temperature = (voltage - 0.5) * 100; % Assuming a 10mV/°C scale and 500mV offset at 0°C
end
clear all
%% task 2
a = arduino('COM3', 'Uno')
temp_monitor(a);
clear all

%% task3
a = arduino('COM3', 'Uno')
temp_prediction(a)

% Reflective Statement:
%
% Throughout the execution of this project, several challenges were encountered. 
% One of the primary difficulties was the accurate calculation of the temperature 
% rate of change. Due to the inherent noise in sensor data, it was necessary to 
% implement a data smoothing algorithm to obtain a reliable reading. This required 
% careful consideration to balance responsiveness with noise reduction. Another 
% challenge was ensuring that the temperature prediction model accurately projected 
% future temperature based on the current rate of change, considering that actual 
% conditions may vary significantly over a 5-minute period.
%
% The project's strengths lie in its real-time monitoring capability and the 
% immediate visual feedback provided by the LED indicators. These features facilitate 
% quick responses to temperature fluctuations, which is beneficial in maintaining 
% a comfortable cabin environment. The use of a modular function allows for ease of 
% maintenance and scalability, as additional features or sensors can be integrated with 
% minimal adjustments to the existing code base.
%
% However, the project is not without limitations. The prediction model assumes a 
% constant rate of change, which is unlikely in a real-world scenario where temperature 
% change rates can vary due to a multitude of factors. Additionally, the current 
% implementation does not account for the thermal inertia of the cabin, which could 
% lead to overcompensation in temperature control.
%
% For future improvements, an adaptive prediction model could be implemented that 
% takes into account various environmental factors and learns from past data to 
% improve accuracy. Incorporating machine learning techniques could enable the system 
% to predict temperature trends rather than just linear extrapolations. Furthermore, 
% integrating a feedback loop from the temperature control system could allow for 
% more precise adjustments, thereby maintaining a more consistent cabin temperature. 
% Another enhancement could be the use of a more sophisticated filtering method, 
% such as a Kalman filter, which is well-suited for systems with a high level of 
% uncertainty and noise. Lastly, expanding the system's capabilities to include 
% humidity and air quality monitoring could provide a more comprehensive approach 
% to cabin comfort.
%
% Overall, the project serves as a valuable prototype for a dynamic temperature 
% monitoring system. It has demonstrated the potential to enhance comfort by 
% preemptively adjusting to changes in cabin temperature. With further refinements, 
% it could be developed into a robust environmental control solution.
%
% End of Reflective Statement.