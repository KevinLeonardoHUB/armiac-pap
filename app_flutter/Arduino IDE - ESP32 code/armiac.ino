#include <Wire.h>
#include <WiFi.h>
#include <WebServer.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pca = Adafruit_PWMServoDriver(0x40);
WebServer server(80);

const char* ssid = "ARMIAC";
const char* pass = "12345678";

#define SERVO_MIN 110
#define SERVO_MAX 500

#define CH_POLEGAR_DENTRO 0
#define CH_POLEGAR_FLEX   1
#define CH_INDICADOR      2
#define CH_MEDIO          3
#define CH_RINGPINKY      4
#define CH_ANTEBRACO      5

#define ANG_INDICADOR_ABERTO       180
#define ANG_INDICADOR_FECHADO      0
#define ANG_POLEGAR_DENTRO_ABERTO  0
#define ANG_POLEGAR_DENTRO_FECHADO 140

String lastAction = "open_hand";

// Converte o ângulo do servo para o valor de pulso usado pelo controlador PCA9685.
uint16_t anguloParaPulso(int angulo) {
  return map(angulo, 0, 180, SERVO_MIN, SERVO_MAX);
}

// Define o ângulo de um servo num determinado canal.
void setServoAng(int ch, int ang) {
  ang = constrain(ang, 0, 180);
  pca.setPWM(ch, 0, anguloParaPulso(ang));
}

// Devolve o ângulo invertido conforme o dedo esteja fechado ou aberto.
int angInvertido(int fechado) {
  return fechado ? 0 : 180;
}

// Controla o dedo indicador.
void setIndicador(int fechado) {
  setServoAng(CH_INDICADOR, fechado ? ANG_INDICADOR_FECHADO : ANG_INDICADOR_ABERTO);
}

// Controla o dedo médio.
void setMedio(int fechado) {
  setServoAng(CH_MEDIO, angInvertido(fechado));
}

// Controla o anelar e o mindinho.
void setRingPinky(int fechado) {
  setServoAng(CH_RINGPINKY, angInvertido(fechado));
}

// Controla a flexão do polegar.
void setPolegarFlex(int fechado) {
  setServoAng(CH_POLEGAR_FLEX, angInvertido(fechado));
}

// Controla o movimento do polegar para dentro da mão.
void setPolegarDentro(int fechado) {
  int ang = fechado ? ANG_POLEGAR_DENTRO_FECHADO : ANG_POLEGAR_DENTRO_ABERTO;
  setServoAng(CH_POLEGAR_DENTRO, ang);
}

// Abre todos os dedos da mão.
void actionOpenHand() {
  setIndicador(0);
  setMedio(0);
  setRingPinky(0);
  setPolegarFlex(0);
  setPolegarDentro(0);
}

// Fecha todos os dedos da mão.
void actionCloseHand() {
  setIndicador(1);
  setMedio(1);
  setRingPinky(1);
  setPolegarFlex(1);
  setPolegarDentro(1);
}

// Faz o gesto de paz.
void actionPeace() {
  setIndicador(0);
  setMedio(0);
  setRingPinky(1);
  setPolegarFlex(1);
  setPolegarDentro(1);
}

// Faz o gesto do número dois.
void actionTwo() {
  actionPeace();
}

// Faz o gesto de apontar.
void actionPoint() {
  setIndicador(0);
  setMedio(1);
  setRingPinky(1);
  setPolegarFlex(1);
  setPolegarDentro(1);
}

// Faz o gesto do número três.
void actionThree() {
  setIndicador(0);
  setMedio(0);
  setRingPinky(1);
  setPolegarFlex(0);
  setPolegarDentro(0);
}

// Faz o gesto do número quatro.
void actionFour() {
  setIndicador(0);
  setMedio(0);
  setRingPinky(0);
  setPolegarFlex(1);
  setPolegarDentro(1);
}

// Faz o gesto de polegar para cima.
void actionThumbsUp() {
  setIndicador(1);
  setMedio(1);
  setRingPinky(1);
  setPolegarFlex(0);
  setPolegarDentro(0);
}

// Faz uma aproximação do gesto OK.
void actionOk() {
  setIndicador(1);
  setMedio(0);
  setRingPinky(0);
  setPolegarFlex(1);
  setPolegarDentro(1);
}

// Roda o antebraço para uma posição com a palma para cima.
void actionPalmUp() {
  setServoAng(CH_ANTEBRACO, 35);
}

// Roda o antebraço para uma posição com a palma para baixo.
void actionPalmDown() {
  setServoAng(CH_ANTEBRACO, 145);
}

// Coloca o antebraço numa posição neutra.
void actionForearmNeutral() {
  setServoAng(CH_ANTEBRACO, 90);
}

// Faz um pequeno movimento de aceno com o antebraço.
void actionWave() {
  for (int repeticao = 0; repeticao < 2; repeticao++) {
    actionPalmUp();
    delay(250);
    actionPalmDown();
    delay(250);
  }

  actionForearmNeutral();
}

// Executa uma sequência de demonstração com vários gestos.
void actionDemo() {
  actionOpenHand();
  delay(500);

  actionCloseHand();
  delay(500);

  actionOpenHand();
  delay(500);

  actionPeace();
  delay(700);

  actionPoint();
  delay(700);

  actionThree();
  delay(700);

  actionThumbsUp();
  delay(700);

  actionOk();
  delay(700);

  actionWave();
  delay(300);

  actionOpenHand();
}

// Fecha apenas o indicador.
void actionCloseIndex() {
  setIndicador(1);
}

// Fecha apenas o dedo médio.
void actionCloseMiddle() {
  setMedio(1);
}

// Fecha o anelar e o mindinho.
void actionCloseRingPinky() {
  setRingPinky(1);
}

// Fecha o polegar.
void actionCloseThumb() {
  setPolegarFlex(1);
  setPolegarDentro(1);
}

// Abre apenas o indicador.
void actionOpenIndex() {
  setIndicador(0);
}

// Abre apenas o dedo médio.
void actionOpenMiddle() {
  setMedio(0);
}

// Abre o anelar e o mindinho.
void actionOpenRingPinky() {
  setRingPinky(0);
}

// Abre o polegar.
void actionOpenThumb() {
  setPolegarFlex(0);
  setPolegarDentro(0);
}

// Responde ao pedido de teste da ligação.
void handlePing() {
  server.send(200, "text/plain", "OK");
}

// Envia o estado atual da mão em formato JSON.
void handleStatus() {
  String json = "{\"status\":\"ok\",\"lastAction\":\"" + lastAction + "\",\"ip\":\"" + WiFi.softAPIP().toString() + "\"}";
  server.send(200, "application/json", json);
}

// Permite testar manualmente um servo através do navegador.
void handleCalibrate() {
  if (!server.hasArg("servo") || !server.hasArg("angle")) {
    server.send(400, "text/plain", "Use: /calibrate?servo=2&angle=90");
    return;
  }

  int servo = server.arg("servo").toInt();
  int angle = server.arg("angle").toInt();

  if (servo < 0 || servo > 15 || angle < 0 || angle > 180) {
    server.send(400, "text/plain", "servo deve ser 0-15 e angle deve ser 0-180");
    return;
  }

  setServoAng(servo, angle);
  lastAction = "calibrate servo " + String(servo) + " angle " + String(angle);

  server.send(200, "text/plain", "OK");
}

// Recebe o nome da ação pela URL e executa o gesto correspondente.
void handleAction() {
  String a = server.arg("a");

  if (a == "close_hand") actionCloseHand();
  else if (a == "peace") actionPeace();
  else if (a == "two") actionTwo();
  else if (a == "point") actionPoint();
  else if (a == "three") actionThree();
  else if (a == "four") actionFour();
  else if (a == "thumbs_up") actionThumbsUp();
  else if (a == "ok") actionOk();
  else if (a == "wave") actionWave();
  else if (a == "palm_up") actionPalmUp();
  else if (a == "palm_down") actionPalmDown();
  else if (a == "forearm_neutral") actionForearmNeutral();
  else if (a == "demo") actionDemo();
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
    server.send(400, "text/plain", "Acao invalida");
    return;
  }

  lastAction = a;
  server.send(200, "text/plain", "OK");
}

// Configura os servos, cria a rede Wi-Fi e inicia o servidor.
void setup() {
  Serial.begin(115200);

  Wire.begin(21, 22);

  pca.begin();
  pca.setPWMFreq(50);
  delay(10);

  actionOpenHand();
  actionForearmNeutral();

  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid, pass);

  Serial.print("AP: ");
  Serial.println(ssid);

  Serial.print("IP: ");
  Serial.println(WiFi.softAPIP());

  server.on("/ping", handlePing);
  server.on("/status", handleStatus);
  server.on("/calibrate", handleCalibrate);
  server.on("/action", handleAction);

  server.begin();

  Serial.println("READY");
}

// Mantém o servidor ativo para receber pedidos.
void loop() {
  server.handleClient();
}