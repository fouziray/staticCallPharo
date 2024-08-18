Extension { #name : 'IRMethod' }

{ #category : '*StaticCallExp' }
IRMethod >> generate [

	| irTranslator |
   irTranslator := IRTranslator context: self compilationContext.
	irTranslator
		visitNode: self;
		pragmas: pragmas.
	compiledMethod := irTranslator compiledMethod.
	compiledMethod literals doWithIndex: [ :e :index |
		(e isKindOf: StaticRecursiveMethodPlaceHolder)
			ifTrue: [ compiledMethod literalAt: index put: compiledMethod ] ].
	self sourceNode
		ifNotNil: [
			compiledMethod classBinding: self sourceNode methodClass binding.
			compiledMethod selector: self sourceNode selector ]
		ifNil: [
			compiledMethod classBinding: UndefinedObject binding.
			compiledMethod selector: #UndefinedMethod ].
	^ compiledMethod
]
