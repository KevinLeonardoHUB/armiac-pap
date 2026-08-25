# ARMIAC — Intelligent Robotic Hand

**ARMIAC** is a robotic hand prototype developed as my **Professional Aptitude Project (PAP)** during the 2025/2026 academic year as part of the *Computer Systems Management and Programming* vocational course.

The project combines **robotics, electronics, embedded systems, 3D printing, networking, and mobile application development** into a functional prototype.

ARMIAC consists of a 3D-printed articulated robotic hand controlled by an **ESP32** and a **PCA9685 PWM controller**. A mobile application developed with **Flutter and Dart** communicates with the ESP32 over a local Wi-Fi network using HTTP requests.

The application allows the user to control individual finger movements, open and close the hand, execute predefined gestures, and interact with the robotic system through both on-screen controls and voice commands.

---

## Project Status

✅ **PAP version completed — 2025/2026**

The current version of ARMIAC is a functional prototype that includes:

* 3D-printed articulated robotic hand
* ESP32-based control system
* PCA9685 servo controller
* Multiple servomotors
* Flutter Android application
* Wi-Fi communication
* HTTP-based commands
* Individual finger control
* Predefined gestures
* Voice commands
* Portuguese and English interface
* Usage tutorial
* Final technical documentation
* Demonstration videos

**Current application version: 1.1.7**

Although the PAP version of the project is complete, I intend to continue developing ARMIAC in the future as resources and funding become available.

---

## Project Purpose

The original goal of ARMIAC was to create an **educational robotics platform** that could demonstrate how software and hardware interact in a real system.

The project was designed with the possibility of being used in environments such as:

* Schools
* Universities
* Technology institutes
* Vocational education
* Robotics clubs
* Programming and electronics classes
* STEM education programs

Through ARMIAC, students can explore concepts related to programming, mobile applications, robotics, networking, electronics, microcontrollers, 3D modeling, and 3D printing.

The project demonstrates how a command sent from a mobile application can travel through different technologies and ultimately produce a physical movement.

---

## Future Vision

During the development of ARMIAC, I realized that the project could potentially evolve beyond its original educational purpose.

One of the ideas I would like to explore in the future is the development of a **second robotic hand and arm**.

Using two robotic hands would make it possible to reproduce a much wider range of gestures and could open the possibility of developing an experimental system capable of converting **spoken language into sign-language gestures**.

For example, a future version of ARMIAC could potentially receive spoken input during a classroom lesson, process that information through software, and reproduce corresponding signs using two robotic hands.

This could allow the project to explore applications related not only to robotics education, but also to **accessibility and communication in educational environments**.

> **Important:** Sign-language translation is not implemented in the current version of ARMIAC. It is a future research and development goal.

Developing such a system would require significant additional work, including improved mechanical articulation, two-arm synchronization, speech processing, sign-language interpretation, software development, and more advanced robotic control.

If the necessary resources and funding become available, I plan to continue developing ARMIAC and investigate this direction further.

---

## Main Features

### Robotic System

* Individual servo control
* Articulated robotic fingers
* Nylon-based tendon mechanism
* ESP32 as the main microcontroller
* PCA9685 PWM servo controller
* Local Wi-Fi network
* HTTP communication
* Predefined hand gestures
* Custom 3D-printed structure
* Forearm movement

### Flutter Application

* ESP32 connection status
* Open and close hand controls
* Individual finger controls
* Quick-action gestures
* Movement control panel
* Voice commands
* Portuguese and English support
* Built-in tutorial
* Voice-command reference
* Settings page
* Terms of Service page

---

## Technologies

### Programming & Software

* **Flutter**
* **Dart**
* **C++ / Arduino**
* **Arduino IDE**
* **Visual Studio Code**
* **Tinkercad**
* **Ultimaker / Elegoo Cura**

### Hardware

* **ESP32**
* **PCA9685 16-channel PWM controller**
* **Servomotors**
* **JX low-profile servo**
* **6V 10A DC power supply**
* **Elegoo Neptune 4 3D printer**

### Communication

* **Wi-Fi**
* **HTTP**
* **I2C**
* **PWM**

---

## System Architecture

```text
                    ARMIAC SYSTEM

              ┌─────────────────────┐
              │ Flutter Android App │
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
                 │ Servomotors │
                 └──────┬──────┘
                        │
                        ▼
                 ┌─────────────┐
                 │ Robotic Hand│
                 └─────────────┘
```

The ESP32 creates a local Wi-Fi network and receives commands from the Flutter application through HTTP.

The ESP32 communicates with the PCA9685 using I2C. The PCA9685 then generates the PWM signals required to control the servomotors.

This allows commands from the mobile application to be converted into physical movements of the robotic hand.

---

## Servo Configuration

| PCA9685 Channel | Controlled Movement         |
| --------------- | --------------------------- |
| PWM 0           | Thumb base                  |
| PWM 1           | Thumb                       |
| PWM 2           | Index finger                |
| PWM 3           | Middle finger               |
| PWM 4           | Ring finger + little finger |
| PWM 5           | Forearm                     |

---

## Repository Structure

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
├── Relatório PAP Final.pdf
├── PAP Final Report - English.pdf
├── Videos - EN.md
└── Videos - PT.md
```

### `app_flutter/`

Contains the source code of the ARMIAC mobile application developed using **Flutter and Dart**.

The source code is organized into pages, services, settings, localization files, and application resources.

### `arduino ide - esp32 code/`

Contains the firmware developed for the **ESP32** using C++ and the Arduino IDE.

The firmware is responsible for:

* Creating the ARMIAC Wi-Fi network
* Running the local HTTP server
* Receiving commands from the Flutter application
* Communicating with the PCA9685
* Controlling the servomotors
* Executing predefined hand movements

---

## Flutter Application

The ARMIAC mobile application was developed and tested for **Android**.

The project uses packages such as:

* `http`
* `speech_to_text`
* `flutter_tts`
* `shared_preferences`
* `package_info_plus`

### Install dependencies

```bash
cd app_flutter
flutter pub get
```

If the platform-specific Flutter folders are not included in the repository, they can be regenerated with:

```bash
flutter create .
```

The application can then be executed with:

```bash
flutter run
```

### Build the Android APK

```bash
flutter build apk --release
```

---

## ESP32 Firmware

The ESP32 firmware was developed using the **Arduino IDE**.

Main libraries include:

```text
WiFi
WebServer
Wire
Adafruit PWM Servo Driver
```

The ESP32 acts as the main controller of ARMIAC.

It receives commands from the Flutter application and sends instructions to the PCA9685, which controls the servomotors responsible for the physical movement of the robotic hand.

---

## Communication

The mobile application communicates with the ESP32 through a local Wi-Fi network.

No Internet connection is required for communication between the application and the robotic hand.

The basic communication flow is:

```text
User
 ↓
Flutter App
 ↓
HTTP Request
 ↓
ESP32
 ↓
PCA9685
 ↓
Servomotor
 ↓
Physical Movement
```

---

## 3D Design and Manufacturing

The physical structure of ARMIAC was created using **3D modeling and 3D printing**.

Some initial models were studied as references during the early development phase. The final pieces were adapted and redesigned according to the requirements of the project, including:

* Servo dimensions
* Cable routing
* Finger articulation
* Mechanical connections
* Internal component placement

The final prototype was printed primarily using **white PLA** on an **Elegoo Neptune 4** 3D printer.

---

## Challenges

Several technical challenges were encountered during development, including:

* Failed 3D prints
* Mechanical adjustments
* Servo calibration
* Finger tendon positioning
* Power-supply instability
* Damaged PCA9685 modules during testing
* Flutter installation and PATH configuration
* Learning Dart and Flutter from the beginning
* Integrating software with physical hardware

Solving these problems was an important part of the development process and contributed significantly to the technical knowledge gained from the project.

---

## Documentation

The repository contains the final project documentation in both Portuguese and English.

### Reports

* 🇵🇹 **Final PAP Report — Portuguese**
* 🇬🇧 **Final PAP Report — English**

### Demonstration Videos

* 🇬🇧 [`Videos - EN.md`]
* 🇵🇹 [`Videos - PT.md`]

The complete report contains additional information about:

* Project planning
* Hardware
* Electronic components
* 3D modeling
* 3D printing
* Mechanical assembly
* ESP32 programming
* Flutter development
* System communication
* Testing
* Technical difficulties
* Final results
* Future improvements
* Source code

---

## Future Improvements

Possible future developments include:

* Development of a second robotic arm
* Research into sign-language applications
* Pressure sensors on the fingers
* Improved servo calibration
* More precise and smoother movements
* Reinforced mechanical structure
* Better internal cable management
* Custom movement profiles
* Command history
* Bluetooth communication
* Automated programmed movements
* Improved portable battery solution
* iOS application support
* More advanced speech processing
* Synchronization between two robotic hands

---

## Educational and Accessibility Potential

ARMIAC demonstrates how several areas of technology can be integrated into a single project:


Programming
      +
Electronics
      +
Robotics
      +
Mobile Development
      +
Networking
      +
3D Modeling
      +
3D Printing
      ↓
    ARMIAC


Its original purpose is educational, but future versions could explore broader applications involving **human-computer interaction, accessibility, assistive technologies, and sign-language communication**.

---

## Author

**Quévin Leonardo Aguiar Tavares**

Professional Aptitude Project — 2025/2026
Computer Systems Management and Programming

GitHub: [KevinLeonardoHUB](https://github.com/KevinLeonardoHUB)

---

## License

This repository was created for **educational, academic, and portfolio purposes** as part of my Professional Aptitude Project.

Further development of ARMIAC may continue beyond the original PAP project.
