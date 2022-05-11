import Debug "mo:base/Debug";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

import ActorSpec "./utils/ActorSpec";
import MVMap "../src";

let {
    assertTrue; assertFalse; assertAllTrue; describe; it; skip; pending; run
} = ActorSpec;

let success = run([
    describe("Ordered MultiValueMap fns", [
        it("add()", do {
            let mvMap = MVMap.MultiValueMap<Text, Text>(Text.equal, Text.hash);
            mvMap.add("key", "val1");
            mvMap.add("key", "val2");
            mvMap.add("key", "val3");

            let entries = Iter.toArray(mvMap.entries());

            assertTrue( 
                entries == [("key", ["val1", "val2", "val3"])]
            );
        }),
        
        it("removeAll()", do {
            let mvMap = MVMap.MultiValueMap<Text, Text>(Text.equal, Text.hash);
            mvMap.add("key", "val1");
            mvMap.add("key", "val2");
            mvMap.add("key", "val3");

            let prevEntries =  mvMap.removeAll();

            let entries = Iter.toArray(mvMap.entries());

            assertAllTrue([
                prevEntries.size() > 0,
                entries == []
            ]);
        })
    ])
]);

if(success == false){
  Debug.trap("Tests failed");
}else{
    Debug.print("\1b[23;45;64m Success!");
}