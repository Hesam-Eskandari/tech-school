## Classes

- Dart is an object-oriented programming (OOP) language
- Classes are blueprints to create objects
- An object has two components:
  - State
  - Behavior

### State
- State describes the values that an object has at a given time
- Properties define the current state of an object

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
  
  Point(int x, int y) { // 
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

