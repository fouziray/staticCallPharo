Extension { #name : 'VMJitMethodTest' }

{ #category : '*StaticCallExpBuilder-Tests' }
VMJitMethodTest >> testJitCompiledStaticRanWithnewTrampoline [
 "inspired by testJitCOmpiledFLoat32VectorAddition"

	| callingMethod cm x y z |
	x := self new32BitIndexableFromArray:
		     #( 1.0 2.0 3.0 4.0 5.0 6.0 7.0 8.0 ).
	y := self new32BitIndexableFromArray:
		     #( 10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 ).
	z := self new32BitIndexableOfSize: 8.

	cm := IRBuilder buildMethod: [ :builder | "TODO handle arrays with an odd number of elements"
		      builder
			      numArgs: 3;
			      addTemps:
				      { #firstVector. #secondVector. #thirdVector. #i. #end };
			      pushLiteral: 0;
			      storeTemp: #i;
			      popTop;
			      pushLiteral: 8;
			      storeTemp: #end;
			      popTop;
			      jumpBackTarget: #loop;
			      pushTemp: #end;
			      pushTemp: #i;
			      send: #'==';
			      jumpAheadTo: #exit if: true;
			      pushTemp: #i;
			      pushTemp: #firstVector;
			      pushFloat32ArrayToRegister;
			      pushTemp: #i;
			      pushTemp: #secondVector;
			      pushFloat32ArrayToRegister;
			      addFloat32Vector;
			      pushTemp: #i;
			      pushTemp: #thirdVector;
			      storeFloat32RegisterIntoArray;
			      popTop;
			      pushTemp: #i;
			      pushLiteral: 4;
			      send: #+;
			      storeTemp: #i;
			      popTop;
			      jumpBackTo: #loop;
			      jumpAheadTarget: #exit;
			      pushTemp: #thirdVector;
			      returnTop ].

	self class addSelector: #addVector:with:intoVector: withMethod: cm.

	callingMethod := self jitMethod:
		                 (self findMethod: #addVector:with:intoVector:).

	wordSize = 4 ifTrue: [ ^ self assert: callingMethod isNil ].

	self initStack.

	self
		callCogMethod: callingMethod
		receiver: memory nilObject
		arguments: {
				x.
				y.
				z }
		returnAddress: callerAddress.

	self assert: machineSimulator receiverRegisterValue equals: z.
	self assert: (memory fetchFloat32: 0 ofObject: z) equals: 11.0.
	self assert: (memory fetchFloat32: 1 ofObject: z) equals: 22.0.
	self assert: (memory fetchFloat32: 2 ofObject: z) equals: 33.0.
	self assert: (memory fetchFloat32: 3 ofObject: z) equals: 44.0.
	self assert: (memory fetchFloat32: 4 ofObject: z) equals: 55.0.
	self assert: (memory fetchFloat32: 5 ofObject: z) equals: 66.0.
	self assert: (memory fetchFloat32: 6 ofObject: z) equals: 77.0.
	self assert: (memory fetchFloat32: 7 ofObject: z) equals: 88.0
]
