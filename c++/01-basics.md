# C++

## Prerequisites

### Keywords
- Reserved words that make the language grammar
- There are more than 90 keywords in C++
- Stream insertion operator: `<<`
- Stream extraction operator: `>>`
- Scope resolution operator: `::`
- Hello World:
```c++
#include <iostream>

int main() {
    std::cout << "Hello, World!" << std::endl;
    return 0;
}
```

### Compile And Run
- If the filename containing the `main` function is `main.cpp`
- Compile the code: `g++ main.cpp`
- Check if the compiled filed is generated: `a.out`
- Run the compiled file: `./a.out`

### Preprocessor

#### Preprocessor directives
- They start with # 
- Most common one is the “include” directive

#### Preprocessor
- The C++ preprocessor is  a program that processes the source code before the compiler sees it
- It firsts strips all the comments from the source file and replaces each comment with a single space
- Then it looks for pre-processor directives and executes them
- It replaces the directive starts with # with a file it refers to. Then it recursively processes that file as well
- The C++ pre-processor does not understand C++
- It just follows the pre-processor directives and gets the source code ready for compiler
- The compiler is a program that understand C++

### Comments
- Single line comments: // anything after two forward slashes in the same line
- Multi-line comment: /* any text in multiple lines between these two signs */

### The `main` function
- A C++ source code may contain hundreds of files. But one of them must contain the main function
- Every C++ program must have exactly one `main` function
- The `main` function always returns an integer. This integer is the program exit code and can be interpreted bt the OS
- When OS runs the C++ program, it runs the `main` function.
- Only the zero return value is the successful message. Others need to be standardized and used by the operating system.
- There are two signatures for the `main` function:
  - Without arguments
  - With arguments

#### Main Without Arguments
```c++
int main() {
    // code is written here
    return 0;
}
```
- To run: `./a.out`

#### Main With Arguments
```c++
int main(int argc, char *argv[]) {
    // code
    return 0;
}
```

- The argument `argc` is the number of arguments passed when running the code
- The `*argv[]` is an array of arguments
- To run: `./a.run arg1 arg2 arg3`

### Namespace
- Naming a part of the code helps to modularize the code and avoid naming conflict
- Example: `std` is the name for the `standard` library in C++
- Use the scope resolution operator to access items in a namespace
  - Example: `std::cout`
- One can implement another `cout` and store it in their own namespace
  - Example: `myns::cout`

#### Using Namespace Directive
- To import and include all members of a namespace and use them directly
- Example:
```c++
#include <iostream>
using namespace std;

int main() {
    int age;
    cout << "Enter your age: ";
    cin >> age;
    cout << "You inserted " << age << endl;
    return 0;
}
```

- This approach may not be the best solution for large source codes.

##### Import only the needed members
- To avoid importing not needed elements and avoid name conflict
```c++
#include <iostream>
using namespace std::cout;
using namespace std::cin;
using namespace std::endl;

int main() {
    int age;
    cout << "Enter your age: ";
    cin >> age;
    cout << "You inserted " << age << endl;
    return 0;
}
```
