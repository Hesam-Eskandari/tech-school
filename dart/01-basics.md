# Dart

## Introduction
- Dart is optimized for client side applications
- Flutter uses Dart to create cross-platform mobile apps and web applications
- It supports asynchronous and multi-thread programming
- Dart is a statically types programming language

### Installation
- Install Dart sdk: https://dart.dev/get-dart
- Check installation: `dart --version`

### Hello World!
```dart
void main() {
  print("Hello World!");
}
```

## Syntax
- Statements end with semicolon
- Use curly brackets for blocks

### Comments
- Single line comment: use `//`
- Multi-lines comment: anything between `/*` and `*/`
- Doc comment: use `///`

### Variable Declaration
#### Not nullable 
1. `type vairableName = value;` 
2. `var variableName = value;`  
- Assigning a value of different type would give a compile error.

#### Dynamically typed 
- Syntax one:
    ```dart
    void main() {
      var variableName; // type inferred as dynamic
      variableName = 5;
      variableName = "name"; 
    }
    ```
- Syntax two:
    ```dart
    void main() {
      dynamic variableName = 5;
      variableName = "name";
    }
    ```
- A dynamically typed variable would have `null` value at the time of declaration.
- Note that the following syntax sets the type of variable which enforces the same type assignment at compile time:

    ```dart
    void main() {
      var variableName = 5; // type is inferred as int
      variableName = "name"; // compile error
    }
    ```

### Constants
- Constants values are compile-time constants
```dart
void main() {
  const pi = 3.141592; // type is inferred as double
  const String url = "https://example.org/"; // type is explicitly specified as String
  const now = DateTime.now(); // compile error
}
```
- A runtime calculated constant cannot use the `const` keyword.
- Value of a constant should be assigned at the time of declaration only.

### Final
- Final values are runtime constants
- They can be used for runtime calculated constants

```dart
void main() {
  final pi = area / (radius * radius); // type is inferred
  final String url = URL.getExample(); // type is explicitly specified as String
  final now = DateTime.now(); // type inferred as DateTime
}

```
- Value of a final should be assigned at the time of declaration or an object constructor.

### Basic Types
#### String
- Use capital `S` for `String` type.
- Strings are immutable
- Literals can be written using either single quotes or double quotes.
- Get the number of characters with `length` property: `url.length`
- Get a character at index `i`: `url[i]`
- Concatenate strings:
  - Syntax one: Use `+` sign: `var str = string1 + ' ' + string2;`
  - Syntax two: Adjacent string literals: `var str = 'Hello'' ''World';`
- Multiline string: Anything between starting `'''` and ending `'''`.
    ```dart
      var str = '''This is a
      multiline
      string ''';
    ```
- Get a substring of a string: Use `substring(start, end)` object method
- Start index is inclusive and end index is exclusive
- String interpolation: `String printable = 'price = ${priceIntVariable}';`
  - Curly braces can be omitted for a single variable: `String printable = 'price = $priceIntVariable';`
  - Curly braces can contain a one line statement: `String printable = 'price = ${pricePerUnit * numUnits}';`

#### Integer
- Type: `int`
- Since Dart is also compiled to JavaScript, the int type maps to a 64-bit double-precision floating-point value on the web.
- Convert string to int: `int age = int.parse(ageStr);`
- Convert int to string: `String ageStr = age.toString();`
  - Or: `String ageStr = '$age';`
- Convert int to double: `double ageDouble = age.toDouble();`

#### Double
- Type: `double`
- It represents double-precision floating-point numbers.
- Comparing exact double values may lead to an unexpected results because they are approximated values.
```dart
void main() {
  double sum = 0.3;
  double each = 0.1;
  print('$sum == ${3 * each} -> ${sum == 3 * each}'); // 0.3 == 0.30000000000000004 -> false
}
```
- Converting a String to double: `double ageDouble = ageStr.toString();`
  - Or: `String ageStr = 'ageDouble';`
- Converting