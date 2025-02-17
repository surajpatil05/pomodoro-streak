# Pomodoro_Streak App

## Description

## Features
- Focus and break sessions with customizable durations.
- Start, Pause, and Resume timer functionality.
- Tracks cycles and time spent on tasks to build streak.
- Stores session data in a local database (SQLite).
- Custom Bottom sheet for selecting timeline options (Today, This Week, etc.).
- Notifications after each session is completed.
- Notifications while live timer session is running.
- Responsive UI with a clean and intuitive design.
- Minimalistic Dark Theme
- Information about the Pomodoro Technique.
- Tablet device support
- haptics vibration on start, pause, stop, reset, focus, break, information buttons

## Mobile Screenshots
<img src="./app_screenshots/FocusMode_Screenshot_Mobile.png" alt="Focus Mode" width="50%"/>
<img src="./app_screenshots/BreakMode_Screenshot_Mobile.png" alt="Break Mode" width="50%"/>
<img src="./app_screenshots/infoScreen_Screenshot_Mobile.png" alt="information dialogue" width="50%"/>

## Tablet Screenshots
<img src="./app_screenshots/FocusMode_Screenshot_Tablet.png" alt="Focus Mode" width="50%"/>
<img src="./app_screenshots/BreakMode_Screenshot_Tablet.png" alt="Break Mode" width="50%"/>
<img src="./app_screenshots/infoScreen_Screenshot_Tablet.png" alt="information dialogue" width="50%"/>

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/pomodoro-timer.git
   ```
2. Navigate to the project directory:
   ```bash
   cd pomodoro-timer
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

### **Usage**
```markdown
## Usage
- Start a focus session by tapping the **Focus Mode** Start Button in the Bottom.
- Switch to a break session using the **Break Mode** tab.
- View session statistics by selecting a timeline in the bottom sheet.

## Dependencies

The following dependencies are used in this project:

1. **[cupertino_icons: ^1.0.8](https://pub.dev/packages/cupertino_icons)**
   - Provides iOS-style icons for use in Flutter applications.

2. **[flutter_riverpod: ^2.6.1](https://pub.dev/packages/flutter_riverpod)**
   - A state management library that simplifies and enhances state management in Flutter apps.

3. **[sqflite: ^2.4.1](https://pub.dev/packages/sqflite)**
   - A plugin for SQLite database management in Flutter applications.

4. **[path: ^1.9.0](https://pub.dev/packages/path)**
   - A library for manipulating file system paths across platforms.

5. **[intl: ^0.20.1](https://pub.dev/packages/intl)**
   - Provides internationalization and localization utilities, including date formatting.

6. **[flutter_local_notifications: ^18.0.1](https://pub.dev/packages/flutter_local_notifications)**
   - A plugin for displaying local notifications on Android and iOS.

7. **[permission_handler: ^11.3.1](https://pub.dev/packages/permission_handler)**
   - A plugin for checking and requesting permissions across platforms.

---

### Installing Dependencies

Run the following command to install the dependencies:

```bash
flutter pub get


## 🚀 Features to be Added in Future Versions  

✅ Below are some exciting features planned for upcoming versions of PomodoroStreak:  

- [ ] **Screen Always On** → Keep the screen awake while the timer is running.  
- [ ] **Custom Timer Completion Sounds** → Allow users to **select different sounds** after the timer ends.  
- [ ] **Dark/Light Mode Toggle** → Add a **theme switch button** for easy UI customization.  
- [ ] **Celebratory Effects** → Add **glitter/crackers animations** or a **flashing background** when the timer completes.  
- [ ] **Final 10-Second Effect** → When the timer reaches **10 seconds**, make it **pop, change colors, and animate** in size.  
- [ ] **Streak Achievement Card** → Display a **small card** to flex the user's productivity streak.  
- [ ] **Daily Reminder** → Send a **push notification** reminding users to use the Pomodoro timer.  
- [ ] **Start Timer Beep Sound** → Play a **beep sound** when the user taps the **Start** button.  
- [ ] **In-App Review Prompt** → Show a **review popup** after a certain number of app launches (e.g., after a week of use).  
- [ ] **App Version & Build Info** → Display **app version & build number** at the bottom of the app UI.  



## 📌 Future Fixes & Improvements  
✅ Below are some planned enhancements for the PomodoroStreak app:

- [ ] **Move Reset Button** → Place it below the **Start** button instead of in the top right corner.  
- [ ] **Fix Weekly Display Issue** → Ensure "This Week" is displayed in **one line** instead of two.  
- [ ] **Pause & Resume in Timer Notification** → Add a **pause/resume** button directly in notifications.  
- [ ] **Improve Dropdown Filters** → Remove unnecessary gaps so that all options are **visible at once**.  
- [ ] **Enhance Timer UI** → Make the timer and its **duration selection animations more interactive**.  
- [ ] **Daily Motivation** → Display a **"Quote of the Day"** at the top of the app to keep users inspired.  



