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
		'frequencyOfFirstElement',
		'numberOfCalls',
		'numberOfReceiverClasses',
		'allTypesFreq',
		'flattenedTypes',
		'isSelfSend',
		'typesPattern',
		'switchRatio',
		'firstSwitchIndex'
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
CallSiteModel >> bytecodeStart [
	^ bytecodeStart
]

{ #category : 'accessing' }
CallSiteModel >> computeTypes [

	flattenedTypes := (methodsActivated collect: #receiverTypes )flattened asBag
]

{ #category : 'as yet unclassified' }
CallSiteModel >> disparity [

	^ frequencyOfFirstElement ifNil: [
 		frequencyOfFirstElement := self findDisparities ]
]

{ #category : 'accessing' }
CallSiteModel >> dominance [

	^ (self dominantTypeNumberOfCalls / self numberOfCalls) asFloat
]

{ #category : 'accessing' }
CallSiteModel >> dominantClass [

	^ OpalCompiler new source: self dominantType; evaluate.
]

{ #category : 'accessing' }
CallSiteModel >> dominantType [
	^	flattenedTypes sortedCounts first value

]

{ #category : 'accessing' }
CallSiteModel >> dominantTypeNumberOfCalls [

	^ flattenedTypes sortedCounts first key
]

{ #category : 'accessing' }
CallSiteModel >> dominantTypeWithThreshold: anInteger [

	| tmp |
	tmp := self dominantTypeNumberOfCalls.
	^ (tmp / self numberOfCalls) asFloat * 100 > anInteger
		  ifTrue: [ self dominantType ]
		  ifFalse: [ nil ]
]

{ #category : 'accessing' }
CallSiteModel >> fetchSelector [

	selector := methodsActivated first compiledMethodName copyAfterLast: $#
]

{ #category : 'instance creation' }
CallSiteModel >> fillKey: aCollection [

	| messageNode |
	messageNode := aCollection key.

	methodClassName := messageNode methodNode methodClass name.
	methodSelector := messageNode methodNode selector.
	sourceStart := messageNode start.
	sourceEnd := messageNode stop.
	source := messageNode sourceCode.
	isSelfSend := messageNode receiver isSelfVariable.

	(messageNode methodNode pcsForNode: messageNode) ifNotEmpty: [
		bytecodeStart := (messageNode methodNode pcsForNode: messageNode)
			                 first.
		bytecodeEnd := (messageNode methodNode pcsForNode: messageNode) last ]
]

{ #category : 'as yet unclassified' }
CallSiteModel >> findDisparities [
	| orderedByFrequ numberOfCallsPerType totalCalls |
	numberOfCallsPerType := methodsActivated flatCollect: [ :e | e receiverTypes ] as: Bag.
	orderedByFrequ := numberOfCallsPerType sortedCounts.
	totalCalls := numberOfCallsPerType size.

	allTypesFreq := (orderedByFrequ collect:[:e | (e key / totalCalls) asFloat ]). 
	^ allTypesFreq first	
]

{ #category : 'accessing' }
CallSiteModel >> firstSwitchAt: index [

	firstSwitchIndex:= index
]

{ #category : 'accessing' }
CallSiteModel >> firstSwitchIndex [

	^ firstSwitchIndex
]

{ #category : 'instance creation' }
CallSiteModel >> fromRaw: aCollection [ 

	self fillKey: aCollection.
	methodsActivated := aCollection value associations collect: [ :e | MethodActivatedModel fromRaw: e ].
 	self fetchSelector.
	self computeTypes.
]

{ #category : 'testing' }
CallSiteModel >> hasThisPattern: aCollection [ 
	typesPattern:= aCollection collect: #asString
]

{ #category : 'accessing' }
CallSiteModel >> isSelfSend [
	^ isSelfSend
]

{ #category : 'accessing' }
CallSiteModel >> method [
	^ OpalCompiler new source: self methodName ; evaluate.
]

{ #category : 'accessing' }
CallSiteModel >> methodClass [

	^  OpalCompiler new source: methodClassName; evaluate.
]

{ #category : 'accessing' }
CallSiteModel >> methodClassName [

	^ methodClassName
]

{ #category : 'accessing' }
CallSiteModel >> methodName [

	^ methodClassName , '>>#' , methodSelector
]

{ #category : 'accessing' }
CallSiteModel >> methodSelector [
	^ methodSelector
]

{ #category : 'accessing' }
CallSiteModel >> methodsActivated [

	^ methodsActivated
]

{ #category : 'accessing' }
CallSiteModel >> methodsActivated: anObject [

	methodsActivated := anObject
]

{ #category : 'accessing' }
CallSiteModel >> numberOfCalls [
	
	^ numberOfCalls ifNil: [ numberOfCalls := methodsActivated sum: [ :m | m numberOfCalls ] ]
]

{ #category : 'as yet unclassified' }
CallSiteModel >> numberOfDifferentMethods [
	
	^ methodsActivated size
]

{ #category : 'as yet unclassified' }
CallSiteModel >> numberOfReceiverClasses [
	
	^ numberOfReceiverClasses ifNil: [ numberOfReceiverClasses := methodsActivated sum: [ :m | m numberOfReceiverClasses ] ]
]

{ #category : 'as yet unclassified' }
CallSiteModel >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: '( ', selector , ', #calls: '.
	aStream nextPutAll: self numberOfCalls asString.
	aStream nextPutAll: ', #types: '.
	aStream nextPutAll: self numberOfReceiverClasses asString.
	aStream nextPutAll: ', #methods: '.
	aStream nextPutAll: self numberOfDifferentMethods asString.
	aStream nextPutAll: ')'.
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

{ #category : 'accessing' }
CallSiteModel >> sourceStart [
	^ sourceStart
]

{ #category : 'accessing' }
CallSiteModel >> switchRatio [
	^ switchRatio
]

{ #category : 'accessing' }
CallSiteModel >> switchRatio: aNumber [ 
	switchRatio:= aNumber 
]

{ #category : 'accessing' }
CallSiteModel >> typesPattern [

	^ typesPattern
]

{ #category : 'accessing' }
CallSiteModel >> typesPattern: anObject [

	typesPattern := anObject
]
