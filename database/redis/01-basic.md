# Redis Basics

- Key-Value database
- Keys are always strings
- Value can be string, hash, set, list or others.

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
- Get the value of the key and remove the key.
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

## SETS

### SADD
- Add a member to a set of members with the same key
- `SADD key member [member ...]`
- If key does not exist, it would create a new set
- If a member already exist for the key, it won't be added again.
- Returns and integer: the number of elements that were added to the set.
- Read more at [redis.io](https://redis.io/commands/sadd/)

### SCARD
- Returns the set cardinality: the number of members a key has.
- `SCARD key`
- Returns an integer. If the key does not exist: returns zero.
- Read more at [redis.io](https://redis.io/commands/scard/)

### SDIFF
- Returns the set of members that exist in the first set but not in others.
- `SDIFF key1 [key2 key3 ...]`
- Return type is an array
- Keys that do not exist are considered as empty sets.
- Read more at [redis.io](https://redis.io/commands/sdiff/)

### SDIFFSTORE
- Same as `SDIFF` but creates a new set and stores the result in it
- `SDIFFSTORE destination key1 [key2 key3 ...]`
- Returns an integer: the number of elements in the destination set
- Read more at [redis.io](https://redis.io/commands/sdiffstore/)

### SINTER
- Returns a set containing the intersection of all the sets.
- If a key does not exist, the result is an empty set
- `SINTER key1 [key2 ...]`
- Returns an array
- Read more at [redis.io](https://redis.io/commands/sinter/)

### SINTERCARD
- Returns the cardinality of intersect
- `SINTERCARD key1 [key2 ...] [LIMIT limit]`
- If a key does not exist, it returns zero
- If an intersection passes the limit, it would stop calculating that specific intersection and returns the limit
- Read more at [redis.io](https://redis.io/commands/sintercard/)

### SINTERSTORE
- Store intersection of sets in a new set
- `SINTERSTORE destination key1 [key2 ...]`
- Returns an integer: the number of members in the destination set.
- If destination already exist, it is overwritten.
- Read more at [redis.io](https://redis.io/commands/sinterstore/)

### SISMEMBER
- Return 1 of member exists or zero if it doesn't or the key does not exist.
- `SISMEMBER key member`
- Read more ar [redis.io](https://redis.io/commands/sismember/)

### SMEMBERS
- Return a set members
- `SMEMBERS key`
- It is equivalent to `SINTER key`
- Read more at [redis.io](https://redis.io/commands/smembers/)

### SMISMEMBER
- Returns an array indicating if the corresponding member exists.
- `SMISMEMBER key member1 [member2 ...]`
- Returns 1 for an existing member and zero otherwise.
- Read more [redis.io](https://redis.io/commands/smismember/)

### SMOVE
- Move a member from a source set to a destination set
- Returns 1 if the member was moved, 0 otherwise.
- If the member does not exist in source or source does not exist, zero is returned
- If destination does not exist, it would get created.
- If the member already exists in the destination, it would just get deleted from the source.
- `SMOVE source destination member`

### SREM
- Removes member(s) from a set and returns the number of removed members.
- An error is returned if the key is not a set.
- It returns 0 if the key does not exist.

### SUNION
- Return a set result of union of all the given sets
- `SUNION key1 [key2 ...]`
- Non-existing keys are considered as an empty set.
- Read more at [redis.io](https://redis.io/commands/sunion/)

### SUNIONSTORE
- Stores the union of sets into a new destination set.
- If destination set already exists, it gets overwritten.
- `SUNIONSTORE destination key1 [key2 ...]`
- Returns the  number of elements in the destination set.
- Read more at [redis.io](https://redis.io/commands/sunionstore/)

## Sorted Sets
- A mix of hash and set
- values are string with underlying type of number

### ZADD
- `ZADD key value member`
- Value goes before member
- It accepts the following options:
  - XX: update if already exists
  - NX: add only if it does not exist
  - GT: only update or add if the new score is greater that the given score.
  - CH: Modify the return value from the number of new elements added, to the total number of elements changed.
  - INCR: act like `ZINCRBY`
  - Read more at [redis.io](https://redis.io/commands/zadd/)
  
### ZCARD
- Returns the sorted set cardinality
- `ZCARD key`
- Returns an integer

### ZCOUNT
- Returns the number of elements between min and max, inclusive
- `ZCOUNT key min max`
- Excluding the range: `ZCOUNT key (min (max`
- Use `-inf` and `+inf` for the lowes and highest values.

### ZSCORE
- Return the score
- `ZSCORE key member`

### ZMSCORE
- Return multiple scores
- `ZMSCORE key member1 [member2 ...]`
- Returns an array
- Read more at [redis.io](https://redis.io/commands/zmscore/)

### ZREM
- Remove member(s)
- `ZREM key member [member ...]`
- Returns an integer: The number of members removed from the sorted set, not including non-existing members.
- Read more at [redis.io](https://redis.io/commands/zrem/)

### ZRANK
- Returns the rank of member in the sorted set stored at key, with the scores ordered from low to high.
- The rank (or index) is 0-based, which means that the member with the lowest score has rank 0.
- `ZRANK key member`
- Read more at [redis.io](https://redis.io/commands/zrank/)

### ZUNION
- placeholder

### ZUNIONSTORE
- placeholder

### ZINTER
- placeholder

### ZPOPMAX
- placeholder

### ZPOPMIN
- placeholder
- 
### ZPOPMIN
- placeholder

### ZRANGE
- placeholder


## HyperLogLog
- It is used to track the uniqueness of values.
- Given a key-value pair, it can verify if the value was inserted before.
- Returns 1 if the value was inserted before and returns 0 otherwise.
- It does not store the values. It just uses a complex algorithm to keep track of visited values.
- HyperLogLog has the maximum size of 12KB regardless of the number of given values.

### PFADD
- `PFADD key [element [element ...]]`
- Example: `PFADD usernames jack mary mahsa`
- Returns 1 if the value was inserted before and returns 0 otherwise.
- It does not store the actual values. 
- Read more at [redis.io](https://redis.io/commands/pfadd/)

### PFCOUNT
- Giv an approximated number of unique values were ever passed
- There is 0.81% error is this estimation
- `PFCOUNT key [key ...]`
- When called with multiple keys, returns the approximated cardinality of the union of the HyperLogLogs passed, by internally merging the HyperLogLogs stored at the provided keys into a temporary HyperLogLog.
- Read more at [redis.io](https://redis.io/commands/pfcount/)

### PFMERGE
- It merges multiple HyperLogLog keys to a destination key which is union of all given HyperLogLogs.
- `PFMERGE destkey sourcekey [sourcekey ...]`
- The command just returns OK.
- If the destination variable exists, it is treated as one of the source sets and its cardinality will be included in the cardinality of the computed HyperLogLog.
- Read more at [redis.io](https://redis.io/commands/pfmerge/)


## LIST
- It implements the two-way linked list data structure.
- It is a legacy and try not to use it because of its performance penalties.

### LPUSH
- Push to the left side of the list
- `LPUSH key value [value ...]`
- Returns an integer: the length of the list after the push operation
- Read more at [redis.io](https://redis.io/commands/lpush/)

### RPUSH
- Push to the right side of the list
- `RPUSH key value [value ...]`
- Returns an integer: the length of the list after the push operation
- Read more at [redis.io](https://redis.io/commands/rpush/)

### LINDEX
- Get an element from a list by index
- Indexed start from zero
- Negative index will start from the other side of the list from -1.
- `LINDEX key index`
- When the value at key is not a list, an error is returned.
- Returns the requested element, or nil when index is out of range.
- Read more at [redis.io](https://redis.io/commands/lindex/)

### RINDEX
- Similar to `LINDEX` but from the right side.
- Read more at [redis.io](https://redis.io/commands/rindex/)

### LINSERT
- Insert element before or after a pivot element from left side.
- `LINSERT key <BEFORE | AFTER> pivot element`
- Returns (an integer:) the length of the list after the insert operation, or -1 when the value pivot was not found.
- Read more at [redis.io](https://redis.io/commands/linsert/)

### RINSERT
- Similar to `LINSERT` but from the right side.
- Read more at [redis.io](https://redis.io/commands/rinsert/)

### LLEN
- Returns the length of a list
- `LLEN key`
- Returns the length of the list stored at key.
- If key does not exist, it is interpreted as an empty list and 0 is returned.
- An error is returned when the value stored at key is not a list.
- Read more at [redis.io](https://redis.io/commands/llen/)

### OTHER COMMANDS
- `LPOP`
- `LMPOP`
- `LMOVE`
- `LPOS`
- `LREM`
- `LSET`
- `RPOPLPUSH`
- `LTRIM`
- Read more at [redis.io](https://redis.io/commands/?group=list)

