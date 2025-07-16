Extension { #name : 'VMByteCodesTest' }

{ #category : '*StaticCallExpBuilder' }
VMByteCodesTest >> testStaticSendMessageWithTwoArgumentsMakeAFrame [

	| selectorOop aMethod aMethodToActivate receiver receiverClass aMethodDictionary arg1 arg2 |
	selectorOop := memory integerObjectOf: 42.
	
	aMethodToActivate := methodBuilder newMethod
		                     numberOfArguments: 2;
									bytecodes: #[32 "PushLiteral 1"
				92 "Return top"];
		                     buildMethod.
		methodBuilder newMethod literals: { aMethodToActivate }.
	aMethod := methodBuilder buildMethod.
	receiver := memory integerObjectOf: 41.
	receiverClass := self setSmallIntegerClassIntoClassTable.
	self setUpMethodDictionaryIn: receiverClass.
	aMethodDictionary := memory
		                     fetchPointer: MethodDictionaryIndex
		                     ofObject: receiverClass.

	self
		installSelector: selectorOop
		method: aMethodToActivate
		inMethodDictionary: aMethodDictionary.
	arg1 := memory integerObjectOf: 1.
	arg2 := memory integerObjectOf: 2.
	stackBuilder addNewFrame
		method: aMethod;
		stack: { 
				receiver.
				}.
	stackBuilder buildStack.

	interpreter methodDictLinearSearchLimit: 3.
	interpreter setBreakSelector: nil.
	interpreter method: aMethod.
	interpreter currentBytecode: 246.
	memory byteAt:   interpreter instructionPointer + 1 put:0 .
	self interpret: [ interpreter sendStaticLiteralMethodBytecode  ].

"Need to assert that the interpreter newMethod is the called method"
	self assert: interpreter stackTop equals: 1
]
