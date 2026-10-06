INSERT INTO components (name, category, total_qty, in_stock, damaged_qty, is_active)
VALUES
  ('Arduino Uno R3', 'Microcontrollers', 15, 15, 0, TRUE),
  ('Raspberry Pi 4 (4GB)', 'Single Board Computers', 8, 8, 0, TRUE),
  ('Ultrasonic Sensor HC-SR04', 'Sensors', 30, 30, 0, TRUE),
  ('SG90 Micro Servo Motor', 'Actuators', 25, 25, 0, TRUE),
  ('10k Ohm Resistor Pack', 'Passive Components', 100, 100, 0, TRUE),
  ('Breadboard Medium', 'Prototyping', 40, 40, 0, TRUE),
  ('16x2 LCD Display (I2C)', 'Displays', 20, 20, 0, TRUE),
  ('5V Relay Module', 'Modules', 15, 15, 0, TRUE)
ON CONFLICT DO NOTHING;
