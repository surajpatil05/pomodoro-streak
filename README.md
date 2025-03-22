# PomodoroStreak App
**PomodoroStreak** is a time management app based on the **Pomodoro Technique**, designed to boost productivity by breaking work into **focused intervals** with **scheduled breaks**.  

![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)

## 📲 Download PomodoroStreak  
Experience **enhanced productivity** with PomodoroStreak! Get it now on the **Google Play Store**:

<a href="https://play.google.com/store/apps/details?id=com.skyverse.pomodoro_streak">
  <img src="https://img.shields.io/badge/Download_on_Google_Play-4285F4?style=for-the-badge&logo=google-play&logoColor=white" alt="Google Play Badge"/>
</a>

- 📌 **Total Downloads:** 5+ 
- ⭐ **Average Rating:** N/A  

![App Banner](./app_screenshots/promo-banner.png)  

### **Or Scan the QR Code to Download**
<img src="./app_screenshots/qr-code.jpg" alt="QR Code" width="200px"/>


## 🚀 Features  

- **Customizable Focus & Break Sessions** → Set custom session durations.  
- **Start, Pause, Resume & Reset Timer** → Control your session effortlessly.  
- **Track Cycles & Streaks** → Monitor your productivity over time.  
- **Local Storage with SQLite** → Saves session history & streaks.  
- **Dynamic Bottom Sheet** → Select **Today, This Week, etc.** for insights.  
- **Live Notifications** → Get **alerts** when a session completes.  
- **Dark Theme Support** → Minimalist **dark mode** for better visuals.  
- **Tablet Support** → Optimized layout for larger screens.  
- **Haptic Feedback** → Subtle vibrations for important actions.  


## 📱 Screenshots  

### 📲 **Mobile Version**  
<p align="center">
  <img src="./app_screenshots/FocusMode_Screenshot_Mobile.png" alt="Focus Mode" width="30%"/>  
  <img src="./app_screenshots/BreakMode_Screenshot_Mobile.png" alt="Break Mode" width="30%"/>  
  <img src="./app_screenshots/infoScreen_Screenshot_Mobile.png" alt="Information Dialogue" width="30%"/>  
</p>  

### 💻 **Tablet Version**  
<p align="center">
  <img src="./app_screenshots/FocusMode_Screenshot_Tablet.png" alt="Focus Mode" width="30%"/>  
  <img src="./app_screenshots/BreakMode_Screenshot_Tablet.png" alt="Break Mode" width="30%"/>  
  <img src="./app_screenshots/infoScreen_Screenshot_Tablet.png" alt="Information Dialogue" width="30%"/>  
</p>  


## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/pomodoro-timer.git
   ```
2. Navigate to the project directory:
   ```bash
   cd pomodoro-streak
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```


### 💡 Usage Guide

- 🎯 Start a Focus Session → Tap the Start Button under Focus Mode.
- ☕ Switch to Break Mode → Tap the Break Mode tab.
- 📊 View Session Statistics → Open the Bottom Sheet to select Today, This Week, etc.


### 📦 Dependencies

The following Flutter packages power PomodoroStreak:

| Package                        | Purpose                                   |
|--------------------------------|-------------------------------------------|
| `cupertino_icons`             | iOS-style icons                           |
| `flutter_riverpod`            | State management                         |
| `sqflite`                      | Local database management                 |
| `path`                         | File system path handling                 |
| `intl`                         | Date & time formatting                    |
| `flutter_local_notifications`  | Local notifications                       |
| `permission_handler`           | Permission management                     |
| `flutter_screenutil`           | Responsive UI scaling                     |
| `flutter_native_splash`        | Custom splash screen                      |
| `in_app_update`                | Handling in-app updates                   |
| `vibration`                    | Vibration feedback for haptic interactions |


### 🚀 Future Enhancements

✅ Below are some exciting features planned for upcoming versions of PomodoroStreak:

- 📱 Screen Always On → Prevent screen from locking while timer runs.
- 🔔 Custom Timer Completion Sounds → Allow users to select different alert tones.
- 🌗 Dark/Light Mode Toggle → Add a theme switch for UI customization.
- 🎉 Celebratory Animations → Show glitter or flashing background on completion.
- ⏳ Final 10-Second Effect → Timer pulses, changes colors, and animates.
- 🏆 Streak Achievement Card → Show motivational messages on long streaks.
- 🔔 Daily Reminder Notifications → Remind users to stay productive.
- 📢 Beep Sound on Start → Indicate that the timer has started.
- ⭐ In-App Review Prompt → Ask users for feedback after frequent usage.
- ℹ️ App Version & Build Info → Display app version at the bottom.


### 🔧 Planned Fixes & Improvements
✅ Below are improvements and fixes planned for the next update:

- 🔄 Move Reset Button: Relocate below the Start button for easier access.

- 📅 Fix Weekly, Monthly, All-Time Display Issue: Ensure "This Week", "This Month", and "All Time" fit in one line when selected from the dropdown.

- ⏯ Pause & Resume in Notifications: Add pause/resume buttons for better control during sessions.

- 📌 Improve Dropdown Filters: Remove unnecessary gaps to display all options at once.

- ⏳ Enhance Timer UI: Make animations smoother and more interactive.

- 💡 Daily Motivation Quote: Display an inspiring quote at the top of the app to motivate users.

- 📲 Guided Tour for First-Time Users: Add onboarding screens explaining Focus Mode, Break Streak, and other key features.

- 🔄 Fix Screen Rotation Issues: Ensure the timer UI remains stable when rotating the device or consider disabling rotation.

- 📏 Fix Timeline Text Alignment: Adjust text to prevent any overlapping or misalignment.

- 🖥 Improve Split-Screen Mode: Ensure smooth UI behavior when using split-screen or consider disabling this feature.

- ⚠ Prompt Before Closing Timer: Add a warning to prevent accidental exits while a session is running.

- ❌ Clear Live Timer Notification After App Is Killed: Ensure persistent notifications are removed when the app is closed.

- 🚫 Fix App Crash on Notification Click (After Killing App): Resolve crashes when clicking on notifications after the app has been force-closed.

- 🔒 Live Timer Notification Not Visible on Lock Screen: Fix the issue so that the timer notification appears correctly on the lock screen.

- 📱 Unexpected Phone Vibrations During Timer: Resolve unnecessary vibrations while the timer is running.


### Testers
I greatly appreciate the contributions of our testers who help ensure the quality and reliability of PomodoroStreak App.

Here are our dedicated testers:

- [![Tester: Snigdh](https://img.shields.io/badge/Tester-Snigdh-blue)](https://github.com/snigdhp)

- [![Tester: Jayesh](https://img.shields.io/badge/Tester-Jayesh-blue)](https://github.com/jayesh2020)
