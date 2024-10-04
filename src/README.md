This is the code for the static calls feature in the static calls hands on chapter of the Pharo Virtual Machine.

You can load it using this baseline:

```
Metacello new
baseline: 'StaticCallExp';
repository: 'gitlab://gitlab.com:fouziray/StaticCallPharo:master/src';
load
```
To apply the changes we have to compile the vm as described in the chapter.


This gives the possibility to tag message selectors with _ to call the method in the receiver's class only, without lookup in super classes.

However, this isn't efficient for cases where the method is defined in a class that is not instantiated in the system. For example, the factorial method that can be used for benchmarking, is only defined in the Integer class, while all Integers are either instantiated as SmallInteger, LargePositiveInteger, LargeNegativeInteger.

To be able to reach these methods we try to Tag variables with class of the method to be invoked, we can have take following syntax examples:
- ``` 5 _Integer>>#factorial ```. 
- ``` (Integer>>#factorial) invokeWithReceiver: 5 withArgs:{ arg1, ... } ``` 
- ``` [Integer,4]factorial  ```

