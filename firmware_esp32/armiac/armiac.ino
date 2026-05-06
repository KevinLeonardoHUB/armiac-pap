#include <Wire.h>
#include <WiFi.h>
#include <WebServer.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pca = Adafruit_PWMServoDriver(0x40);
WebServer server(80);

const char* ssid = "ARMIAC_ESP32";
const char* pass = "12345678";

#define SERVO_MIN 110
#define SERVO_MAX 500

#define CH_POLEGAR_DENTRO 0
#define CH_POLEGAR_FLEX   1
#define CH_INDICADOR      2
#define CH_MEDIO          3
#define CH_RINGPINKY      4
#define CH_SERVO6         5

int angServo6 = 0;
bool subindo6 = true;
unsigned long ultimoMov6 = 0;
const unsigned long intervalo6_ms = 20;
const int LIM_INF6 = 0;
const int LIM_SUP6 = 180;

uint16_t anguloParaPulso(int angulo) {
  return map(angulo, 0, 180, SERVO_MIN, SERVO_MAX);
}

void setServoAng(int ch, int ang) {
  ang = constrain(ang, 0, 180);
  pca.setPWM(ch, 0, anguloParaPulso(ang));
}

int angInvertido(int fechado) {
  return fechado ? 0 : 180;
}

void setIndicador(int fechado) {
  setServoAng(CH_INDICADOR, fechado ? 180 : 0);
}

void setMedio(int fechado) {
  setServoAng(CH_MEDIO, angInvertido(fechado));
}

void setRingPinky(int fechado) {
  setServoAng(CH_RINGPINKY, angInvertido(fechado));
}

void setPolegarFlex(int fechado) {
  setServoAng(CH_POLEGAR_FLEX, angInvertido(fechado));
}

void setPolegarDentro(int fechado) {
  int ang = fechado ? 0 : 48;
  setServoAng(CH_POLEGAR_DENTRO, ang);
}

void actionCloseHand() {
  setIndicador(1);
  setMedio(1);
  setRingPinky(1);
  setPolegarFlex(1);
  setPolegarDentro(1);
}

void actionPeace() {
  setIndicador(0);
  setMedio(0);
  setRingPinky(1);
  setPolegarFlex(1);
  setPolegarDentro(1);
}

void actionCloseIndex() {
  setIndicador(1);
}

void actionCloseMiddle() {
  setMedio(1);
}

void actionCloseRingPinky() {
  setRingPinky(1);
}

void actionCloseThumb() {
  setPolegarFlex(1);
  setPolegarDentro(1);
}

void actionOpenHand() {
  setIndicador(0);
  setMedio(0);
  setRingPinky(0);
  setPolegarFlex(0);
  setPolegarDentro(0);
}

void actionOpenIndex() {
  setIndicador(0);
}

void actionOpenMiddle() {
  setMedio(0);
}

void actionOpenRingPinky() {
  setRingPinky(0);
}

void actionOpenThumb() {
  setPolegarFlex(0);
  setPolegarDentro(0);
}

void handlePing() {
  server.send(200, "text/plain", "OK");
}

void handleAction() {
  String a = server.arg("a");

  if (a == "close_hand") actionCloseHand();
  else if (a == "peace") actionPeace();
  else if (a == "close_index") actionCloseIndex();
  else if (a == "close_middle") actionCloseMiddle();
  else if (a == "close_ringpinky") actionCloseRingPinky();
  else if (a == "close_thumb") actionCloseThumb();
  else if (a == "open_hand") actionOpenHand();
  else if (a == "open_index") actionOpenIndex();
  else if (a == "open_middle") actionOpenMiddle();
  else if (a == "open_ringpinky") actionOpenRingPinky();
  else if (a == "open_thumb") actionOpenThumb();
  else {
    server.send(400, "text/plain", "Ação inválida");
    return;
  }

  server.send(200, "text/plain", "OK");
}

void setup() {
  Serial.begin(115200);

  Wire.begin(21, 22);

  pca.begin();
  pca.setPWMFreq(50);
  delay(10);

  setServoAng(CH_INDICADOR, 180);
  setServoAng(CH_POLEGAR_FLEX, 180);
  setServoAng(CH_MEDIO, 180);
  setServoAng(CH_RINGPINKY, 180);

  angServo6 = LIM_INF6;
  setServoAng(CH_SERVO6, angServo6);

  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid, pass);

  Serial.print("AP: ");
  Serial.println(ssid);

  Serial.print("IP: ");
  Serial.println(WiFi.softAPIP());

  server.on("/ping", handlePing);
  server.on("/action", handleAction);

  server.begin();

  Serial.println("READY");
}

void loop() {
  unsigned long agora = millis();

  if (agora - ultimoMov6 >= intervalo6_ms) {
    ultimoMov6 = agora;

    setServoAng(CH_SERVO6, angServo6);

    if (subindo6) {
      angServo6++;
      if (angServo6 >= LIM_SUP6) {
        angServo6 = LIM_SUP6;
        subindo6 = false;
      }
    } else {
      angServo6--;
      if (angServo6 <= LIM_INF6) {
        angServo6 = LIM_INF6;
        subindo6 = true;
      }
    }
  }

  server.handleClient();
}
