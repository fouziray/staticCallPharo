Class {
	#name : 'MethodActivatedModel',
	#superclass : 'Object',
	#instVars : [
		'compiledMethodName',
		'receiverTypes'
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

{ #category : 'instance creation' }
MethodActivatedModel >> fromRaw: anAssociation [ 
	
	compiledMethodName := anAssociation key printString.
	receiverTypes := anAssociation value collect: [ :e | e className ]
]

{ #category : 'accessing' }
MethodActivatedModel >> numberOfCalls [
	
	^ receiverTypes size
]

{ #category : 'as yet unclassified' }
MethodActivatedModel >> numberOfReceiverClasses [
	
	^ receiverTypes asBag valuesAndCounts size
]

{ #category : 'as yet unclassified' }
MethodActivatedModel >> receiverClassesFrequency [
	
	^ receiverTypes asBag valuesAndCounts
]

{ #category : 'as yet unclassified' }
MethodActivatedModel >> receiverTypes [	
	^ receiverTypes asBag
]
