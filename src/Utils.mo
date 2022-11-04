import Buffer "mo:base/Buffer";
import Iter "mo:base/Iter";
import Deque "mo:base/Deque";

module {
    public func arrayToBuffer<T>(arr : [T]) : Buffer.Buffer<T> {
        let buffer = Buffer.Buffer<T>(arr.size());
        for (n in arr.vals()) {
            buffer.add(n);
        };
        return buffer;
    };

    public func dequeFromArray<A>(values : [A]) : Deque.Deque<A> {
        let dq = Deque.empty<A>();

        appendArrayToDeque(dq, values);
    };

    public func appendArrayToDeque<A>(deque : Deque.Deque<A>, values : [A]) : Deque.Deque<A> {
        var dq = deque;

        for (val in values.vals()) {
            dq := Deque.pushBack(dq, val);
        };

        dq;
    };

    public func dequeToIter<A>(deque : Deque.Deque<A>) : Iter.Iter<A> {
        var iter = deque;

        object {
            public func next() : ?A {
                switch (Deque.popFront(iter)) {
                    case (?(val, next)) {
                        iter := next;
                        ?val;
                    };
                    case (null) null;
                };
            };
        };
    };

    public func dequeToArray<A>(deque : Deque.Deque<A>) : [A] {
        Iter.toArray(
            dequeToIter(deque),
        );
    };

    public func optDequeToArray<A>(deque : ?Deque.Deque<A>) : [A] {
        switch (deque) {
            case (?deque) {
                dequeToArray(deque);
            };
            case (_) { [] };
        };
    };
};
