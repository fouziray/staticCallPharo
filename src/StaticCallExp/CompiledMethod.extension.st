Extension { #name : 'CompiledMethod' }

{ #category : '*StaticCallExp' }
CompiledMethod >> invokeWithReceiver: receiver withArgs: anArrayOfArgs [

	^ self valueWithReceiver: receiver arguments: anArrayOfArgs
]
