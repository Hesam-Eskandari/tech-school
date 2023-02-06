# Flutter Basics

- Learn [Dart](https://www.darttutorial.org/) programming language
- Use [Dartpad](https://dartpad.dev/?) web-based Dart playground to practice and test dart codes.
- Flutter is a Dart UI framework which can build cross-platform user interfaces for web, Android, and IOS devices.
- Widget
  - Building a hierarchy of elements is an intuitive approach to make a UI app.  
  - For example in HTML an element can have attributes such as style and class, it can also have children elements.
  - These elements are called widgets in Flutter.  
  - The best source to find a proper widget and learn about it is the [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)

- Create a new Flutter project
  - Command: `flutter create <snake_case_project_name>`  
  - It will create a new directory with all dependencies installed

- Install (add) a third-party package:
  - Command: `flutter pub add <package-name>`  
  - Import: `import 'package:<package-name>/filename.dart'`  
  - It will add the package as dependency to `pubspec.yaml` file.
  - `pubspec.yaml` is similar to `package.json`  
  - An alternative solution is to add package to dependencies in `pubspec.yaml` and run:
    - `flutter packages get`
- Run app on emulator or an actual device:
  - Install and run Android Studio
  - Add virtual device in Device Manager or just connect your Android device with developer options activated.
  - Run `flutter run` in the root directory of the Flutter project.  
- All the codes we develop live in the `lib` directory.
- Flutter runs the `main()` function of the `lib/main.dart` file by default.  

### Material Widgets
- A custom-made widget can be one of the three types of widgets:
  - Stateless: it extends the `StatelessWidget` class
  - Stateful: it extends the `StatefulWidget` class
  - Custom State: it extends `State<type>` class  
  - Requirement: `import 'package:flutter/material.dart';`  

- Any of the three base classes include an abstract `build()` method:
  - `Widget build(BuildContext context) {}`  
  - Flutter runs the `build()` method of a widget when:
    - The widget's constructor is called (= The widget class is instantiated)
    - The widget's `setState()` callback method is called (available for stateful widgets)
  - Building a widget renders it in UI
  - The build method bust be override by the inherited widget  
  - The return type of the build method is `Widget`.

- `MaterialApp` is the base widget for home application.
  - It can have title, theme, home, etc properties
  - We can set default app theme, the app title, and the main widget to run as home
  
Example:
```
    import 'package:flutter/material.dart';
    
    void main() => runApp(MyApp());
    
    class MyApp extends StatelessWidget {
    
        @override
        Widget build(BuildContext context) {
            return MaterialApp(
                title: 'Title',
                home: Text('Hello World!'),
        }
    }
```
