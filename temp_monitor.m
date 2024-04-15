function temp_monitor(a)
    % Define the pins for the LEDs
    greenLED = 'D2';
    yellowLED = 'D3';
    redLED = 'D4';

    % Configure the pins as output
    configurePin(a, greenLED, 'DigitalOutput');
    configurePin(a, yellowLED, 'DigitalOutput');
    configurePin(a, redLED, 'DigitalOutput');

    % Define the temperature range
    lowerBound = 18;
    upperBound = 24;

    % Create the live graph
    figure;
    h = animatedline;
    xlabel('Time');
    ylabel('Temperature (°C)');
    title('Live Temperature Data');
    grid on;

    % Start the monitoring and LED control loop
    while true
        % Read temperature from sensor
        temperature = readTemperature(a); % Placeholder for the actual temperature reading function

        % Check if temperature is a scalar numeric value
        if isnumeric(temperature) && isscalar(temperature)
            % Add points to the live graph
            addpoints(h, datenum(datetime('now')), temperature);
        else
            error('Temperature must be a scalar numeric value.');
        end

        xlim([datenum(datetime('now')-minutes(1)), datenum(datetime('now'))]); % Display the last minute of data
        ylim([lowerBound-5, upperBound+5]); % Adjust Y limits to show a range around our bounds
        drawnow;


        % Control the LEDs based on the temperature
        if temperature >= lowerBound && temperature <= upperBound
            % Temperature is in range, turn green LED on and others off
            writeDigitalPin(a, greenLED, 1);
            writeDigitalPin(a, yellowLED, 0);
            writeDigitalPin(a, redLED, 0);
        elseif temperature < lowerBound
            % Temperature is below range, blink yellow LED
            writeDigitalPin(a, greenLED, 0);
            blinkLED(a, yellowLED, 0.5);
            writeDigitalPin(a, redLED, 0);
        elseif temperature > upperBound
            % Temperature is above range, blink red LED
            writeDigitalPin(a, greenLED, 0);
            writeDigitalPin(a, yellowLED, 0);
            blinkLED(a, redLED, 0.25);
        end

        % Wait for approximately 1 second before next reading
        pause(1);
    end
end

function blinkLED(a, pin, interval)
    % Blink an LED on a specified pin for a specified interval.
    writeDigitalPin(a, pin, 1); % Turn LED on
    pause(interval / 2);
    writeDigitalPin(a, pin, 0); % Turn LED off
    pause(interval / 2);
end

function temp = readTemperature(a)
    % Placeholder for the actual temperature reading function
    % You should replace this with the actual code that reads the sensor
    sensorValue = readVoltage(a, 'A0'); % Read the sensor value from analog pin A0
    temp = (sensorValue - 0.5) * 100; % Convert the voltage to temperature (assumed formula)
end