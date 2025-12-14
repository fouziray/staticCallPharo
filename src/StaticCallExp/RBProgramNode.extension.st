Extension { #name : 'RBProgramNode' }

{ #category : '*StaticCallExp' }
RBProgramNode >> hasStaticCall [

	^ (((self allChildren select: #isMessage)) select:#isStaticCall) isNotEmpty 
]
