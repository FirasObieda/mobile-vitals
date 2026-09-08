#include <Wire.h>
#include "MAX30105.h"
#include "MPU9250_asukiaaa.h"
#include <Adafruit_MLX90614.h>
#include <SPI.h>
#include <Adafruit_GFX.h>
#include <Adafruit_ST7789.h>
#include <math.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

// --- Sensors ---
MAX30105 particleSensor;
MPU9250_asukiaaa imu;
Adafruit_MLX90614 mlx = Adafruit_MLX90614();

// --- Display ---
#define TFT_CS   7
#define TFT_RST  20
#define TFT_DC   10
Adafruit_ST7789 tft = Adafruit_ST7789(TFT_CS, TFT_DC, TFT_RST);

// --- BLE ---
#define SERVICE_UUID         "12345678-1234-1234-1234-1234567890ab"
#define CHARACTERISTIC_IR    "abcd0001-5678-90ab-cdef-1234567890ab"
#define CHARACTERISTIC_RED   "abcd0002-5678-90ab-cdef-1234567890ab"
#define CHARACTERISTIC_GREEN "abcd0003-5678-90ab-cdef-1234567890ab"

BLECharacteristic *irChar;
BLECharacteristic *redChar;
BLECharacteristic *greenChar;
bool deviceConnected = false;

// --- Constants ---
const uint32_t FINGER_THRESHOLD = 50000;
const unsigned long SAMPLE_INTERVAL_US = 2000;
const unsigned long DISPLAY_INTERVAL_MS = 500;
const int yOffset = 24;       
const int lineHeight = 16;    

// --- MPU variables ---
float aX, aY, aZ, aSqrt;
int stepCount = 0;
float lastAccelMag = 0;
unsigned long lastStepTime = 0;
const float STEP_THRESHOLD = 1.15;
const unsigned long STEP_DEBOUNCE_MS = 400;
String activityStatus = "Idle";

// --- Timing ---
unsigned long lastSampleTime = 0;
unsigned long lastDisplayTime = 0;

// --- BLE Callbacks ---
class MyServerCallbacks : public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) { deviceConnected = true; }
  void onDisconnect(BLEServer* pServer) { deviceConnected = false; }
};

// --- Center Text Helper ---
void centerText(String text, int y, uint16_t color = ST77XX_WHITE) {
  int16_t x1, y1;
  uint16_t w, h;
  tft.getTextBounds(text, 0, y, &x1, &y1, &w, &h);
  int16_t x = (tft.width() - w) / 2;
  tft.setCursor(x, y);
  tft.setTextColor(color);
  tft.print(text);
}

// --- Step/Activity Detection ---
void updateStepCounter(float aX, float aY, float aZ) {
  float accelMag = sqrt(aX * aX + aY * aY + aZ * aZ);
  unsigned long now = millis();

  if (accelMag > STEP_THRESHOLD && lastAccelMag <= STEP_THRESHOLD) {
    if (now - lastStepTime > STEP_DEBOUNCE_MS) {
      stepCount++;
      lastStepTime = now;
    }
  }
  lastAccelMag = accelMag;

  if (accelMag < 1.05) activityStatus = "Idle";
  else if (accelMag < 1.5) activityStatus = "Walking";
  else activityStatus = "Running";
}

// --- Display Update ---
void updateDisplay(uint32_t ir, uint32_t red, uint32_t green, float mlxTemp, bool fingerDetected) {
  tft.fillScreen(ST77XX_BLACK);
  tft.setTextSize(2);
  int y = yOffset;

  centerText(deviceConnected ? "BLE: Connected" : "BLE: Waiting", y, ST77XX_CYAN); y += lineHeight;
  if (fingerDetected) {
    centerText("Finger Detected ✅", y, ST77XX_GREEN); y += lineHeight;
    centerText("IR: " + String(ir), y, ST77XX_RED); y += lineHeight;
    centerText("RED: " + String(red), y, ST77XX_ORANGE); y += lineHeight;
    centerText("GREEN: " + String(green), y, ST77XX_GREEN); y += lineHeight;
    centerText("Skin Temp: " + String(mlxTemp) + " C", y, ST77XX_YELLOW); y += lineHeight;
  } else {
    centerText("Place finger on sensor", y, ST77XX_RED); y += lineHeight;
  }
  centerText("Steps: " + String(stepCount), y, ST77XX_BLUE); y += lineHeight;
  centerText("Activity: " + activityStatus, y, ST77XX_MAGENTA);
}

void setup() {
  Serial.begin(115200);
  Wire.begin(8, 9);
  Wire.setClock(100000);

  // MAX30105
  if (!particleSensor.begin(Wire, I2C_SPEED_STANDARD)) {
    Serial.println("MAX30105 not found!");
    while (1);
  }
  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x1F);
  particleSensor.setPulseAmplitudeIR(0x1F);
  particleSensor.setPulseAmplitudeGreen(0x1F);

  // MPU
  imu.beginAccel();
  imu.beginGyro();

  // MLX
  if (!mlx.begin()) {
    Serial.println("MLX90614 not found!");
  }

  // Display
  tft.init(240, 280); // Important: fix resolution to match ST7789V2
  tft.setRotation(0);
  tft.fillScreen(ST77XX_BLACK);

  // BLE
  BLEDevice::init("Mobile Vitals Wearable");
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());
  BLEService *pService = pServer->createService(SERVICE_UUID);

irChar = pService->createCharacteristic(
    CHARACTERISTIC_IR,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);

redChar = pService->createCharacteristic(
    CHARACTERISTIC_RED,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);

greenChar = pService->createCharacteristic(
    CHARACTERISTIC_GREEN,
    BLECharacteristic::PROPERTY_READ | BLECharacteristic::PROPERTY_NOTIFY);

  irChar->addDescriptor(new BLE2902());
  redChar->addDescriptor(new BLE2902());
  greenChar->addDescriptor(new BLE2902());

  pService->start();
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->start();

  Serial.println("System ready.");
}

void loop() {
  unsigned long nowMicros = micros();
  if (nowMicros - lastSampleTime >= SAMPLE_INTERVAL_US) {
    lastSampleTime = nowMicros;

    uint32_t ir = particleSensor.getIR();
    uint32_t red = particleSensor.getRed();
    uint32_t green = particleSensor.getGreen();
    bool fingerDetected = ir > FINGER_THRESHOLD;

    // Read MLX
    float mlxTemp = mlx.readObjectTempC();

    // Read MPU
    if (imu.accelUpdate() == 0) {
      aX = imu.accelX();
      aY = imu.accelY();
      aZ = imu.accelZ();
      updateStepCounter(aX, aY, aZ);
    }

    // BLE notify
    if (deviceConnected && fingerDetected) {
      char payload[40];
      int len = snprintf(payload, sizeof(payload), "%lu,%lu,%lu\n", ir, red, green);
      if (len > 0) {
        irChar->setValue((uint8_t*)payload, len);
        irChar->notify();
      }
      redChar->setValue((uint8_t*)&red, sizeof(red)); redChar->notify();
      greenChar->setValue((uint8_t*)&green, sizeof(green)); greenChar->notify();
    }

    // Serial
    Serial.printf("BLE: %s | IR=%lu RED=%lu GREEN=%lu | Temp=%.1f C | Steps=%d | Activity=%s\n",
                  deviceConnected ? "Connected" : "Waiting",
                  ir, red, green, mlxTemp+7, stepCount, activityStatus.c_str());

    // Update display every DISPLAY_INTERVAL_MS
    if (millis() - lastDisplayTime >= DISPLAY_INTERVAL_MS) {
      lastDisplayTime = millis();
      updateDisplay(ir, red, green, mlxTemp, fingerDetected);
    }
  }
}
