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
		'selector',
		'frequencyOfFirstElement'
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

{ #category : 'as yet unclassified' }
CallSiteModel >> disparity [
  ^ frequencyOfFirstElement 
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

{ #category : 'as yet unclassified' }
CallSiteModel >> findDisparities [
	| orderedByFrequ |
	orderedByFrequ := self receiverTypesBag sorted collect: [:e | e sortedCounts ].
	
	  frequencyOfFirstElement:=  (orderedByFrequ collect:[:e | e first key / ((e collect:#key) sum ) ]) first.
	^ frequencyOfFirstElement 
	
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

{ #category : 'as yet unclassified' }
CallSiteModel >> receiverClassesFrequency [
	 
	 ^ methodsActivated collect: [ :m | m receiverClassesFrequency ].
	 
]

{ #category : 'as yet unclassified' }
CallSiteModel >> receiverTypesBag [
	 
	 ^ methodsActivated collect: [ :m | m receiverTypes ].
	 
]

{ #category : 'accessing' }
CallSiteModel >> selector [
	^ selector
]
