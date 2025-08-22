Class {
	#name : 'PartialEvaluator',
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

{ #category : 'initialization' }
PartialEvaluator >> evaluate: aNode [
    ^ aNode acceptVisitor: self
]

{ #category : 'as yet unclassified' }
PartialEvaluator >> evaluateWrapInLiteralNode: aRBSequenceNode [ 
	| result |
	result:= self evaluate: aRBSequenceNode .
	(result isKindOf: RBProgramNode) ifFalse: [ result:= RBLiteralNode value: result ].
	^ result
]

{ #category : 'initialization' }
PartialEvaluator >> getKnownValue: aSymbol [
    ^ knownValues at: aSymbol ifAbsent: [ nil ]
]

{ #category : 'initialization' }
PartialEvaluator >> hasKnownValue: aSymbol [
    ^ knownValues includesKey: aSymbol
]

{ #category : 'initialization' }
PartialEvaluator >> initialize [
    super initialize.
    knownValues := Dictionary new.
    environment := Dictionary new.
    residualCode := OrderedCollection new
]

{ #category : 'initialization' }
PartialEvaluator >> setKnownValue: aSymbol to: aValue [
    knownValues at: aSymbol put: aValue
]

{ #category : 'initialization' }
PartialEvaluator >> tryEvaluateMessage: receiver selector: selector arguments: args originalNode: aNode [

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
PartialEvaluator >> visitAssignmentNode: aNode [

	| varName value |
	varName := aNode variable name asSymbol.
	value := self evaluate: aNode value.

	(value isKindOf: RBProgramNode) ifFalse: [	
				self setKnownValue: varName to: value ].

	^ aNode
]

{ #category : 'visiting' }
PartialEvaluator >> visitBlockNode: aRBBlockNode [ 
	| newBody |
    newBody := aRBBlockNode body statements collect: [ :stmt | self evaluateWrapInLiteralNode: stmt ].
	newBody last isLiteralNode ifTrue:[^ newBody last ].
    ^ RBBlockNode arguments: aRBBlockNode arguments body: (RBSequenceNode statements: newBody)
]

{ #category : 'initialization' }
PartialEvaluator >> visitLiteralNode: aLiteralNode [

	^ aLiteralNode value
]

{ #category : 'visiting' }
PartialEvaluator >> visitLiteralValueNode: aRBLiteralValueNode [ 
	^ aRBLiteralValueNode value
]

{ #category : 'initialization' }
PartialEvaluator >> visitMessageNode: aNode [

    | receiver args selector |
    receiver := self evaluate: aNode receiver.
    args := aNode arguments collect: [ :arg | self evaluate: arg ].
    
    ^ self tryEvaluateMessage: receiver selector: aNode selector arguments: args originalNode: aNode
]

{ #category : 'visiting' }
PartialEvaluator >> visitSequenceNode: aRBSequenceNode [ 

	^ aRBSequenceNode statements collect:[: statement | self evaluate: statement ]
]

{ #category : 'initialization' }
PartialEvaluator >> visitVariableNode: aNode [

    | varName |
    varName := aNode name asSymbol.
    ^ (self hasKnownValue: varName)
        ifTrue: [ self getKnownValue: varName ]
        ifFalse: [ aNode ]

]
