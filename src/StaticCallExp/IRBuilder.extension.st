Extension { #name : 'IRBuilder' }

{ #category : '*StaticCallExp' }
IRBuilder >> sendStatic: aMethod [

	^ self add: (IRSendStatic sendStatic: aMethod)
]
