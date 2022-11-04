import Buffer "mo:base/Buffer";
import Deque "mo:base/Deque";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";
import TrieMap "mo:base/TrieMap";

import Itertools "mo:Itertools/Iter";

import Utils "Utils";

module {
    let { dequeToArray; appendArrayToDeque; dequeFromArray; optDequeToArray } = Utils;

    /// The MultiValuedMap is an extention of the [TrieMap](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/base/TrieMap) class that stores multiple values for a single key
    ///
    /// Internally the values are in a [Deque](https://internetcomputer.org/docs/current/developer-docs/build/cdks/motoko-dfinity/base/Deque) but are returned to the user as arrays.
    public class MultiValuedMap<K, V>(
        isKeyEq : (K, K) -> Bool,
        keyHash : K -> Hash.Hash,
    ) {

        var map = TrieMap.TrieMap<K, Deque.Deque<V>>(isKeyEq, keyHash);

        public let size = map.size;
        public let keys = map.keys;

        /// Associates the key with the given value in the map.
        /// Overwrites any existing values previously associated with the key
        public func put(key : K, value : V) {
            let deque = Deque.empty<V>();
            map.put(key, Deque.pushBack(deque, value));
        };

        /// Associates the key with the given values in the map.
        /// These new values overwrite any previous values.
        public func putAll(key : K, values : [V]) : () {
            let deque = dequeFromArray(values);
            map.put(key, deque);
        };

        /// Adds a value to the end of the list associated with the key
        public func add(key : K, value : V) {
            switch (map.get(key)) {
                case (?deque) {
                    map.put(key, Deque.pushBack(deque, value));
                };
                case (_) {
                    put(key, value);
                };
            };
        };

        /// Adds the value to the beginning of the list for the associated key
        public func addFirst(key : K, value : V) {
            switch (map.get(key)) {
                case (?deque) {
                    map.put(key, Deque.pushFront(deque, value));
                };
                case (_) {
                    put(key, value);
                };
            };
        };

        /// Appends all the given `values` to the existing values associated with the given key
        public func addAll(key : K, values : [V]) {
            switch (map.get(key)) {
                case (?deque) {
                    map.put(key, appendArrayToDeque<V>(deque, values));
                };
                case (_) {
                    putAll(key, values);
                };
            };
        };

        /// Retrieves the first value associated with the key
        public func getFirst(key : K) : ?V {
            let arr = optDequeToArray(map.get(key));

            if (arr.size() > 0) {
                ?arr[0];
            } else {
                null;
            };
        };

        /// Retrieves all the values associated with the given key
        public func get(key : K) : [V] {
            optDequeToArray(map.get(key));
        };

        public func vals() : Iter.Iter<[V]> {
            let iter = map.vals();

            return object {
                public func next() : ?[V] {
                    switch (iter.next()) {
                        case (?optVals) {
                            ?optDequeToArray(iter.next());
                        };
                        case (_) {
                            null;
                        };
                    };
                };
            };
        };

        /// Returns all the entries in the map as a tuple of
        /// key and values array
        public func entries() : Iter.Iter<(K, [V])> {
            let iter = map.entries();

            return object {
                public func next() : ?(K, [V]) {
                    switch (iter.next()) {
                        case (?(key, deque)) {
                            ?(key, dequeToArray(deque));
                        };
                        case (_) {
                            null;
                        };
                    };
                };
            };
        };

        /// Returns all the entries in the map but instead of
        /// an iterator with a key and a values array (`(K, [V])`), it returns
        /// every value in the map in a tuple with its associated key (`(K, V)`).
        public func flattenedEntries() : Iter.Iter<(K, V)> {
            let iter = Iter.map(
                entries(),
                func((key, values) : (K, [V])) : Iter.Iter<(K, V)> {
                    Iter.map<V, (K, V)>(
                        values.vals(),
                        func(val) { (key, val) },
                    );
                },
            );

            Itertools.flatten(iter);
        };

        /// Returns an iterator with key-value tuple pairs with every key in
        /// the map and its first value
        public func singleValueEntries() : Iter.Iter<(K, V)> {
            Iter.map<(K, [V]), (K, V)>(
                entries(),
                func((key, values)) { (key, values[0]) },
            );
        };

        /// Removes all the values associated with the specified key
        /// and returns them
        ///
        /// If the key is not found, the function returns an empty array
        public func remove(key : K) : [V] {
            optDequeToArray(map.remove(key));
        };

        /// Removes all the key-value pairs in the map
        public func clear() {
            map := TrieMap.TrieMap<K, Deque.Deque<V>>(isKeyEq, keyHash);
        };
    };

    public func fromEntries<K, V>(
        entries : [(K, [V])],
        isKeyEq : (K, K) -> Bool,
        keyHash : K -> Hash.Hash,
    ) : MultiValuedMap<K, V> {
        let mvMap = MultiValuedMap<K, V>(isKeyEq, keyHash);

        for ((key, values) in entries.vals()) {
            mvMap.addAll(key, values);
        };

        mvMap;
    };
};
