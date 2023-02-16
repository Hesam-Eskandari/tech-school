# Flutter Basics

- Learn [Dart](https://www.darttutorial.org/) programming language
- Use [Dartpad](https://dartpad.dev/?) web-based Dart playground to practice and test dart codes.
- Flutter is a Dart framework which can build cross-platform user interfaces for web, Android, and IOS devices.
- Widget
  - Building a hierarchy of elements is an intuitive approach to make a UI app.  
  - For example in HTML an element can have attributes such as style and class, it can also have children elements.
  - These elements are called widgets in Flutter.  
  - The best source to find a proper widget and learn about it is the [Flutter Widget Catalog](https://docs.flutter.dev/development/ui/widgets)
  - A flutter app is made of a tree of widgets.  

- Create a new Flutter project
  - Command: `flutter create <snake_case_project_name>`  
  - It will create a new directory with all dependencies installed

- Install (add) a third-party package:
  - Command: `flutter pub add <package-name>`  
  - Import: `import 'package:<package-name>/<filename>.dart'`  
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
  - The build method must be overridden by the inherited widget  
  - The return type of the build method is `Widget`.

- `MaterialApp` is the base widget for the application home.
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
                home: Text('Hello World!'), // Use Scaffold() later
        }
    }
```

Note: The `runApp()` method and `MaterialApp` widget are implemented in the `flutter` package.

## Scaffold
- [Scaffold](https://api.flutter.dev/flutter/material/Scaffold-class.html) is a widget which provides the base page design and styling.  
- It is provided in the `flutter` package.  
- It can set `appBar`, `body` and other properties with custom-made widgets.  
- Use the [AppBar](https://api.flutter.dev/flutter/material/AppBar-class.html) widget for Scaffold's `appBar` property.  
- Use a custom-made widget as the `body` property.  

## Visible vs Invisible Widgets
- Visible widgets have output (draw) on UI such as ElevatedButton(), Card(), Text()
- Invisible widgets won't show anything themselves on UI, but they set styling and structure
for their child/children widgets. Such as Row(), ListView().
- Container() widget is invisible but can become visible given specific styling. It is similar to HTML `<div>` tag.

## Buttons
- child: is another widget such as Text()
- onPressed: accepts a callback function and triggers when the button is pressed
- onSubmitted: accepts a callback function and triggers when the keyboard "Enter" is tapped
- Button widgets: [link](https://docs.flutter.dev/development/ui/widgets/material#Buttons)
- Two ways of passing the callback function:
  - Assume the function name is connect()
  - Approach one: `onPressed: connect`  
  - Approach two: `onPressed: () => connect()`
  - The second approach allows you to pass arguments.

## State
- State of an object is the data the object (widget) is holding.
- A stateless widget can only show (build UI of) its data when its constructor is called.
- If the internal data (properties) of a stateless widget changes, it won't get rebuilt and shown on UI.
- Use stateful widgets if the UI of the widget is supposed to change.  
- Once the stateful widget is ready to be rebuilt, the setState() method needs to be called.
- The sample code bellow does not update the UI after pressing the button because MyApp widget is stateless.
```
  import 'package:flutter/material.dart';
  
  void main() => runApp(MyApp());
  
  class MyApp extends StatelessWidget {
      var _textContent = 'Hello World!';
      @override
      Widget build(BuildContext context) {
          return MaterialApp(
              title: 'Title',
              home: Column(
                children: <widget>[
                  Text(_textContent),
                  ElevatedButton(
                    child: Text('Change Text'),
                    onPressed: () {_textContent = 'Changed Text';},
                    )
                ],
              ),
          );
      }
  }
```
- To make the code above work, we need to use a stateful widget:
```
  import 'package:flutter/material.dart';
  
  void main() => runApp(MyApp());
  
  class MyApp extends StatefulWidget {
    State<StatefulWidget> createState() {
      return MyAppState();
    }
  }
  
  class MyAppState extends State<MyApp> {
      var _textContent = 'Hello World!';
      @override
      Widget build(BuildContext context) {
          return MaterialApp(
              title: 'Title',
              home: Column(
                children: <Widget>[
                  Text(_textContent),
                  ElevatedButton(
                    child: Text('Change Text'),
                    onPressed: () {
                      setState(() {
                        _textContent = 'Changed Text';
                      });
                      }
                    )
                ],
              ),
          );
      }
  }
```

## Dart Notes
- Private class members start with underscore: `_textContent`  
- Private members are accessible through the same file (and not just the class)
- `final` properties are constant in runtime.
- `const` properties are constant compile time.
- If all properties of a widget are final, then the constructor can become constant (For stateless widgets).
- If a widget has a constant constructor, then it can have a const object: `const Text('Connect')`
- See the `Text` widget [constructors](https://api.flutter.dev/flutter/widgets/Text-class.html#constructors).

## Flutter Notes
- Since the state of a stateless widget cannot change after its creation, it is recommended to make all its properties `final`.
- Flutter refreshes the frame 60 times per second. It can also render 120 FPS if the device allows.
- When the build method of a widget is called, it recreates that widget and all widgets in the child subtree of it. 
- A developer creates the widget tree. Flutter creates two other trees internally. The element tree and the render tree.
- Each element in the element tree is pointing to a widget in the widget tree.
- The job of the widget tree is to configure the element and render trees.
- The element tree is responsible to connect the widget and render trees, manage state, and update the render tree when widget tree changes.
- If a widget is stateful, there exist an independent state object in the element tree which has a pointer from element and points to the latest created widget.
- When the `setState()` method is called, it creates a new widget, then the state object in the element tree points to it.
- All child widgets of the rebuilt widget also gets rebuilt. But all the corresponding elements may not get rebuilt.
- Flutter only rebuilds the elements that their corresponding widget UI is changed.
  - For Example if a text, or style changes, then the element gets rebuilt as well.
- When an element is rebuilt, the corresponding render gets rebuilt as well.
- Rebuilding a widget is not much of a performance penalty since not all sub-widgets gets rendered again.
- If a `const` is specified when creating a widget with constant constructor, the widget does not get rebuild in widget tree everytime the tree is rebuilt.
- Since the `const` is constant compile time, a const widget cannot get rebuilt with a different constructor input (arguments).

## Widget Lifecycle
### Stateless Widgets
1. Constructor method
2. The `build()` method

### Stateful Widgets
1. Construction method
2. The `initState()` method. Can be overridden
3. The `build()` method. Should be overridden
4. The `setState()` method. Can be called
5. The `didUpdateWidget()` method. Can be overridden
6. The `build()` method
7. The `dispose()` method. Can be overridden

## Application Lifecycle
1. `inactive`: When the app is not even running in background
2. `paused`: When the app is not visible to the user, but it's running in background
3. `resumed`: When app was `paused` before, but it started running again
4. `suspended`: App is about to be exited. This mode is fragile and should not be trusted for important operations

### Working with app lifecycle
- Add mixin `WidgetsBinding` to the custom widget of interest
- Override `initState()`, `didChangeAppLifecycleState(AppLifecycleState appState)`, and `dispose()`
- Use the parameter `appState`
- Example:
```
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);
}

@override
void didChangeAppLifecycleState(AppLifecycleState appState) {
  print(appState);
}

@override
dispose() {
  super.dispose();
  WidgetsBinding.instance.removeObserver(this);
}
```

## Context
- Flutter has a very efficient communication channel between widgets behind the scene.
- The context builds the skeleton of the widget tree.
- It is meta information on the widget and its location in the widget tree.
- All widgets have their own internal context.
- Context gives us a direct communication channel across the entire widget tree.
- We can use context to access the application theme and navigation (media queries) from any widget.

