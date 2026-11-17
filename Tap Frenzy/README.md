
# 🎮 Tap Frenzy – Neon Challenge

Tap Frenzy is a fun, fast-paced tapping game built using **SwiftUI** for iOS.

Challenge your tapping speed, beat the countdown timer, achieve the highest score, and compete against your personal best!

## ✨ Features

- 🎯 **Fast-Paced Gameplay** – Tap the button as many times as possible before time runs out.
- ⏱️ **Customisable Timer** – Choose between 5, 10, or 20-second rounds.
- 🏆 **Best Score Tracking** – Automatically saves your highest score.
- 📊 **Games Played Counter** – Keeps track of completed rounds.
- 💗 **Neon UI Design** – Attractive pink neon theme with glowing effects.
- ✨ **Animated Background** – Falling sparkle animations.
- 📳 **Haptic Feedback** – Provides vibration feedback when tapping.
- 🔄 **Play Again** – Restart the game and try to beat your previous score.
- 💾 **Local Data Storage** – Saves game statistics using AppStorage.

## 🛠️ Technologies Used

- Swift
- SwiftUI
- Combine
- UIKit
- Xcode
- AppStorage

## 📱 Game Screens

### Main Game Screen

- Displays the game title.
- Shows current score and best score.
- Allows players to select round duration.
- Displays the countdown timer.
- Provides an interactive neon tapping button.
- Shows total games played.

### Game Over Screen

- Displays the final score.
- Highlights a new best score.
- Provides a Play Again button.

## 📂 Project Structure

```text
Tap Frenzy/
│
├── Tap_FrenzyApp.swift
│
├── Models/
│   └── GamePhase.swift
│
├── Managers/
│   └── GameManager.swift
│
├── Views/
│   ├── ContentView.swift
│   ├── ScoreCard.swift
│   ├── TimerView.swift
│   └── GameOverPopup.swift
│
├── Components/
│   ├── NeonGlassPanel.swift
│   ├── NeonTapButton.swift
│   ├── SparkleField.swift
│   └── FallingSparkle.swift
│
└── Assets.xcassets/
```

## 🎮 How to Play

1. Launch Tap Frenzy.
2. Select your preferred round duration:
   - 5 Seconds
   - 10 Seconds
   - 20 Seconds
3. Tap the neon button to start the game.
4. Keep tapping as quickly as possible.
5. Try to achieve the highest score before the countdown reaches zero.
6. Check your final score.
7. Select **Play Again** to start another round.

## 🏗️ Installation and Setup

### Requirements

- macOS
- Xcode
- iOS Simulator or a compatible iPhone
- Swift-compatible development environment

### Steps

1. Clone or download this repository.

2. Open the project folder.

3. Open the Xcode project:

   ```bash
   open "Tap Frenzy.xcodeproj"
   ```

4. Select an iOS Simulator or connected iPhone.

5. Build and run the application using:

   ```text
   Command + R
   ```

## 💾 Data Storage

Tap Frenzy uses SwiftUI's `@AppStorage` to store game statistics locally.

| Storage Key | Description |
|---|---|
| bestScore | Highest score achieved |
| gamesPlayed | Total completed games |

The saved values remain available when the application is reopened.

## 🧩 Architecture

The application is organised into separate Swift files to improve readability, maintainability, and code reusability.

| Module | Responsibility |
|---|---|
| Models | Defines game states |
| Managers | Handles game logic and data |
| Views | Builds the main user interface |
| Components | Contains reusable UI elements |

## 🚀 Future Improvements

- Global leaderboard.
- Multiplayer mode.
- Sound effects and background music.
- Additional neon colour themes.
- Player profiles.
- Daily challenges.
- Achievement system.
- Game statistics and performance history.

## 👨‍💻 Developer

**Project Name:** Tap Frenzy – Neon Challenge

**Platform:** iOS

**Framework:** SwiftUI

**Language:** Swift

## 📄 License

This project is developed for educational and learning purposes.

---

**Tap Fast. Score High. Beat Your Best! 💗**
