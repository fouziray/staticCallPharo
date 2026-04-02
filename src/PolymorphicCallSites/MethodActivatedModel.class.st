Class {
	#name : 'MethodActivatedModel',
	#superclass : 'Object',
	#instVars : [
		'compiledMethodName',
		'receiverTypes',
		'dominantType'
	],
	#category : 'PolymorphicCallSites-Model',
	#package : 'PolymorphicCallSites',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MethodActivatedModel class >> fromRaw: anAssociation [

	^ self new
		fromRaw: anAssociation;
		yourself
]

{ #category : 'accessing' }
MethodActivatedModel >> compiledMethodName [

	^ compiledMethodName
]

{ #category : 'printing' }
MethodActivatedModel >> computeDominantType [  
	dominantType := receiverTypes sortedCounts first.
]

{ #category : 'printing' }
MethodActivatedModel >> dominantType [

	^ dominantType
]

{ #category : 'instance creation' }
MethodActivatedModel >> fromRaw: anAssociation [ 
	
	compiledMethodName := anAssociation key printString.
	receiverTypes := anAssociation value collect: [ :e | e className ]
]

{ #category : 'printing' }
MethodActivatedModel >> initialize [ 

	super initialize.
]

{ #category : 'accessing' }
MethodActivatedModel >> numberOfCalls [
	
	^ receiverTypes size
]

{ #category : 'as yet unclassified' }
MethodActivatedModel >> numberOfReceiverClasses [
	
	^ receiverTypes asBag numberOfKeys
]

{ #category : 'printing' }
MethodActivatedModel >> printOn: aStream [
	super printOn: aStream .
	aStream nextPutAll: '(',compiledMethodName , ' ' ,self dominantType  asString  ,')'.
]

{ #category : 'as yet unclassified' }
MethodActivatedModel >> receiverClassesFrequency [
	
	^ receiverTypes asBag valuesAndCounts
]

{ #category : 'as yet unclassified' }
MethodActivatedModel >> receiverTypes [	
	^ receiverTypes asBag
]
