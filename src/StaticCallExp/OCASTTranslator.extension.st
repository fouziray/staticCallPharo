Extension { #name : 'OCASTTranslator' }

{ #category : '*StaticCallExp' }
OCASTTranslator >> emitStaticMessageNode: aStaticMessageNode [

	| target |

	aStaticMessageNode isCascaded ifFalse: [
		self visitNode: aStaticMessageNode receiver ].
	aStaticMessageNode arguments do: [ :each | self visitNode: each ].
	"aStaticMessageNode isSuperSend
		ifTrue: [methodBuilder send: aStaticMessageNode selector toSuperOf: aStaticMessageNode superOf ]
		ifFalse: ["
	aStaticMessageNode staticClass
		ifNotNil: [
			aStaticMessageNode staticClass isClass ifTrue: [
				(Smalltalk globals classNamed:
					 aStaticMessageNode staticClass className) ifNotNil: [
					target:= (aStaticMessageNode staticClass lookupSelector:
							 (aStaticMessageNode selector substrings: '_') last asSymbol).
							target ifNil: [ methodBuilder send: aStaticMessageNode selector ]ifNotNil: 
					[methodBuilder sendStatic: target ]
						 ] ] ]
		ifNil: [
			"|targetResolver|
			targetResolver := TargetResolver resolveSelector: aStaticMessageNode selector.
			targetResolver visitNode: aStaticMessageNode receiver."
			 
			aStaticMessageNode receiver value isGlobalVariable
				ifTrue: [
					target := ((aStaticMessageNode receiver methodNode scope
						           lookupVar: aStaticMessageNode receiver name) value 
						          class) lookupSelector: aStaticMessageNode selector asSymbol.
						
						 ]
				ifFalse: [
					aStaticMessageNode receiver value isLiteral ifFalse:[
					aStaticMessageNode receiver value isPseudoVariable ifTrue:[
						|currentClass |
						currentClass := aStaticMessageNode receiver methodNode scope targetClass.
						currentClass = UndefinedObject ifTrue:[ currentClass :=self compilationContext semanticScope targetClass  ]. 
						aStaticMessageNode receiver value name  = #self ifTrue: [  target := currentClass  lookupSelector: (aStaticMessageNode selector substrings: '_') last.   ].
						 1 halt.
						  ].].
					target := aStaticMessageNode receiver value class
						          lookupSelector: aStaticMessageNode selector asSymbol ].
 
			target ifNil:[1 halt.].		
			methodBuilder sendStatic: target ]
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
