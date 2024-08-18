Extension { #name : 'IRBytecodeGenerator' }

{ #category : '*StaticCallExp' }
IRBytecodeGenerator >> sendStatic: aMethod [

	| nArgs |
	nArgs := aMethod numArgs.
	stack pop: nArgs.
	encoder genSendStatic: (self literalIndexOf: aMethod)
]
