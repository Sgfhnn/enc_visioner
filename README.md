# 🏦 Birr Vision - Ethiopian Banknote Recognizer

A Flutter-based mobile app designed to assist visually impaired users in recognizing Ethiopian Birr banknotes. The app uses AI object detection (Roboflow) to identify denominations and provides audio feedback in multiple local languages.

## ✨ Features

-   **💷 Detects Ethiopian Birr**: Recognizes 10, 50, 100, and 200 ETB denominations.
-   **🗣️ Multi-Language Support**:
    -   **English** (Default)
    -   **Amharic** (አማርኛ)
    -   **Oromo** (Afaan Oromoo)
    -   **Tigrigna** (ትግርኛ)
    -   *includes smart off-line fallback to English pronunciation if local voices are missing.*
-   **🔊 Audio Feedback**: Reads the detected denomination aloud.
-   **📳 Haptic Feedback**: Vibrates upon successful detection.
-   **📸 Easy Capture**:
    -   Tap the large capture button.
    -   **Volume Buttons**: Press Volume Up or Down to capture (hardware shortcut).
-   **🤖 Auto-Detect Mode**: Automatically scans and announces banknotes when confidence is high (>70%).
-   **🎨 Premium UI**: Modern glassmorphism design with dark mode, animations, and high-contrast accessibility.

## 🚀 How It Works

1.  **Open the App**: Launch "Birr Vision". Use TalkBack or Voice Access if needed.
2.  **Select Language**: Choose your preferred language from the home screen.
3.  **Point & Capture**:
    -   Point the camera at a banknote.
    -   Press the **Volume Button** or the on-screen **Capture** button.
    -   Or enable **"Auto"** mode to let the app scan automatically.
4.  **Listen**: The app will vibrate and speak the value (e.g., "One Hundred Birr").

## 🛠️ Built With

-   **Flutter** (Dart)
-   **Roboflow API** (Object Detection)
-   **Flutter TTS** (Text-to-Speech)
-   **Hardware Keyboard Events** (Volume Capture)
-   **Google Fonts** (Outfit)
-   **Vibration**

## 📦 Installation

1.  Clone the repo:
    ```bash
    git clone https://github.com/Sgfhnn/enc_visioner.git
    ```
2.  Install dependencies:
    ```bash
    flutter pub get
    ```
3.  Run on device:
    ```bash
    flutter run
    ```

## 🤝 Contributing

Contributions are welcome! Please fork the repository and submit a pull request.
