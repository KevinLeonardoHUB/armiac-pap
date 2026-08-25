# ARMIAC — Mão Robótica Inteligente

**ARMIAC** é um protótipo de mão robótica desenvolvido como **Prova de Aptidão Profissional (PAP)** no ano letivo de 2025/2026, no âmbito do curso profissional de *Gestão e Programação de Sistemas Informáticos*.

O projeto integra **robótica, eletrónica, sistemas embebidos, impressão 3D, redes e desenvolvimento de aplicações móveis** num único protótipo funcional.

O ARMIAC é constituído por uma mão robótica articulada, impressa em 3D, controlada por um **ESP32** e por um controlador PWM **PCA9685**. Uma aplicação móvel desenvolvida em **Flutter e Dart** comunica com o ESP32 através de uma rede Wi-Fi local, utilizando pedidos HTTP.

A aplicação permite controlar individualmente os dedos, abrir e fechar a mão, executar gestos predefinidos e interagir com o sistema através de botões e comandos de voz.

---

## Estado do Projeto

✅ **Versão da PAP concluída — 2025/2026**

A versão atual do ARMIAC é um protótipo funcional que inclui:

- Mão robótica articulada impressa em 3D
- Sistema de controlo baseado em ESP32
- Controlador de servos PCA9685
- Vários servomotores
- Aplicação Android desenvolvida em Flutter
- Comunicação por Wi-Fi
- Comandos através de HTTP
- Controlo individual dos dedos
- Gestos predefinidos
- Comandos de voz
- Interface em português e inglês
- Tutorial de utilização
- Documentação técnica final
- Vídeos de demonstração

**Versão atual da aplicação: 1.1.7**

Apesar de a versão desenvolvida para a PAP estar concluída, pretendo continuar a desenvolver o ARMIAC no futuro, caso tenha os recursos e o financiamento necessários.

---

## Objetivo do Projeto

O objetivo inicial do ARMIAC foi criar uma **plataforma educativa de robótica** que pudesse demonstrar de forma prática como software e hardware interagem num sistema real.

O projeto foi pensado com potencial de utilização em ambientes como:

- Escolas
- Universidades
- Instituições tecnológicas
- Cursos profissionais
- Clubes de robótica
- Aulas de programação e eletrónica
- Projetos e programas STEM

Através do ARMIAC, os alunos podem explorar conceitos relacionados com programação, aplicações móveis, robótica, redes, eletrónica, microcontroladores, modelação 3D e impressão 3D.

O projeto demonstra, por exemplo, como um comando enviado através de uma aplicação móvel pode passar por várias tecnologias até produzir um movimento físico numa mão robótica.

---

## Visão Futura

Durante o desenvolvimento do ARMIAC, percebi que o projeto poderia evoluir para além do seu objetivo educativo inicial.

Uma das ideias que pretendo explorar no futuro é o desenvolvimento de um **segundo braço e de uma segunda mão robótica**.

A utilização de duas mãos robóticas permitiria reproduzir uma variedade muito maior de gestos e poderia abrir a possibilidade de desenvolver, no futuro, um sistema experimental capaz de converter **linguagem falada em gestos de língua gestual**.

Por exemplo, uma futura versão do ARMIAC poderia receber informação falada durante uma aula, processá-la através de software e reproduzir os sinais correspondentes utilizando duas mãos robóticas.

Uma solução deste tipo poderia permitir que o projeto explorasse aplicações não apenas no ensino da robótica, mas também na área da **acessibilidade e comunicação em ambientes educativos**.

> **Importante:** A tradução de linguagem falada para língua gestual não está implementada na versão atual do ARMIAC. Trata-se de um objetivo de investigação e desenvolvimento futuro.

Para concretizar esta evolução seriam necessários vários desenvolvimentos adicionais, incluindo melhor articulação mecânica, sincronização de dois braços, processamento de voz, interpretação de língua gestual, desenvolvimento de software e sistemas de controlo mais avançados.

Caso tenha acesso aos recursos e orçamento necessários, pretendo continuar a desenvolver o ARMIAC e explorar esta vertente no futuro.

---

## Principais Funcionalidades

### Sistema Robótico

- Controlo individual dos servomotores
- Dedos robóticos articulados
- Sistema de movimento com fios de nylon
- ESP32 como microcontrolador principal
- Controlador PWM PCA9685
- Rede Wi-Fi local
- Comunicação através de HTTP
- Gestos predefinidos
- Estrutura personalizada impressa em 3D
- Movimento do antebraço

### Aplicação Flutter

- Estado de ligação ao ESP32
- Controlo para abrir e fechar a mão
- Controlo individual dos dedos
- Gestos rápidos
- Painel de movimentos
- Comandos de voz
- Suporte para português e inglês
- Tutorial integrado
- Lista de comandos de voz
- Página de configurações
- Página de Termos de Serviço

---

## Tecnologias Utilizadas

### Programação e Software

- **Flutter**
- **Dart**
- **C++ / Arduino**
- **Arduino IDE**
- **Visual Studio Code**
- **Tinkercad**
- **Ultimaker / Elegoo Cura**

### Hardware

- **ESP32**
- **PCA9685 — controlador PWM de 16 canais**
- **Servomotores**
- **Servo JX low-profile**
- **Fonte de alimentação DC 6V 10A**
- **Impressora 3D Elegoo Neptune 4**

### Comunicação

- **Wi-Fi**
- **HTTP**
- **I2C**
- **PWM**

---

## Arquitetura do Sistema

```text
                    SISTEMA ARMIAC

              ┌─────────────────────┐
              │ Aplicação Flutter   │
              │      Android        │
              └──────────┬──────────┘
                         │
                    Wi-Fi / HTTP
                         │
                         ▼
                 ┌─────────────┐
                 │    ESP32    │
                 └──────┬──────┘
                        │
                       I2C
                        │
                        ▼
                 ┌─────────────┐
                 │   PCA9685   │
                 └──────┬──────┘
                        │
                       PWM
                        │
                        ▼
                 ┌─────────────┐
                 │ Servomotores│
                 └──────┬──────┘
                        │
                        ▼
                 ┌─────────────┐
                 │ Mão Robótica│
                 └─────────────┘
```

O ESP32 cria uma rede Wi-Fi local e recebe comandos enviados pela aplicação Flutter através de pedidos HTTP.

Depois, o ESP32 comunica com o PCA9685 através de I2C. O PCA9685 gera os sinais PWM necessários para controlar os servomotores.

Desta forma, os comandos enviados pela aplicação são transformados em movimentos físicos da mão robótica.

---

## Configuração dos Servos

| Canal PCA9685 | Movimento controlado |
|---|---|
| PWM 0 | Base do polegar |
| PWM 1 | Polegar |
| PWM 2 | Dedo indicador |
| PWM 3 | Dedo médio |
| PWM 4 | Dedo anelar + mindinho |
| PWM 5 | Antebraço |

---

## Estrutura do Repositório

```text
armiac-pap/
│
├── app_flutter/
│   ├── assets/
│   ├── lib/
│   └── pubspec.yaml
│
├── arduino ide - esp32 code/
│
├── README.md
├── README.pt.md
├── Relatório PAP Final.pdf
├── PAP Final Report - English.pdf
├── Videos - EN.md
└── Videos - PT.md
```

### `app_flutter/`

Contém o código-fonte da aplicação móvel ARMIAC, desenvolvida em **Flutter e Dart**.

O código está organizado em páginas, serviços, definições, ficheiros de idioma e recursos da aplicação.

### `arduino ide - esp32 code/`

Contém o firmware desenvolvido para o **ESP32**, utilizando C++ e Arduino IDE.

O firmware é responsável por:

- Criar a rede Wi-Fi do ARMIAC
- Executar o servidor HTTP local
- Receber comandos enviados pela aplicação Flutter
- Comunicar com o PCA9685
- Controlar os servomotores
- Executar os movimentos e gestos programados

---

## Aplicação Flutter

A aplicação móvel ARMIAC foi desenvolvida e testada para **Android**.

O projeto utiliza packages como:

- `http`
- `speech_to_text`
- `flutter_tts`
- `shared_preferences`
- `package_info_plus`

### Instalar as dependências

```bash
cd app_flutter
flutter pub get
```

Caso as pastas específicas de plataforma do Flutter não estejam incluídas no repositório, podem ser recriadas com:

```bash
flutter create .
```

Depois, a aplicação pode ser executada com:

```bash
flutter run
```

### Gerar o APK Android

```bash
flutter build apk --release
```

---

## Firmware do ESP32

O firmware do ESP32 foi desenvolvido utilizando o **Arduino IDE**.

As principais bibliotecas utilizadas incluem:

```text
WiFi
WebServer
Wire
Adafruit PWM Servo Driver
```

O ESP32 funciona como o controlador principal do ARMIAC.

Recebe comandos enviados pela aplicação Flutter e envia instruções para o PCA9685, que controla os servomotores responsáveis pelos movimentos físicos da mão robótica.

---

## Comunicação

A aplicação móvel comunica com o ESP32 através de uma rede Wi-Fi local.

Não é necessária ligação à Internet para que a aplicação consiga comunicar com a mão robótica.

O fluxo básico de comunicação é:

```text
Utilizador
    ↓
Aplicação Flutter
    ↓
Pedido HTTP
    ↓
ESP32
    ↓
PCA9685
    ↓
Servomotor
    ↓
Movimento físico
```

---

## Modelação e Impressão 3D

A estrutura física do ARMIAC foi desenvolvida através de **modelação e impressão 3D**.

Durante a fase inicial do projeto foram estudados alguns modelos existentes como referência. Posteriormente, as peças foram adaptadas e redesenhadas de acordo com as necessidades específicas do projeto, tendo em conta:

- Dimensões dos servomotores
- Passagem dos fios
- Articulação dos dedos
- Encaixes mecânicos
- Organização dos componentes internos

O protótipo final foi impresso principalmente em **PLA branco**, utilizando uma impressora **Elegoo Neptune 4**.

---

## Dificuldades Encontradas

Durante o desenvolvimento do projeto surgiram vários desafios técnicos, incluindo:

- Falhas em impressões 3D
- Ajustes mecânicos
- Calibração dos servomotores
- Posicionamento dos fios dos dedos
- Instabilidade na alimentação elétrica
- Avaria de módulos PCA9685 durante os testes
- Configuração do Flutter e da variável PATH
- Aprendizagem de Dart e Flutter desde o início
- Integração entre software e hardware físico

A resolução destes problemas fez parte do processo de desenvolvimento e contribuiu significativamente para a aprendizagem adquirida ao longo do projeto.

---

## Documentação

O repositório contém a documentação final do projeto em português e inglês.

### Relatórios

- 🇵🇹 **Relatório Final da PAP — Português**
- 🇬🇧 **Final PAP Report — English**

### Vídeos de Demonstração

- 🇵🇹 [`Videos - PT.md`](Videos%20-%20PT.md)
- 🇬🇧 [`Videos - EN.md`](Videos%20-%20EN.md)

O relatório completo contém informação adicional sobre:

- Planeamento do projeto
- Hardware
- Componentes eletrónicos
- Modelação 3D
- Impressão 3D
- Montagem mecânica
- Programação do ESP32
- Desenvolvimento da aplicação Flutter
- Comunicação entre os sistemas
- Testes realizados
- Dificuldades técnicas
- Resultados finais
- Melhorias futuras
- Código-fonte

---

## Melhorias Futuras

Possíveis desenvolvimentos futuros incluem:

- Desenvolvimento de um segundo braço robótico
- Investigação de aplicações relacionadas com língua gestual
- Sensores de pressão nos dedos
- Melhor calibração dos servomotores
- Movimentos mais suaves e precisos
- Estrutura mecânica reforçada
- Melhor organização dos fios internos
- Perfis de movimentos personalizados
- Histórico de comandos
- Comunicação por Bluetooth
- Movimentos automáticos programados
- Melhor solução de bateria portátil
- Suporte para iOS
- Processamento de voz mais avançado
- Sincronização entre duas mãos robóticas

---

## Potencial Educativo e de Acessibilidade

O ARMIAC demonstra como várias áreas tecnológicas podem ser integradas num único projeto:

```text
Programação
     +
Eletrónica
     +
Robótica
     +
Desenvolvimento Mobile
     +
Redes
     +
Modelação 3D
     +
Impressão 3D
     ↓
   ARMIAC
```

O seu objetivo inicial é educativo, mas futuras versões poderão explorar aplicações mais avançadas relacionadas com **interação humano-computador, acessibilidade, tecnologias de apoio e comunicação através de língua gestual**.

---

## Autor

**Quévin Leonardo Aguiar Tavares**

Prova de Aptidão Profissional — 2025/2026  
Gestão e Programação de Sistemas Informáticos

GitHub: [KevinLeonardoHUB](https://github.com/KevinLeonardoHUB)

---

## Licença

Este repositório foi criado para fins **educativos, académicos e de portfólio**, no âmbito da minha Prova de Aptidão Profissional.

O desenvolvimento do ARMIAC poderá continuar para além da versão originalmente apresentada na PAP.