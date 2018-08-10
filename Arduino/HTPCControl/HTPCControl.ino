#include <IRremote.h>   
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27,16,2);  // Устанавливаем дисплей

int RECV_PIN = 2; // Пин подключения IR приёмника 
IRrecv irrecv(RECV_PIN); 
decode_results results; // Код клавиши пульта управления   

void setup() 
{ 
  // IR приемник
  Serial.begin(9600); 
  irrecv.enableIRIn(); // Включаем приемник

  // LCD
  lcd.init();                     
  lcd.backlight();// Включаем подсветку дисплея
  lcd.setCursor(2, 0);
  lcd.print("HTPC Control");
  lcd.setCursor(8, 1);
  lcd.print("LCD 1602");
}   

void loop() 
{ 
  if (irrecv.decode(&results)) // Отслеживаем получение сигнала 
  { 
    Serial.println(results.value); // Выводим код клавиши в порт  
    irrecv.resume(); 
  }  
  delay(100);

  if (Serial.available() > 0) {
    lcd.setCursor(0, 1);
    lcd.print(Serial.readString());
  }
}  
