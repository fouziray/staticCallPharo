Class {
	#name : 'CallSiteModel',
	#superclass : 'Object',
	#instVars : [
		'methodClassName',
		'methodSelector',
		'sourceStart',
		'sourceEnd',
		'source',
		'bytecodeStart',
		'bytecodeEnd',
		'methodsActivated',
		'selector'
	],
	#category : 'PolymorphicCallSites-Model',
	#package : 'PolymorphicCallSites',
	#tag : 'Model'
}

{ #category : 'instance creation' }
CallSiteModel class >> fromRaw: aCollection [ 
	
	^ self new
		fromRaw: aCollection;
		yourself
]

{ #category : 'accessing' }
CallSiteModel >> fetchSelector [
	^ methodsActivated first compiledMethodName copyAfterLast: $#
]

{ #category : 'instance creation' }
CallSiteModel >> fillKey: 	aCollection [
	
	| messageNode |
	messageNode := aCollection key.
	
	methodClassName := messageNode methodNode methodClass name.
	methodSelector := messageNode methodNode selector.
	sourceStart := messageNode start.
	sourceEnd := messageNode stop.
	source := messageNode sourceCode.
	
	(messageNode methodNode pcsForNode: messageNode) ifNotEmpty: [	
			bytecodeStart := (messageNode methodNode pcsForNode: messageNode) first.
			bytecodeEnd := (messageNode methodNode pcsForNode: messageNode) last. 	 ]

]

{ #category : 'instance creation' }
CallSiteModel >> fromRaw: aCollection [ 
	
	self fillKey: aCollection.
	methodsActivated := aCollection value associations collect: [ :e | MethodActivatedModel fromRaw: e ].
	selector := self fetchSelector.
]

{ #category : 'accessing' }
CallSiteModel >> numberOfCalls [
	
	^ methodsActivated sum: [ :m | m numberOfCalls ]
]

{ #category : 'as yet unclassified' }
CallSiteModel >> numberOfDifferentMethods [
	
	^ methodsActivated size
]

{ #category : 'as yet unclassified' }
CallSiteModel >> numberOfReceiverClasses [
	
	^ methodsActivated sum: [ :m | m numberOfReceiverClasses ]
]

{ #category : 'accessing' }
CallSiteModel >> selector [
	^ selector
]
