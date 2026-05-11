Extension { #name : 'SymbolicBytecodeBuilder' }

{ #category : '*StaticCallExp' }
SymbolicBytecodeBuilder >> staticSend: aByte [

	self addBytecode: ('staticSend: '), aByte asString
]
