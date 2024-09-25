Extension { #name : 'OCASTTranslator' }

{ #category : '*StaticCallExp' }
OCASTTranslator >> emitStaticMessageNode: aStaticMessageNode [

	aStaticMessageNode isCascaded ifFalse: [
		self visitNode: aStaticMessageNode receiver ].
	aStaticMessageNode arguments do: [ :each | self visitNode: each ].
	"aStaticMessageNode isSuperSend
		ifTrue: [methodBuilder send: aStaticMessageNode selector toSuperOf: aStaticMessageNode superOf ]
		ifFalse: ["
	aStaticMessageNode staticClass
		ifNotNil: [
			(Smalltalk globals classNamed: aStaticMessageNode staticClass)
				ifNotNil: [ 
					methodBuilder sendStatic:
						((Smalltalk globals classNamed: aStaticMessageNode staticClass)
							 compiledMethodAt: aStaticMessageNode selector asSymbol) ] ]
		ifNil: [
			methodBuilder sendStatic:
				(aStaticMessageNode receiver value class compiledMethodAt:
					 aStaticMessageNode selector asSymbol) ]
]

{ #category : '*StaticCallExp' }
OCASTTranslator >> visitStaticMessageNode: aMessageNode [

	"aMessageNode isAnnotation ifTrue: [
		^ aMessageNode receiver emitValue: methodBuilder ].

	aMessageNode isInlined ifTrue: [
		methodBuilder addLiteral: aMessageNode selector. 
		^self
			perform: (OptimizedMessages at: aMessageNode selector)
			with: aMessageNode]."
	^ self emitStaticMessageNode: aMessageNode
]
