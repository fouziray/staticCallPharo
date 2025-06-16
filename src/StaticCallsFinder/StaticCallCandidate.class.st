Class {
	#name : 'StaticCallCandidate',
	#superclass : 'Object',
	#instVars : [
		'method',
		'callSite',
		'selector',
		'receiver',
		'receiverType',
		'confidence',
		'benefit'
	],
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

{ #category : 'accessing' }
StaticCallCandidate >> benefit [

	^ benefit 
]

{ #category : 'accessing' }
StaticCallCandidate >> benefit: aNumber [

	benefit := aNumber 
]

{ #category : 'accessing' }
StaticCallCandidate >> callSite [

	^ callSite
]

{ #category : 'accessing' }
StaticCallCandidate >> callSite: aNode [ 

 callSite := aNode 

]

{ #category : 'accessing' }
StaticCallCandidate >> confidence [

	^ confidence 
]

{ #category : 'accessing' }
StaticCallCandidate >> confidence: aNumber [

	confidence := aNumber
]

{ #category : 'accessing' }
StaticCallCandidate >> method [

	^ method
]

{ #category : 'accessing' }
StaticCallCandidate >> method: aMethod [ 
 method := aMethod 

]

{ #category : 'accessing' }
StaticCallCandidate >> printOn: aStream [
 
aStream 
		nextPutAll: method methodClass name;
		nextPutAll:'>>>';
		nextPutAll: method selector;
		nextPutAll: ' -> ';
		nextPutAll: selector asString;
		nextPutAll: ' (';
		nextPutAll: receiverType asString.
]

{ #category : 'accessing' }
StaticCallCandidate >> receiver [ 

 ^ receiver
]

{ #category : 'accessing' }
StaticCallCandidate >> receiver: aNode [ 
 receiver := aNode
]

{ #category : 'accessing' }
StaticCallCandidate >> receiverType [

	^ receiverType
]

{ #category : 'accessing' }
StaticCallCandidate >> receiverType: aSymbol [

	aSymbol = #literal
		ifTrue: [ receiverType := self receiver value className ]
		ifFalse: [ 
			receiverType := aSymbol.
			aSymbol = #self ifTrue:[ receiverType := self receiver methodNode methodClass. ].
			aSymbol = #super ifTrue:[ receiverType := self receiver methodNode methodClass superclass ].  
			aSymbol = #global ifTrue: [ 
				
				|classSideMethods instSideMethods|
				1 halt.
				instSideMethods := self receiver binding value lookupSelector:self receiver parent selector.
				classSideMethods := self receiver binding value class lookupSelector:self receiver parent selector .
				(instSideMethods or:[classSideMethods]) ifNotNil: [  ].
				receiverType := self receiver binding lookupSelector:
 #readFrom: ].
			]
]

{ #category : 'accessing' }
StaticCallCandidate >> selector [

	^ selector
]

{ #category : 'accessing' }
StaticCallCandidate >> selector: aSelector [
 
 selector := aSelector 
]
