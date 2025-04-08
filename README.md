# Blood Bank Management

A new Flutter project created with FlutLab - [https://flutlab.io](https://flutlab.io)

This application is designed for managing blood bank operations, including user authentication, blood inventory, donor management, and potentially request handling. It utilizes Firebase for backend services.

## Getting Started

A few resources to get you started if this is your first Flutter project:

* [Flutter Documentation](https://flutter.dev/docs): Offers tutorials, samples, guidance on mobile development, and a full API reference.
* [Flutter Codelab](https://flutter.dev/docs/get-started/codelab): Provides hands-on experience with Flutter development.
* [Flutter Cookbook](https://flutter.dev/docs/cookbook): Contains recipe-style answers to common Flutter development questions.

### Getting Started with FlutLab

* **How to use FlutLab?** Please view the [FlutLab Documentation](https://flutlab.io/docs).
* **Join the discussion:** Connect with other FlutLab users on [FlutLab Residents](https://flutlab.io/residents).

## Firebase Integration

This project leverages Firebase for various backend functionalities, including:

* **Authentication:** Securely manages user sign-up and sign-in using Firebase Authentication.
* **Database:** Stores and retrieves application data such as blood inventory, donor details, and potentially blood requests using Firebase (e.g., Firestore or Realtime Database).

### Important Firebase Configuration Files

To run this application, you need to configure Firebase for your project. This involves the following files:

* **`firebase_options.dart`:** This file contains the necessary Firebase project configuration details for different platforms (Android, iOS, Web). You will typically generate this file using the FlutterFire CLI. **Ensure this file is located in your project's `lib` directory.**

* **`google-services.json` (for Android):** This file contains your Android Firebase project configuration. You download this file from your Firebase console and should place it in the `android/app` directory of your Flutter project.

* **`GoogleService-Info.plist` (for iOS/macOS):** This file contains your iOS/macOS Firebase project configuration. You download this file from your Firebase console and should place it in the `ios/Runner` directory (for iOS) or `macos/Runner` directory (for macOS) of your Flutter project.

* **`firebase-config.js` (for Web):** This file contains your web Firebase project configuration. You'll typically add this configuration directly within your `web/index.html` file or in a separate JavaScript file included in your web build.

**Warning:** It is crucial to **add `google-services.json` and `GoogleService-Info.plist` to your `.gitignore` file** to prevent accidentally committing sensitive Firebase configuration details to your public repository.

## Installation

Follow these steps to set up and run the Blood Bank Management application:

1.  **Prerequisites:**
    * Flutter SDK installed on your machine. You can find installation instructions at [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install).
    * Firebase project created in the Firebase console ([https://console.firebase.google.com/](https://console.firebase.google.com/)).
    * FlutterFire CLI installed. Open your terminal or command prompt and run:
        ```bash
        dart pub global activate flutterfire_cli
        ```

2.  **Cloning the repository:**
    ```bash
    git clone [https://github.com/Asmita1507/Blood_Bank_Management.git](https://www.google.com/search?q=https://github.com/Asmita1507/Blood_Bank_Management.git)
    cd Blood_Bank_Management
    ```

3.  **Setting up Firebase:**
    * Go to your Firebase console and add your Android, iOS, and/or web apps to your Firebase project. Follow the console instructions for each platform.
    * Download the `google-services.json` file (for Android) and place it in the `android/app` directory.
    * Download the `GoogleService-Info.plist` file (for iOS/macOS) and place it in the `ios/Runner` directory (for iOS) or `macos/Runner` directory (for macOS).
    * For web, follow the Firebase console instructions to get your web configuration snippet. You'll typically add this to your `web/index.html` file.
    * Run the FlutterFire CLI to generate the `firebase_options.dart` file. In your project's root directory, run:
        ```bash
        flutterfire configure
        ```
        Select your Firebase project and the platforms you are targeting.

4.  **Getting Flutter dependencies:**
    Open your terminal or command prompt in the project's root directory and run:
    ```bash
    flutter pub get
    ```

5.  **Running the application:**
    ```bash
    flutter run
    ```

## Usage

This Blood Bank Management application aims to provide the following functionalities:

* **User Authentication:** Secure registration and login for users (e.g., donors, administrators).
* **Blood Inventory Management:** Tracking the availability of different blood types and quantities.
* **Donor Management:** Maintaining records of blood donors.
* **(Potentially) Blood Request Management:** Allowing users to request specific blood types.

More detailed usage instructions will be added as the application develops.

## Contributing

Contributions to this project are welcome. If you have any suggestions, bug reports, or would like to contribute code, please feel free to open an issue or submit a pull request on the GitHub repository.

## License

This project does not currently have a specific license.

## Acknowledgements

Thank you to the Flutter and Firebase teams for providing excellent development tools and platforms. Also, thank you to FlutLab for the online IDE that facilitated the initial project creation.
