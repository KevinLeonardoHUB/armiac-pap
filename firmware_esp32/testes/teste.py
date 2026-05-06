import cv2
import mediapipe as mp
import serial
import time
import math

PORTA = "COM3"   # <<< MUDE PARA SUA PORTA
BAUD = 115200

ser = serial.Serial(PORTA, BAUD, timeout=1)
time.sleep(2)

mp_hands = mp.solutions.hands
mp_draw = mp.solutions.drawing_utils

hands = mp_hands.Hands(
    max_num_hands=1,
    min_detection_confidence=0.75,
    min_tracking_confidence=0.75
)

cap = cv2.VideoCapture(0)

FRAMES_PARA_MUDAR = 5

stable = {"I": 0, "M": 0, "G": 0, "A": 0, "T": 0}
candidate = {"I": 0, "M": 0, "G": 0, "A": 0, "T": 0}
count = {"I": 0, "M": 0, "G": 0, "A": 0, "T": 0}

def send(k, v):
    ser.write(f"{k}{v}\n".encode())

def update_debounced(key, raw_value):
    if raw_value == candidate[key]:
        count[key] += 1
    else:
        candidate[key] = raw_value
        count[key] = 1

    if count[key] >= FRAMES_PARA_MUDAR and stable[key] != candidate[key]:
        stable[key] = candidate[key]
        send(key, stable[key])

def finger_closed_y(tip, pip):
    return tip.y > pip.y

def thumb_closed(lm, handed):
    tip = lm[4]
    ip  = lm[3]
    if handed == "Right":
        return tip.x < ip.x
    else:
        return tip.x > ip.x

def dist(a, b):
    return math.hypot(a.x - b.x, a.y - b.y)

A_LIGA = 0.085
A_DESLIGA = 0.105

while True:
    ok, img = cap.read()
    if not ok:
        break

    img = cv2.flip(img, 1)
    rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
    res = hands.process(rgb)

    if res.multi_hand_landmarks:
        hand_landmarks = res.multi_hand_landmarks[0]
        mp_draw.draw_landmarks(img, hand_landmarks, mp_hands.HAND_CONNECTIONS)
        lm = hand_landmarks.landmark

        handed = "Right"
        if res.multi_handedness:
            handed = res.multi_handedness[0].classification[0].label

        a_dist = dist(lm[4], lm[9])

        rawA = stable["A"]
        if stable["A"] == 0 and a_dist < A_LIGA:
            rawA = 1
        elif stable["A"] == 1 and a_dist > A_DESLIGA:
            rawA = 0

        update_debounced("A", rawA)

        rawI = 1 if finger_closed_y(lm[8],  lm[6])  else 0
        rawM = 1 if finger_closed_y(lm[12], lm[10]) else 0
        rawR = 1 if finger_closed_y(lm[16], lm[14]) else 0
        rawP = 1 if finger_closed_y(lm[20], lm[18]) else 0

        rawG = 1 if (rawR == 1 or rawP == 1) else 0
        rawT = 1 if thumb_closed(lm, handed) else 0

        if stable["A"] == 0:
            update_debounced("I", rawI)
            update_debounced("M", rawM)
            update_debounced("G", rawG)
            update_debounced("T", rawT)

        cv2.putText(img,
                    f"I{stable['I']} M{stable['M']} G{stable['G']} T{stable['T']} A{stable['A']}",
                    (15, 35), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255,255,255), 2)

    cv2.imshow("Mao -> Servos", img)
    if cv2.waitKey(1) & 0xFF == 27:
        break

cap.release()
ser.close()
cv2.destroyAllWindows()
