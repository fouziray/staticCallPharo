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
		'benefit',
		'modifiedNode'
	],
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

{ #category : 'as yet unclassified' }
StaticCallCandidate class >> method: aMethod callSite: anASTNode selector: aSelector receiver: aNode receiverType: aClass [

	^ self new
		  method: aMethod;
		  callSite: anASTNode;
		  selector: aSelector;
		  receiver: aNode;
		  receiverType: aClass
]

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
StaticCallCandidate >> modifiedNode: aRBMessageNode [

	modifiedNode := aRBMessageNode
]

{ #category : 'accessing' }
StaticCallCandidate >> oldNode [

	^ modifiedNode
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
		ifTrue: [ receiverType :=  (self receiver value class lookupSelector: selector)  classBinding value ]
		ifFalse: [ 
			receiverType := aSymbol.
			aSymbol = #self ifTrue:[ receiverType := self receiver methodNode methodClass. ].
			aSymbol = #super ifTrue:[ receiverType := self receiver methodNode methodClass superclass ].  
			aSymbol = #global ifTrue: [ 
				
				|classSideMethods instSideMethods|
			
				instSideMethods := self receiver binding value lookupSelector:self receiver parent selector.
				classSideMethods := self receiver binding value class lookupSelector:self receiver parent selector .
				(instSideMethods isNotNil or:[classSideMethods isNotNil ]) ifTrue: [  ].
				receiverType := self receiver binding value lookupSelector:
 #readFrom: ].
aSymbol = #variable ifTrue:[
		receiverType :=  (self receiver value class lookupSelector: selector)  classBinding value.
		1 halt.
	].
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
