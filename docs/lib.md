# lib

## `class MultiValuedMap<K, V>`


### Value `size`
`let size`



### Value `keys`
`let keys`



### Function `put`
`func put(key : K, value : V)`

Associates the key with the given value in the map.
Overwrites any existing values previously associated with the key


### Function `putAll`
`func putAll(key : K, values : [V]) : ()`

Associates the key with the given values in the map.
These new values overwrite any previous values.


### Function `add`
`func add(key : K, value : V)`

Adds a value to the end of the list associated with the key


### Function `addFirst`
`func addFirst(key : K, value : V)`

Adds the value to the beginning of the list for the associated key


### Function `addAll`
`func addAll(key : K, values : [V])`

Appends all the given `values` to the existing values associated with the given key


### Function `getFirst`
`func getFirst(key : K) : ?V`

Retrieves the first value associated with the key


### Function `get`
`func get(key : K) : [V]`

Retrieves all the values associated with the given key


### Function `vals`
`func vals() : Iter.Iter<[V]>`



### Function `entries`
`func entries() : Iter.Iter<(K, [V])>`

Returns all the entries in the map as a tuple of
key and values array


### Function `flattenedEntries`
`func flattenedEntries() : Iter.Iter<(K, V)>`

Returns all the entries in the map but instead of
an iterator with a key and a values array (`(K, [V])`), it returns
every value in the map in a tuple with its associated key (`(K, V)`).


### Function `singleValueEntries`
`func singleValueEntries() : Iter.Iter<(K, V)>`

Returns an iterator with key-value tuple pairs with every key in
the map and its first value


### Function `remove`
`func remove(key : K) : [V]`

Removes all the values associated with the specified key
and returns them

If the key is not found, the function returns an empty array


### Function `clear`
`func clear()`

Removes all the key-value pairs in the map
The MultiValuedMap is an extention of the [TrieMap](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/base/TrieMap) class that stores multiple values for a single key

Internally the values are in a [Deque](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/base/Deque) but are returned to the user as arrays.

## Function `fromEntries`
`func fromEntries<K, V>(entries : [(K, [V])], isKeyEq : (K, K) -> Bool, keyHash : K -> Hash.Hash) : MultiValuedMap<K, V>`

