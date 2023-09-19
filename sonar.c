// Libs
#include <Stepper.h>
// Pin Configuration
#define in1 10
#define in2 11
#define in3 12
#define in4 13
const int stepsPerRevolution = 500;
SteppermyStepper(stepsPerRevolution, in1, in3, in2, in4);
// Trigger
int trigPin = 5;
// Echo return
int echoPin = 4;
// Duration
unsigned long duration;
// Distance
volatile int distance;

voidsetup()
{
    pinMode(trigPin, OUTPUT); // Config TrigPin as an output
    pinMode(echoPin, INPUT);  // Config TrigPin as an input
    pinMode(8, OUTPUT);       // Config the power buzzer pin as an output
    myStepper.setSpeed(20);   // Set 20rpm as the motor speed
    Serial.begin(9600);       // Sets the bps (baud) who defines the number of pulses that are transmitted per second
}

voidloop()
{
    for (int i = 0; i <= 360; i++) // Clockwise rotation
    {
        myStepper.step(-5.69); // Number of steps to turn the motor
        delay(30);
        distance = calculateDistance(); // Calculates the distance measured by the ultrasonic sensor at each distance traveled
        Serial.print(i);                // Send the current degree via serial port
        Serial.print(",");              // Send an addittional char with the previos one, this is will be useful on Processinge Processing
        Serial.print(distance);         // Send the current distance via serial port
        Serial.print(".");              // Addittional char
        if (distance < 20)              
        {
            tone(8, 1000, 100); // High pitched tone
        }
        else if (distance > 20 && distance < 40)
        {
            tone(8, 50, 100); // Low pitched tone
        }
    }
    for (int i = 360; i > 0; i--) // Counterclockwise rotation
    {
        myStepper.step(5.69);
        delay(30);
        distance = calculateDistance();
        Serial.print(i);
        Serial.print(",");
        Serial.print(distance);
        Serial.print(".");
        if (distance < 20)
        {
            tone(8, 1000, 100);
        }
        elseif(distance > 20 && distance < 40)
        {
            tone(8, 50, 100);
        }
    }
}

int calculateDistance()
{
    digitalWrite(trigPin, LOW); // sets the pin off
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH); // sets the pin on
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);
    duration = pulseIn(echoPin, HIGH); // Reads a pulse of echoPin and return the duration of the echo path
    distance = duration * 0.034 / 2;   // Distance formula
    return distance;
}
