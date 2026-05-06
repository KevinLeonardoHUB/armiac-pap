#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>

Adafruit_PWMServoDriver pca = Adafruit_PWMServoDriver(0x40);

#define SERVO_MIN 110
#define SERVO_MAX 500

#define CH_POLEGAR_DENTRO 0   // 0 ↔ 48
#define CH_INDICADOR      2   // invertido
#define CH_POLEGAR_FLEX   3   // invertido (dedão fecha)
#define CH_MEDIO          4   // invertido
#define CH_RINGPINKY      5   // invertido (anelar + mindinho juntos)
#define CH_SERVO6         6   // <<< sexto servo (mude se estiver em outro canal)

// ---------- Servo 6: vai e volta 0 <-> 180 em loop ----------
int angServo6 = 0;
bool subindo6 = true;
unsigned long ultimoMov6 = 0;
const unsigned long intervalo6_ms = 20; // menor = mais rápido (ex: 10), maior = mais lento (ex: 40)

// (opcional) se seu servo "bate" no fim e treme, use limites mais seguros:
// const int LIM_INF6 = 5;
// const int LIM_SUP6 = 175;
const int LIM_INF6 = 0;
const int LIM_SUP6 = 180;
// ------------------------------------------------------------

uint16_t anguloParaPulso(int angulo) {
  return map(angulo, 0, 180, SERVO_MIN, SERVO_MAX);
}

void setServoAng(int ch, int ang) {
  ang = constrain(ang, 0, 180);
  pca.setPWM(ch, 0, anguloParaPulso(ang));
}

// fechado=1 -> 0 graus | fechado=0 -> 180 graus
int angInvertido(int fechado) {
  return fechado ? 0 : 180;
}

void setup() {
  Serial.begin(115200);
  Wire.begin(21, 22);  // ESP32: SDA=21, SCL=22 (ajuste se precisar)

  pca.begin();
  pca.setPWMFreq(50);
  delay(10);

  // posições iniciais (seus servos)
 setServoAng(CH_INDICADOR, 180);
setServoAng(CH_POLEGAR_FLEX, 180);
setServoAng(CH_MEDIO, 180);
 setServoAng(CH_RINGPINKY, 180);

  // inicializa servo 6 no limite inferior
  angServo6 = LIM_INF6;
  setServoAng(CH_SERVO6, angServo6);

  Serial.println("READY");
}

void loop() {
  // --------- Loop automático do SERVO 6 (0 <-> 180) ----------
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
  // ----------------------------------------------------------

  // --------- Controle dos outros servos via Serial ----------
  if (!Serial.available()) return;

  String cmd = Serial.readStringUntil('\n');
  cmd.trim();
  if (cmd.length() < 2) return;

  char dedo = cmd[0];
  char val  = cmd[1];
  int fechado = (val == '1') ? 1 : 0;

  if (dedo == 'I') {
    setServoAng(CH_INDICADOR, fechado ? 180 : 0);
  }
  else if (dedo == 'M') {
    setServoAng(CH_MEDIO, angInvertido(fechado));
  }
  else if (dedo == 'G') {
    setServoAng(CH_RINGPINKY, angInvertido(fechado));
  }
  else if (dedo == 'T') {
    setServoAng(CH_POLEGAR_FLEX, angInvertido(fechado));
  }
  else if (dedo == 'A') {
    int ang = fechado ? 0 : 48; // polegar pra dentro
    setServoAng(CH_POLEGAR_DENTRO, ang);
  }
}
