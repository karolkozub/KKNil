KKNil
=====

`KKNil` allows you to create objects that behave in a silimar way to `nil`. A `KKNil` object will respond to the same methods its class instances or protocol conformers respond to, and return the equivalent of zero.

Usage
-----

You can choose one of the two available factory methods to create a `KKNil` object. As the names suggest `+[KKNil nilForClass:]` will create an object that can be used in place of instances of that class and `+[KKNil nilForProtocol:]` will create analogous objects for a protocol.

Instances of this class can be useful when you want to return `nil`, but need to provide an object. This can happen for example when you need to put the result in an array or dictionary, or use the object as a forwarding target. In many cases it may be wiser to use `nil` or `NSNull` instead though.

Limitations
-----------

`KKNil` uses a static 8192-byte array to provide zero return values to `NSInvocations`. If you intend to return structures larger than that by value, you may want to increase that size or change your approach. Also, because of `NSInvocation` limitations, `KKNil` doesn't support methods that use `union` types as arguments or return values.
