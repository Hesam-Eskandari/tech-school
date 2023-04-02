# Dart

## Introduction
- Dart is optimized for client side applications
- Flutter uses Dart to create cross-platform mobile apps and web applications
- It supports asynchronous and multi-thread programming
- Dart is a statically types programming language

### Installation
- Install Dart SDK: https://dart.dev/get-dart
- Test installation: `dart --version`

### Hello World!
```dart
void main() {
  print("Hello World!");
}
```

## Basics
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
- Value of a final should be assigned at the time of declaration or in object constructor.

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
- Convert a String to double: `double ageDouble = ageStr.toString();`
- Convert a double to string: `String ageStr = ageDouble.toString();`
  - Or: `String ageStr = '$ageDouble';`
- Convert double to int: `int age = ageDouble.toInt();`

#### Boolean
- Type: `bool`
- Values: `false` or `true`
- Boolean operations support short-circuit

### Conditions And Loops
#### If Statement
```dart
void main() {
  if (condition) {
    statement;
  } else if (condition) {
    statement;
  } else {
    statement;
  }
}
```

#### Ternary Operation
```dart
void main() {
  int price = age > 60 || age <= 5 ? 20 : 30;
}
```

#### Do While
- It runs the statement inside the loop first and then checks the condition
- It enters the loop at least once
```dart
void main() {
  do {
    statement;
  } while(condition);
}
```
- `Do-While` can become an infinite loop
- It is possible to `break` or `continue` 

#### While
- It checks the condition before running the statements inside the loop.
- `While` can become an infinite loop
- It is possible to `break` or `continue`
```dart
void main() {
  while(condition) {
    statement;
  }
}
```

#### For Loop
- For loop can be used when the number of iterations is known
```dart
void main() {
  for(initializer; condition; iterator) {
    statement;
  }
}
```
- `For` can become an infinite loop
  ```dart
  void main() {
    for(var i = 0; i >= 0; i++) {
      statement;
    }
  }
  ```
- It is possible to `break` or `continue`

#### For-Each Loop
- For-each loops over items of iterable. `For` loop can loop over their indexes.
```dart
void main() {
  var numbers = [1, 2, 3, 4, 5];
  int sum = 0;
  for (var number in numbers) {
    sum += number;
  }
  print(sum);
}
```

#### Break Or Continue The Outer Loop
- To break from an outer loop, you can simply return from the function.
- The second approach is to use a label for each loop.
- The second approach works for `continue` as well.
  ```dart
  void main() {
    outerLoop:
    for(var i = 0; i < 100; i++) {
      for (var j = 0; j < 100; j++) {
        if (i + j > 180) break outerLoop;
        if (j == j) continue outerLoop;
        print('$i,$j');
      }
    }
  }
  ```

#### Switch
- Switch evaluates the exact match to value of a variable
- All cases should have `break`. Even the `default` case.
- It is equivalent to `if-else if-else` statement.
```dart
void main() {
  switch (expression)
  {
    case value1:
      statement1;
      break;
    case value2:
      statement2;
      break;
    case value3:
    case value4:
      statement3;
      break;
    case value5:
    default:
      statementN;
      break;
  }
}
```

### Functions
- Functions have two parts 
  1. Signature
  2. Body
- Function signature: return type + function name + parameter list

#### Function Declaration
```dart
returnType functionName(parameters) {
  statement;
  return valueOfReturnType;
}
```
- Return type can be `void`
- Declared functions can be called before where they are defined.
- If return type for a function is `void`, then the function cannot return a value. But it can return nothing to exit the function.
```dart
void setAge(int age) {
  if (age < 0) return;
  this._age = age;
}
```


#### Arrow Function
- Arrow functions can only have one line body. The result of that one line is returned. No `return` keyword is required.
- Arrow functions are assigned to variables. They cannot be called before where they are defined.
```dart
void main() {
  Function isNot = (bool boolean) => !boolean; // can use type "bool Function(bool)" instead of "Function" here
  if (isNot(age<18)) print('Access granted');
}
```

#### Anonymous Function
- Similar to an arrow function, but without an arrow
- Similar to a declared function, but without a name
- It can have body with multiple lines
- Anonymous functions are assigned to variables. They cannot be called before where they are defined.
```dart
void main() {
  var isNot = (bool b){
    return !b;
  }; // notice the semicolon here
    if (isNot(age<18)) print('Access granted');
}
```

#### Optional Parameters
- Optional parameters appear last in parameter list
- A function can have either optional parameters or named parameters, but not both
- An optional parameter must come with a default value
- Use square brackets to specify optional parameters
```dart
void sayHi(String name, [String title = '']) {
  print('Hi $title $name');
}
void main() {
  sayHi('Alex');
  sayHi('Mikes', 'Mr.');
}
```

#### Named Parameters
- Named parameters enable us specifying names of arguments when calling functions
- A function can have either optional parameters or named parameters, but not both
- A named parameter is also optional
- To make a named parameter required, use `required` keyword
- An optional named parameter must have a default value
- Named parameters must appear last in parameters list
- To **call** a function with named parameters, parameter names must be specified.
```dart
void sayHi(int age, {required String name, String title = ''}) {
  print('Hi $title $name. You are $age');
}
void main() {
  sayHi(25, name:'Alex');
  sayHi(55, name:'Mikes', title:'Mr.');
}
```

#### Function Are First-Class Citizens
- A function can be assigned to a variable
- Pass a function as an argument to another function
- Return a function from another function

### Collections
#### List
- Dart uses `List<E>` class to manage lists. It implements the `Iterable` class.
- List is a collection of objects with a length.
- A list is an indexed array of elements. They can contain duplicates.
- Type: `List<T>`
- Create lists:
  ```dart
  void main() {
    var list = new List<int>.empty(growable: true); // growable is false by default: []
    list.add(5); // [5]
  
    var nums = [1, 2, 3, 4, 5]; // type is inferred as List<int> and growable is true
    List<String> fruits = ['apple', 'banana', 'orange']; // type is explicitly specified as List<String> and growable is true
    var constants = <double>[3.141, 1.618]; // type is explicitly specified as List<String> and growable is true
  }
  ```
- Lists are passed by reference
  ```dart
  void append(List<int> list, int value) {
    list.add(value);
  }
  void main() {
    List<int> list = [1, 2, 3, 4];
    append(list, 5);
    print(list); // [1, 2, 3, 4, 5]
  }
  ```
- Use `from` constructor to copy a list elements to a new list: `var newList = new List<int>.from(olsList);`
  - Or use spreading operator: `List<int> newList = [...oldList]`
- Use `generate` constructor to create a list of length `n` with elements returned from a function as second argument:
  ```dart
  void main() {
    var squares = new List<int>.generate(10, (int index) => index * index); // 10 is length
    print(squares);
  }
  ```
- It is possible to use a declared function as well
  ```dart
  void main() {
    var squares = new List<int>.generate(10, getSquare);
    print(squares);
  }
  int getSquare(int value) {
    return value * value;
  }
  ```
- Get element at index `i`: `var value = square[i];`
- Set element at index `i`: `square[5] = 16;`
- Add element to the end of the list: `squares.add(100);`
- Add a list to a list: `list1.addAll(list2);`
- Remove the first occurrence an item from a list: `bool isFound = squares.remove(5);`
- Remove an item from list at index: `int removedValue = squares.removeAt(5);`
- Convert list to set: `Set<int> set = list.toSet();`
- Convert list to string: `String listStr = list.toString();`
  - Printing a list converts it to string by default by calling its `toString()` method.
- Immutable list: 
  - Use `final` keyword. An immutable list cannot be reassigned, but it can be modified.
    - `final scores = [1, 2, 3, 4, 5];`
  - Use `const` keyword to make a compile-time constant list which cannot be modified as well.
    - `const scores = [1, 2, 3, 4, 5];`
- Get size of a list with `length` property: `squares.length`
- Check if list is empty (it is suitable for `while` conditions): `squares.isEmpty` and `squares.isNotEmpty` 
- `ForEach`: Loops over elements. There is no access to `index` of elements.
  ```dart
  void main() {
    var list = [1, 2, 3, 4, 5];
    list.forEach((element) => print(element*2));
  }
  ```
- If it is required to access indexes, either use a for loop or convert the list to map:
  ```dart
  void main() {
    var list = [1, 2, 3, 4, 5];
    list.asMap().forEach((index, element) => print('$index: $element'));
  }
    
  ```
- Collection `if`: use collection `if` in list literal to only add an element if a condition is true
  ```dart
  void main() {
    var list = [1, 2, 3, if (capacity > 3) 4];
  }
  ```
- Collection `for`: use collection `for` to add multiple elements to a list literal
  ```dart
  void main() {
    var numbers = [1, 2, 3, 4, 5];
    var list = [0, for (var number in numbers) number * number];
  }
  ```

- Concatenate lists of same type: `var list = list1 + list2;`
  - Or: `var list = [...list1, ...list2];`

#### Map
- `Map` is a key/value pairs
- Can access values by keys in `O(1)` for each key
- Any immutable and non-reference type variable can be a key. For example, a list cannot be a key
- Any value or reference can be a value in a map
- Type: `Map<K, V>`
- Create map literals:
  ```dart
  void main() {
    var seasons = {'Spring': ['April', 'May', 'June'], 'Summer': ['July', 'August', 'September']}; // type inferred as Map<String, List<String>>
    Map<String, String> capitals = {'USA': 'Washington', 'Canada': 'Ottawa'};
    var brandAges = <String, int>{'Apple': 40, 'Google': 30};
  }
  ```
- Regular map operations:
  ```dart
  void main() {
    // assume maps are created
    brandAges['Microsoft'] = 35; // Add or modify a key/value pair
    var spring = seasons['Spring']; // Access a value by key. The `spring` type is `List<String>?`. It is nullable string
    List<String>? spring = seasons['Spring']; // equivalent to above
    var removedItem = seasons.remove('Spring'); // Remove a key from map and return its value
    var capitalKeys = capitals.keys; //Get the list of keys
    var capitalValues = capitals.values; // Get the list of values
    var size = capitals.length; // Get the number of key/value pairs
    bool isCapitalsEmpty = capitals.isEmpty; // useful for while loops
    bool isNotCapitalsEmpty = capitals.isNotEmpty; // useful for while loops
    bool hasCapital = capitals.containsKey('UK');
    bool isValidCapital = capitals.containsValue('New York');
    for (var country in capitals.keys) print(capitals[country]); // Iterate over keys
    brandAges.forEach((string brand, int age) => print('$brand: $age')); // Iterate over key/value pairs
    for (var entry in seasons.entries) {
      print(entry.value);
      print('$entry.key, $entry.value');
    }
  }
  ```

- Concatenate maps: `var newMap = {...firstMap, ...secondMap};`
  ```dart
  void main() {
    Map<String, String> capitals = {'USA': 'Washington', 'Canada': 'Ottawa'};
    var centers = <String, String>{'Alberta': 'Edmonton'};
    var newMapSpread = {...capitals, ...centers}; // first approach
    var newMap = <String, String>{}; // second approach
    newMap.addAll(capitals);
    newMap.addAll(centers);
  }
  ```

- Dynamically typed map. It is not a good idea to declare and use a dynamic map. 
  ```dart
  void main() {
    var capitals = <dynamic, dynamic>{}; // inferred as <dynamic, dynamic>{}
    capitals = {'USA': 'Washington', 'Canada': 'Ottawa'};
    capitals[25] = 'age'; 
    print(capitals); // {USA: Washington, Canada: Ottawa, 25: age}
  }
  ```
