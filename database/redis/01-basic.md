# Redis Basics

- Key-Value database
- Keys are always strings
- Value can be string, hash, set, or list.

### DEL
- Delete a key regardless the type of the value
- `DEL key1 key2 ...`
- Returns an integer indicating the number of keys that were removed

## String Values

### Get
- Get a string value by key
- A single Redis string cannot be larger than 512MB
- Syntax: `GET key`
- Example: `GET color`
- If key does not exist, it returns `null (nil)`.

### GETEX
- Get value and set expiry: `GETEX`
- Syntax: `GETEX key EX timeSeconds`
- See all the options for `GETEX`: [redis.io](https://redis.io/commands/getex/)

### MGET
- Accepts multiple keys seperated by space
- Returns an array of corresponding values
- Example: `MGET color:1 color:2 color:3`

### SET
- Set a key-value pair
- `SET` is used to set string values
- Syntax `SET key value`
- Example: `SET car:color red`
- Example: `SET user:age:01 49`
- Use single quote to insert a value that has space in it: `SET comment 'user added!'`
- A successful set returns "OK" message.
- To set a value and return the previously set value:
  - `SET key value GET`
  - If the key had no value before, it returns `null`
- To set if already exists: `SET key value XX` -> returns `"OK"` or `null (nil)`
- To set if not exists: `SET key value NX` -> returns `"OK"` or `null (nil)`

### MSET
- Set multiple string values
- Syntax: `MSET key1 value1 key2 value2 ...`

### SETEX
- Set with time expiry
- `SETEX key time value`
- Same return as `SET`

### SETNX
- Set if key does not exist
- `SETNX key value`
- Returns 0 or 1

### MSETNX
- Set multiple pairs of each if key does not exist
- `SETNX key1 value1 key2 value2 ...`
- Returns 1 if all the keys were set and zero otherwise.
- Read more at [redis.io](https://redis.io/commands/msetnx/)

### GETDEL
- Get the value og the key and remove the key.
- Syntax: `GETDEL key`
- Returns `null (nil)` if key does not exist.
- Read more at [redis.io](https://redis.io/commands/getdel/)

### GETRANGE
- Get a substring of a string value
- Syntax: `GET key start end`
- Both `start` and `end` are inclusive
- Indexes start from zero
- Negative indexes are also possible: -1 is the last character.
- Read more at [redis.io](https://redis.io/commands/getrange/)

### STRLEN
- Returns the length of the value
- `STRLEN key` -> returns an integer
- If key does not exist, it returns 0

### INCR
- Increment a value by one
- Value is of string type, but the underlying type must be a number
- `INCR key`

### DECR
- Decrement a value by one
- Value is of string type, but the underlying type must be a number
- `DECR key`

### INCRBY
- Increment a value by an optional integer
- Value is of string type, but the underlying type must be a number
- `INCRBY key`
- 
### INCRBYFLOAT
- Increment a value by an optional float
- Value is of string type, but the underlying type must be a number
- `INCRBYFLOAT key`
- Use negative value for decrementing

### APPEND
- Append (concatenate) a string to the end of the current value
- `APPEND key value`
- If key does not exist, it would just create one.
- Returns the length of the final string after appending.
- Read more at [redis.io](https://redis.io/commands/append/)

## HASH

### HGET
- Returns the value associated with field in the hash stored at key.
- Similar to a nested json object (second layer only)
- `HGET key field`
- Data structure:
    ```
    key: {
      field1  value1,
      field2  value2
     }
    ```
- Returns the value or `nil` if the field or key or both do not exist.
- Read more at [redis.io](https://redis.io/commands/hget/)

### HGETALL
- Returns an array of fields and values or an empty list if the key does not exist.
- `HGETALL key`
- Return sample: `["field1", "value1", "field2", "value2"`
- Read more at [redis.io](https://redis.io/commands/hgetall/)

### HMGET
- Get multiple values of the same key.
- `HGET key field1 [field2 ...]`
- Returns an array of values in the same order of fields
- If a field does not exist, it's corresponding value would be `nil`
- Read more at [redis.io](https://redis.io/commands/hmget/)

### HSET
- To set one or multiple field-value pairs of the same key
- `HSET key field1 value1 [field2 value2 ...`
- Returns 1 if field did not exist before and 0 otherwise.
- Read more at [redis.io](https://redis.io/commands/hset/)

### HMSET
- Deprecated

### HSTRLEN
- Returns the string length of the value associated with field in the hash stored at key. If the key or the field do not exist, 0 is returned.
- `HSTRLEN key field`
- Read more at [redis.io](https://redis.io/commands/hstrlen/)

### HKEYS
- Returns all field names in the hash stored at key.
- Returns an array of fields in the hash, or an empty list when key does not exist.
- `HKEYS key`
- Read more at [redis.io](https://redis.io/commands/hkeys/)

### HVALS
- Returns all values in the hash stored at key.
- Returns a list of values in the hash, or an empty list when key does not exist.
- `HVAL key`
- Read more at [redis.io](https://redis.io/commands/hvals/)

### HLEN
- Returns the number of fields contained in the hash stored at key 0 when key does not exist.
- `HLEN key`
- Read more at [redis.io](https://redis.io/commands/hlen/)

### HINCRBY 
- Increments the number stored at field in the hash stored at key by increment.
- If key does not exist, a new key holding a hash is created.
- If field does not exist the value is set to 0 before the operation is performed.
- `HINCRBY key field increment`
- Read more at [redis.io](https://redis.io/commands/hincrby/)

### HINCRBYFLOAT
- Increment the specified field of a hash stored at key, and representing a floating point number, by the specified increment.
- If the increment value is negative, the result is to have the hash field value decremented instead of incremented.
- If the field does not exist, it is set to 0 before performing the operation.
- An error is returned if one of the following conditions occur:
- The field contains a value of the wrong type (not a string).
- The current field content or the specified increment are not parsable as a double precision floating point number.
- returns the value of field after the increment.
- Read more at [redis.io](https://redis.io/commands/hincrbyfloat/)