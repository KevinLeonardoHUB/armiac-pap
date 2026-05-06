# Firmware ESP32 — ARMIAC

Esta pasta contém o código usado no ESP32 para controlar a mão robótica.

O firmware principal está em:

```text
armiac/armiac.ino
```

O ESP32 cria uma rede Wi‑Fi local e recebe comandos HTTP enviados pela app Flutter.

## Rede criada pelo ESP32

```text
SSID: ARMIAC_ESP32
Password: 12345678
IP: 192.168.4.1
```

## Bibliotecas necessárias

- Wire
- WiFi
- WebServer
- Adafruit PWM Servo Driver Library
