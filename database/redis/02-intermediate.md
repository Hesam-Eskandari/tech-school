# Intermediate

## Lua Scripting
### Basics
- Print to console: 
  - `print('hello world!')`
  - `print("hello world!")`
- Declare a variable and assign values: 
  - `local name = 'Lua'`
  - `global value = 5 + 2`
  - Try to declare local variables when working with Redis
- `if` statement:
  - ```
    if value > 6 then
       print('value is greater than 6')
    end
    if value ~= 6 then
       print('value is not 6')
    end
    if 0 and '' then
       print('0 and empty string are truthy')
    end
    if false or not true or nil then
       print('never will be printed')
    end
    ```
