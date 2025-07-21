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
2️⃣ User selects language (we are working on it )
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

[📥To Download The app as apk](https://api.codemagic.io/artifacts/751e8605-2652-477f-a5e9-ce511bb1ebb6/e3276f07-ed70-4218-a04d-cf689016117c/app-release.apk)

[📥To Download The app as aab](https://api.codemagic.io/artifacts/166edcb9-6d7d-4a98-bc92-706e6aef1333/d13392fe-44a0-41fe-8db8-484d11a7d86b/app-debug.aab)

![Flutter](https://img.shields.io/badge/flutter-v3.22-blue)
