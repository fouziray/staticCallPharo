Class {
	#name : 'StaticCallVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'candidates',
		'currentScope',
		'method'
	],
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

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

	1 halt.
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

{ #category : 'initialization' }
StaticCallVisitor >> method: aMethod [ 
	method := aMethod


]

{ #category : 'initialization' }
StaticCallVisitor >> visitMessageNode: aMessageNode [
	"Main visitor method for message nodes (method calls)"

	| receiverType candidate onlyDefinedUp |
	receiverType := self analyzeReceiver: aMessageNode receiver.

	"Create candidate if it looks promising"
	(receiverType = #message) ifTrue: [ self evaluatePartial: aMessageNode receiver  ].
	(({ #self. #super. #class. #global. #literal } includes: receiverType)
		 or: [
			 receiverType = #temp and: [
				 self hasStableType: aMessageNode receiver ] ]) ifTrue: [
			onlyDefinedUp := ((method classBinding value lookupSelector: aMessageNode selector) isNotNil) and:[ (method classBinding value allSubclasses anySatisfy: [ :subClass | subClass includesSelector: #processData ]) not].
			
			onlyDefinedUp ifTrue:[
				candidate := StaticCallCandidate new
			             callSite: aMessageNode;
			             selector: aMessageNode selector;
			             receiver: aMessageNode receiver;
			             receiverType: receiverType;
			             method: method;
			             yourself.
		candidates add: candidate
				].
		 ].

	"Continue visiting children"
	super visitMessageNode: aMessageNode
]
