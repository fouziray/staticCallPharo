Class {
	#name : 'SelectorsStats',
	#superclass : 'Object',
	#instVars : [
		'knownValues',
		'environment',
		'residualCode'
	],
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

{ #category : 'devirtualizable' }
SelectorsStats >> devirtualizableCallSitesOfPackage: aPackage [

	| a |
	a := Dictionary new.
	aPackage methods do: [ :key |
		a
			at: key
			put: [ Set newFrom: (self findDevCallsIn: key) ]
			 ].
	^ a
]

{ #category : 'devirtualizable' }
SelectorsStats >> dialDownToNoRedefined: aListOfMessagesWithSelfAsReceiver [
	
	| msgRedefStats devirtualizables|
	
	msgRedefStats := MessageRedefStats new .
	devirtualizables:= aListOfMessagesWithSelfAsReceiver
							 reject:[:message |
									(message selector implementors select: [ :i | 
												(i classBinding value subclasses select:[:subClass | 
													subClass directlyDefinesMethod: message selector  ]) isNotEmpty  ]) isNotEmpty ].
	" to enhance the precision: 
			associating a call tree to call sites until this phase of comparison with implementations. 
			The implementation that have nothing to do with the call tree are then not considered when they have redefinitions. 
			"
	msgRedefStats devirtualizables: devirtualizables.
	^ msgRedefStats
]

{ #category : 'initialization' }
SelectorsStats >> evaluate: aNode [
    ^ aNode acceptVisitor: self
]

{ #category : 'as yet unclassified' }
SelectorsStats >> evaluateWrapInLiteralNode: aRBSequenceNode [ 
	| result |
	result:= self evaluate: aRBSequenceNode .
	(result isKindOf: RBProgramNode) ifFalse: [ result:= RBLiteralNode value: result ].
	^ result
]

{ #category : 'as yet unclassified' }
SelectorsStats >> findDevCallsIn: aCompiledMethod [
	
	| dialedDown |
	
	dialedDown := self dialDownToNoRedefined:
		 (aCompiledMethod  ast sendNodes select: [ :messageNode |
		 messageNode receiver isSelfVariable  ]).
	
	^ dialedDown devirtualizables
	
]

{ #category : 'as yet unclassified' }
SelectorsStats >> findSingleSelectors [

	^ Set newFrom:
		  (SystemNavigation default allMethods collect: [ :m | m selector ])
]

{ #category : 'as yet unclassified' }
SelectorsStats >> findSingleSelectorsWithNumberOfImplementation [

	| dictionary |
	dictionary := Dictionary new.

	(SystemNavigation default allMethods collect: [ :m | m selector ])
		do: [ :e | dictionary at: e update: [ :v | v + 1 ] initial: 1 ].

	^ dictionary
]

{ #category : 'initialization' }
SelectorsStats >> getKnownValue: aSymbol [
    ^ knownValues at: aSymbol ifAbsent: [ nil ]
]

{ #category : 'as yet unclassified' }
SelectorsStats >> getSingleImplementations [

	^ self findSingleSelectorsWithNumberOfImplementation associations select: [ :e |
		  e value = 1 and: [ (e key beginsWith: 'test') not ] ]
]

{ #category : 'initialization' }
SelectorsStats >> hasKnownValue: aSymbol [
    ^ knownValues includesKey: aSymbol
]

{ #category : 'initialization' }
SelectorsStats >> initialize [
    super initialize.
    knownValues := Dictionary new.
    environment := Dictionary new.
    residualCode := OrderedCollection new
]

{ #category : 'as yet unclassified' }
SelectorsStats >> nMorphicMethodsAndTheirNumberInTheSystem [

	| a |
	a := Dictionary new.
	self findSingleSelectorsWithNumberOfImplementation do: [ :key |
		a at: key update: [ :v | v + 1 ] initial: 1 ].
	^ a
]

{ #category : 'initialization' }
SelectorsStats >> setKnownValue: aSymbol to: aValue [
    knownValues at: aSymbol put: aValue
]

{ #category : 'initialization' }
SelectorsStats >> tryEvaluateMessage: receiver selector: selector arguments: args originalNode: aNode [

| allKnown |
    
    allKnown := (receiver isKindOf: RBProgramNode) not and: [
        args allSatisfy: [ :arg | ((arg isKindOf: RBProgramNode) and: [ arg isLiteralNode not ]) not ]
    ].

	allKnown ifTrue: [
        ^ [ receiver perform: selector withArguments: args ]
            on: Error
            do: [ :ex | aNode ]
    ] ifFalse: [ ^ aNode ].
]

{ #category : 'initialization' }
SelectorsStats >> visitAssignmentNode: aNode [

	| varName value |
	varName := aNode variable name asSymbol.
	value := self evaluate: aNode value.

	(value isKindOf: RBProgramNode) ifFalse: [	
				self setKnownValue: varName to: value ].

	^ aNode
]

{ #category : 'visiting' }
SelectorsStats >> visitBlockNode: aRBBlockNode [ 
	| newBody |
    newBody := aRBBlockNode body statements collect: [ :stmt | self evaluateWrapInLiteralNode: stmt ].
	newBody last isLiteralNode ifTrue:[^ newBody last ].
    ^ RBBlockNode arguments: aRBBlockNode arguments body: (RBSequenceNode statements: newBody)
]

{ #category : 'initialization' }
SelectorsStats >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode value
]

{ #category : 'visiting' }
SelectorsStats >> visitLiteralValueNode: aRBLiteralValueNode [ 
	^ aRBLiteralValueNode value
]

{ #category : 'initialization' }
SelectorsStats >> visitMessageNode: aNode [

    | receiver args selector |
  self haltIf: aNode selector = #isCloser.
    receiver := self evaluate: aNode receiver.
    args := aNode arguments collect: [ :arg | self evaluate: arg ].
  
    ^ self tryEvaluateMessage: receiver selector: aNode selector arguments: args originalNode: aNode
]

{ #category : 'visiting' }
SelectorsStats >> visitSequenceNode: aRBSequenceNode [ 

	^ aRBSequenceNode statements collect:[: statement | self evaluate: statement ]
]

{ #category : 'initialization' }
SelectorsStats >> visitVariableNode: aNode [

    | varName |
    varName := aNode name asSymbol.
    ^ (self hasKnownValue: varName)
        ifTrue: [ self getKnownValue: varName ]
        ifFalse: [ aNode ]

]
