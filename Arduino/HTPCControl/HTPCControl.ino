#include <IRremote.h>   
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27,16,2);  // Устанавливаем дисплей

int RECV_PIN = 2; // Пин подключения IR приёмника 
IRrecv irrecv(RECV_PIN); 
decode_results results; // Код клавиши пульта управления   
int data, toggle, prevToggle;

void setup() 
{ 
  Serial.begin(9600); 
  Serial.println("Setup HTPC Control");

  // ИК приемник
  Serial.println("Enabling IRin");
  irrecv.enableIRIn(); // Включаем приемник
  Serial.println("Enabled IRin");
  
  // LCD
  lcd.init();                     
  lcd.backlight();// Включаем подсветку дисплея
  lcd.setCursor(2, 0);
  lcd.print("HTPC Control");
  lcd.setCursor(8, 1);
  lcd.print("LCD 1602");

  prevToggle = -1; // Начальное значение, в оригинале может быть только 0 или 1
}   

void loop() 
{ 
  // Отслеживаем получение сигнала от ИК порта  
  if (irrecv.decode(&results)) { 
    switch (results.decode_type) {
      case RC5: // Если пульт работает по протоколу RC5

        // Бит повтора
        toggle = bitRead(results.value, 11);  

        // Читаем только код команды
        data = 0;
        for (int i = 0;  i < 6;  i++) {
          data = data << 1 | bitRead(results.value, i);
        }

        // Слишком бцстро приходит повтор команды, 
        // после песле первой команды, не повтора делаем паузу
        if (prevToggle != toggle) {
          // Выводим код клавиши в порт
          Serial.println(data, DEC); 
          delay(100);
        } else {
          Serial.println(0xFFFFFFFF, DEC); 
        }
        prevToggle = toggle;
        break;
      default:
        // Выводим код клавиши в порт  
        Serial.println(results.value, DEC); 
    };
    // Получение следующхи данных
    irrecv.resume();
  }

  // Если что-то передали в порт
  if (Serial.available() > 0) {
    lcd.setCursor(0, 1);
    lcd.print(Serial.readString());
  }

  delay(100);
}  
