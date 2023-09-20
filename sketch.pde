//Used Libs
importprocessing.serial.*; 
importjava.awt.event.KeyEvent; 
importjava.io.IOException;

//Defines myPort as a serial object
Serial myPort; 
//Variables
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
//Create a font
PFont orcFont;

voidsetup() {
//Screen dimensioning
    size(700, 700);
    //Draws all geometry with smooth edges
    smooth();
    //Setting up serial communication 
    myPort = new Serial(this,"COM3", 9600);
    //Reads data from the serial port up to the '.' character. So actually read this: angle, distance
    myPort.bufferUntil('.');
    orcFont = loadFont("OCRAExtended-30.vlw");
}

voiddraw()
{
    //Sets the color used to fill shapes
    fill(98,245,31);
    textFont(orcFont);
    //Disables drawing the outline
    noStroke();
    fill(0,4); //Cor pra preencher as formas 
    //Draws a rectangle to the screen
    rect(0, 0, width, height);
    fill(98,245,31);
    //Call the functions to draw the SONAR
    drawRadar(); 
    drawLine();
    drawObject();
    drawText();
}

//Defines the values of declared variables based on information collected via COM3
void serialEvent(Serial myPort) { 
    data = myPort.readStringUntil('.');
    data = data.substring(0,data.length() - 1);
    
    index1 = data.indexOf(",");
    angle = data.substring(0, index1);
    distance = data.substring(index1 + 1, data.length()); 
    iAngle = int(angle);
    iDistance = int(distance);
}



void drawRadar() {
    pushMatrix();
    translate(width / 2,height / 2);
    noFill();
    strokeWeight(2);
    //Sets the color used to draw lines and borders around shapes as green
    stroke(98,245,31);
    
    //Draw the arched lines
    arc(0,0,(width * 0.20),(width * 0.20),0,TWO_PI);
    arc(0,0,(width * 0.40),(width * 0.40),0,TWO_PI);
    arc(0,0,(width * 0.60),(width * 0.60),0,TWO_PI);
    arc(0,0,(width * 0.80),(width * 0.80),0,TWO_PI);
    arc(0,0,(width),(width),0,TWO_PI);
    
    //Draw the angle lines
    line( -width / 2,0,width / 2,0);
    line(0,0,( -width / 2) * cos(radians(30)),( -width / 2) * sin(radians(30)));
    line(0,0,( -width / 2) * cos(radians(60)),( -width / 2) * sin(radians(60)));
    line(0,0,( -width / 2) * cos(radians(90)),( -width / 2) * sin(radians(90)));
    line(0,0,( -width / 2) * cos(radians(120)),( -width / 2) * sin(radians(120)));
    line(0,0,( -width / 2) * cos(radians(150)),( -width / 2) * sin(radians(150)));
    line(0,0,( -width / 2) * cos(radians(180)),( -width / 2) * sin(radians(180)));
    line(0,0,( -width / 2) * cos(radians(210)),( -width / 2) * sin(radians(210)));
    line(0,0,( -width / 2) * cos(radians(240)),( -width / 2) * sin(radians(240)));
    line(0,0,( -width / 2) * cos(radians(270)),( -width / 2) * sin(radians(270)));
    line(0,0,( -width / 2) * cos(radians(300)),( -width / 2) * sin(radians(300)));
    line(0,0,( -width / 2) * cos(radians(330)),( -width / 2) * sin(radians(330)));
    line(( -width / 2) * cos(radians(30)),0,width / 2,0);
    popMatrix();
}

void drawObject() {
    pushMatrix();
    //Move the starting coordinates to the new location
    translate(width / 2,height / 2);
    strokeWeight(9);
    //Red
    stroke(255,10,10);
    
    pixsDistance = ((iDistance * height * 0.1) / 10); 
    
    
    //Limits the maximum range to 50cm
    if (iDistance < 50) {
        // Draws the object according to angle and distance
        line(pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),(width - width * 0.505) * cos(radians(iAngle)), -(width - width * 0.505) * sin(radians(iAngle)));
    }
    popMatrix();
}

void drawLine() {
    pushMatrix();
    strokeWeight(9);
    stroke(30,250,60);
    translate(width / 2,height / 2);
    //  Draws the object according to the angle
    line(0,0,(height - height * 0.505) * cos(radians(iAngle)), -(height - height * 0.505) * sin(radians(iAngle)));
    popMatrix();
}

//Draw the texts
void drawText() {
    pushMatrix();
    if (iDistance > 50) {
        noObject = "Fora";
    }
    else {
        noObject = "Dentro";
    }
    fill(0,0,0);
    noStroke();
    rect(0, 0, width * 0.28, height * 0.13);
    fill(98,245,31);
    textSize(10);
    text("10cm",width - width * 0.45,height * 0.49);
    text("20cm",width - width * 0.35,height * 0.49);
    text("30cm",width - width * 0.25,height * 0.49);
    text("40cm",width - width * 0.15,height * 0.49);
    text("50cm",width - width * 0.05,height * 0.49);
    fill(255,255,255);
    textSize(16);
    // 1 / 25 = 0.04
    text("Medições ", width * 0.01, height * 0.03);
    textSize(14);
    text("Alcance: " + noObject, width * 0.01, height * 0.06);
    text("Angulo: " + iAngle + " °", width * 0.01, height * 0.09);
    text("Distância: ", width * 0.01, height * 0.12);
    
    if (iDistance < 50) {
        text("" + iDistance + " cm",  width * 0.05, height * 0.12);
    }
    else{
        text("> 50 cm",  width * 0.05, height * 0.12);
    }
    textSize(10);
    popMatrix(); 
}
