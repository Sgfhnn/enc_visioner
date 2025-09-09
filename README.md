# 🏦 Ethiopian Banknote Recognizer App for the Blind  
_A Flutter-based mobile app for recognizing Ethiopian birr denominations and reading them aloud for visually impaired users._

## Features
- Recognizes Ethiopian birr:10 , 50, 100, 200
- Audio feedback in Amharic, Oromo, Tigrigna, English(we are working on it for now English only)
- Camera-based recognition
- Volume buttons to capture
- AI-powered detection via Roboflow

## How It Works
1️⃣users use voice access or other app or built in features like Talkback to open the app by calling the name of the app
2️⃣ User selects language (im working on it )
3️⃣ Uses camera to capture banknote  
4️⃣ Sends image to Roboflow API  
5️⃣Gets the result and reads it aloud  
6⃣ Vibrates for confirmation

## Built With
- Flutter (Dart)
- Camera
- HTTP
- TTS (Text to Speech)
- Vibration
- Roboflow API


#There are some limitations to adjust like make it offline etc..


[📥To Download voice access app from Google play store ](https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://play.google.com/store/apps/details%3Fid%3Dcom.google.android.apps.accessibility.voiceaccess%26hl%3Den_US%26referrer%3Dutm_source%253Dgoogle%2526utm_medium%253Dorganic%2526utm_term%253Dvoice%2Baccess%2Bapp%26pcampaignid%3DAPPU_1_40p_aJrrHMLskdUP1pSbqAg&ved=2ahUKEwja6NWjhdCOAxVCdqQEHVbKBoUQ5YQBegQIChAC&usg=AOvVaw3U-LIHXWdU_Qv0kmA25Fe1)



![Flutter](https://img.shields.io/badge/flutter-v3.22-blue)
