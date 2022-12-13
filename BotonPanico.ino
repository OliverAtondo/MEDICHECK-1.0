#include <Arduino.h>
#include <WiFi.h>
#include <SocketIoClient.h>
#include <ArduinoJson.h>

const char* ssid     = "FarmaciasDelAhorro";
const char* password = "CielMineral22";
const char* server = "34.125.255.24";
const uint16_t port = 5001;
uint64_t messageTimestamp;
int payload_entero;
SocketIoClient socketIO;
#define ONBOARD_LED  2
#define BOTON 12

String resmsg;

String str;
StaticJsonDocument<256> doc;

void setup() {
  pinMode(ONBOARD_LED,OUTPUT);
  pinMode(BOTON,INPUT);
  Serial.begin(115200);
  connectWiFi_STA();
  socketIO.begin(server, port);
  socketIO.on("desde_servidor",procesar_mensaje_recibido);
}

void loop() {
  socketIO.loop();
  if(digitalRead(BOTON) == HIGH){
    socketIO.emit("arduino","{\"text\":\"ALERT\"}");
  }
}

void procesar_mensaje_recibido(const char * payload, size_t length) {

 String s((const __FlashStringHelper*) payload);

  Serial.println(s);
 
 if (s == "OFF")
  {
    digitalWrite(ONBOARD_LED,LOW);
    digitalWrite(35,LOW);
    Serial.println(s);
  } else if (s == "ON")
  {
    digitalWrite(ONBOARD_LED,HIGH);
    digitalWrite(35,HIGH);
    emergency();
    Serial.println(s);
  }
}

void emergency(void){
  digitalWrite(35, HIGH);
  delay(500);
  digitalWrite(35, LOW);
  delay(500);
  digitalWrite(35, HIGH);
  delay(500);
  digitalWrite(35, LOW);
  delay(500);
  digitalWrite(35, HIGH);
  delay(500);
  digitalWrite(35, LOW);
  delay(500);
  digitalWrite(35, HIGH);
  delay(500);
  digitalWrite(35, LOW);
  delay(500);
}

void connectWiFi_STA()
{
   delay(10); 
   Serial.println("");
   WiFi.mode(WIFI_STA);
   WiFi.begin(ssid,password);
   while (WiFi.status() != WL_CONNECTED) 
   { 
     delay(100);  
     Serial.print('.'); 
   }
   Serial.println("");
   Serial.print("Iniciado STA:\t");
   Serial.println(ssid);
   Serial.print("IP address:\t");
   Serial.println(WiFi.localIP());
}
