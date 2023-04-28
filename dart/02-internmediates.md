## Classes

- Dart is an object-oriented programming (OOP) language
- Classes are blueprints to create objects
- An object has two components:
  - State
  - Behavior

### State
- State describes the values that an object has at a given time
- Fields define the current state of an object

### Behavior
- Behaviors are defined actions an objects makes to change its states
- Methods define behaviors of an object

### Definition

#### With Default Constructor
```dart
class Point {
  double x = 0;
  double y = 0;
}

void main() {
  var point = Point();
  point.x = 10;
  
  var point2 = Point()
        ..x = 100
        ..y = 200; // cascade notation
  
  print(point is Point); // "is" operator verifies the type => returns true
}
```

#### With Defined Constructor

- Long-form constructor
```dart
class Point {
  double x;
  double y;
  
  Point(double x, double y) { // 
    this.x = x;
    this.y = y;
  }
}
```

- Short-form constructor:
```dart
class Point {
  double x;
  double y;
  
  Point(this.x, this.y);
}
```

- Named constructor:
```dart
class Point {
  double x;
  double y;
  
  Point(this.x, this.y);
  Point.origin() {
    this.x = 0;
    this.y = 0;
  }
  
  Point.verticalAxis(double y) {
    this.x = 0;
    this.y = y;
  }
}

void main() {
  var origin = Point.origin();
  print(origin.y);
  
  var yAxis = Point.verticalAxis(5);
  print(yAxis.y);
  
  var point = Point(11, 18);
  print(point);
}
```

- Forwarding constructor:
```dart
class Point {
  double x;
  double y;
    
  Point(this.x, this.y);
  Point.origin(): this(0,0);
  Point.verticalAxis(double y): this(0, y);
}
```

- Named and optional parameters:
```dart
class Point {
  double x;
  double y;
  
  Point({this.x = 0, this.y = 0});
}
```

**Note**: If no constructor is defined, default constructor would be used.  
**Note**: If any constructor is defined, no default constructor would be existed anymore.

### Methods
- Define behavior and change state with methods

```dart
class Point {
  double x;
  double y;
  Point({this.x = 0, this.y = 0});
  
  Point moveHorizontal(double dx) {
    x += dx;
    return this; // return "this" to chain method calls
  }
  
  Point moveVertical(double dy) {
    y += dy;
    return this; // return "this" to chain method calls
  }
  
  @override
  String toString() { // override toString() to print object directly
    return 'Point(x=$x, y=$y)'; 
  }
}

void main() {
  var point = Point();
  print(point);
  point.moveHorizontal(11)
    .moveVertical(18);
  print(point);
}
```

### Private Access
- Use underscore as first character of field or method to make it private
- A variable of a class is called a field. If it can be accessed from outside of class, it is called a property.

```dart
class Point {
  final double _x;
  final double _y;

  Point({double x = 0, double y = 0}): this._x = x, this._y = y;
}
```

**Note**: Since fields `_x` and `_y` are final. They cannot be initialized in the body of constructor.
Hence, an initializer list is used to initialize the final private fields.  

**Note**: In Dart, privacy is at the library level rather than class level.
It can be compared to `internal` access modifier in other programming languages.  

### Getter And Setter
- Use `get` keyword to define a getter.
- Use `set` keyword to define a setter.
- A `final` field cannot have a setter.

```dart
class Point {
  double _x;
  double _y;

  Point({double x = 0, double y = 0}): this._x = x, this._y = y;

  double get x => _x;
  double get y {
    return _y;
  }

  set x(double value) {
    // validate id needed
    _x = value;
  }

  set y(double value) {
    // validate id needed
    _y = value;
  }

  @override
  String toString() {
    return 'Point(x:$_x, y:$_y)';
  }
}

void main() {
  var point = Point(x:5, y:4);
  point.x = 7;
  print(point);
}
```

### Computed Property
- A computed property is not backed by a dedicated field.
- It is computed when it is called.

```dart
import 'dart:math';

class Point {
  double _x;
  double _y;

  Point({double x = 0, double y = 0})
          : this._x = x,
            this._y = y;
  double get length {
    return pow(pow(_x, 2).toDouble() + pow(_y, 2).toDouble(), 1/2).toDouble();
  }
}

void main() {
  var point = Point(x:3, y:4);
  print(point.length);
}
```

### Constant Constructor
- The `const` keyword can be only used if the value is known in compile time.

```dart
class Text {
  final String content;
  const Text({this.content = ''});  // constant constructor
  Text.custom({this.content = ''});
}

void main() {
  var hello = Text(content: 'Hello');
  print(hello.content);
  hello = Text.custom(content:'hi');
  print(hello.content);

  const message = Text(content: 'I\'s sunny!');
  print(message.content);
}
```
- In the example above, `hello` is a variable that can be reassigned.
- The object that is initially assigned to `hello` is constant. It is instantiated at compile time.
- The value `message` is constant itself. It cannot be reassigned.
- An object with a non-constant constructor could not be assigned to `message`.
- The properties of `Text` must be all final.
- The `Text` class cannot have any setter for its properties.
- Using constant constructor, Dart optimizes the memory so that if multiple objects have the same property values, Dart will create only one instance for them.

