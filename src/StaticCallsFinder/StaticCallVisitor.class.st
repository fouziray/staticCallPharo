Class {
	#name : 'StaticCallVisitor',
	#superclass : 'OCProgramNodeVisitor',
	#instVars : [
		'candidates',
		'currentScope',
		'method',
		'messageNode',
		'receiverType',
		'interproceduralVisitor'
	],
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

{ #category : 'adding' }
StaticCallVisitor >> addCandidate [
|candidate|
candidate := SCandidate new
			             callSite: messageNode;
			             selector: messageNode selector;
			             receiver: messageNode receiver;
			             receiverType: receiverType;
			             method: method;
			             yourself.
		candidates add: candidate
]

{ #category : 'initialization' }
StaticCallVisitor >> analyzeReceiver: aReceiverNode [
	"Determine the type of receiver"

	(aReceiverNode isLiteralNode) ifTrue: [
		^ #literal ].
	aReceiverNode isGlobalVariable ifTrue: [ ^ #global ].
	aReceiverNode isVariable ifTrue: [
		aReceiverNode name = 'self' ifTrue: [ ^ #self ].
		aReceiverNode name = 'super' ifTrue: [ ^ #super ].
		(aReceiverNode name endsWith: 'class') ifTrue: [ ^ #class ].
		^ #temp ].
	aReceiverNode isMessage ifTrue: [ ^ #message ].
	^ #unknown
]

{ #category : 'initialization' }
StaticCallVisitor >> candidates [ 
	^ candidates


]

{ #category : 'as yet unclassified' }
StaticCallVisitor >> evaluatePartial: aMessageNode [


]

{ #category : 'initialization' }
StaticCallVisitor >> hasStableType: aVariableNode [ 
	"Check if variable likely has stable type based on context"
	| name |
	aVariableNode isVariable ifFalse: [ ^ false ].
	
	name := aVariableNode name asLowercase.
	
	"Type hint in variable name"
	^ (#('astring' 'anumber' 'aninteger' 'afloat' 'aboolean' 'anarray' 'acollection') 
		anySatisfy: [ :hint | name beginsWith: hint ])

]

{ #category : 'initialization' }
StaticCallVisitor >> initialize [ 
	super initialize.
	candidates := OrderedCollection new.
	currentScope := Dictionary new.

]

{ #category : 'visiting' }
StaticCallVisitor >> interproceduralVisitor [ 
^ interproceduralVisitor 
]

{ #category : 'visiting' }
StaticCallVisitor >> interproceduralVisitor: aDevirtualizeAnalyzer [

	interproceduralVisitor := aDevirtualizeAnalyzer
]

{ #category : 'initialization' }
StaticCallVisitor >> method: aMethod [ 
	method := aMethod


]

{ #category : 'visiting' }
StaticCallVisitor >> visitArrayNode: anArrayNode [
	| onlyDefinedUp |

	onlyDefinedUp := ( (receiverType := Array lookupSelector: messageNode selector) isNotNil) and:[ (Array allSubclasses anySatisfy: [ :subClass | subClass includesSelector: messageNode selector ]) not].
			
	onlyDefinedUp ifTrue:[ self addCandidate.
		
		
	interproceduralVisitor trackVariable: anArrayNode  ].
]

{ #category : 'visiting' }
StaticCallVisitor >> visitBlockNode: aBlockNode [

]

{ #category : 'visiting - variables' }
StaticCallVisitor >> visitGlobalVariableNode: aGloabl [

| onlyDefinedUp |

onlyDefinedUp := (( receiverType := aGloabl binding value classSide lookupSelector: messageNode selector) isNotNil) and:[ (aGloabl binding value classSide allSubclasses anySatisfy: [ :subClass | subClass includesSelector: messageNode selector ]) not].
	
	onlyDefinedUp ifTrue: [ self addCandidate .
		
		
	interproceduralVisitor trackVariable: aGloabl ]
]

{ #category : 'visiting' }
StaticCallVisitor >> visitLiteralValueNode: aLiteral [

| onlyDefinedUp |
onlyDefinedUp := ((receiverType := aLiteral value class lookupSelector: messageNode selector) isNotNil) and:[ (aLiteral value class allSubclasses anySatisfy: [ :subClass | subClass includesSelector: messageNode selector ]) not].

onlyDefinedUp ifTrue: [ self addCandidate 
	]
]

{ #category : 'initialization' }
StaticCallVisitor >> visitMessageNode: aMessageNode [

	|  candidate onlyDefinedUp |

	receiverType := self analyzeReceiver: aMessageNode receiver.
	messageNode:= aMessageNode.
	aMessageNode receiver acceptVisitor: self.	
	
	"Create candidate if it looks promising"
	(receiverType = #message) ifTrue: [ self evaluatePartial: aMessageNode receiver  ].
	(({ #self. #super. #class. #global. #literal } includes: receiverType)
		 or: [
			 receiverType = #temp and: [
				 self hasStableType: aMessageNode receiver ] ]) ifTrue: [
			
			"onlyDefinedUp := ((method classBinding value lookupSelector: aMessageNode selector) isNotNil) and:[ (method classBinding value allSubclasses anySatisfy: [ :subClass | subClass includesSelector: aMessageNode selector ]) not].
			"
		 ].

	"Continue visiting children"
	self visitMessageNodeArgumentsOnly: aMessageNode
]

{ #category : 'visiting' }
StaticCallVisitor >> visitMessageNodeArgumentsOnly: aMessageNode [ 
	
	self visitNode: aMessageNode selectorNode.
	aMessageNode arguments do: [ :each | self visitNode: each ]
]

{ #category : 'visiting' }
StaticCallVisitor >> visitSelfNode: aSelfNode [
	| onlyDefinedUp |
	
	onlyDefinedUp := ((receiverType:= method classBinding value lookupSelector: messageNode selector) isNotNil) and:[ (method classBinding value allSubclasses anySatisfy: [ :subClass | subClass includesSelector: messageNode selector ]) not].
			onlyDefinedUp ifTrue:[self addCandidate.
				
	interproceduralVisitor trackVariable: aSelfNode  ].
			
]

{ #category : 'visiting' }
StaticCallVisitor >> visitSuperNode: aNode [

| onlyDefinedUp |
	onlyDefinedUp := ( (receiverType := method classBinding value superclass lookupSelector: messageNode selector) isNotNil) and:[ (method classBinding value withAllSubclasses anySatisfy: [ :subClass | subClass includesSelector: messageNode selector ]) not].
	onlyDefinedUp ifTrue:[self addCandidate.
		
	interproceduralVisitor trackVariable: aNode  ]
]

{ #category : 'visiting' }
StaticCallVisitor >> visitVariableNode: aVariableNode [
1 halt.
interproceduralVisitor markVariableAsEscaped: aVariableNode 
	
]
