import Buffer "mo:base/Buffer";

module{
    public func arrayToBuffer <T>(arr: [T]): Buffer.Buffer<T>{
        let buffer = Buffer.Buffer<T>(arr.size());
        for (n in arr.vals()){
            buffer.add(n);
        };
        return buffer;
    };
}