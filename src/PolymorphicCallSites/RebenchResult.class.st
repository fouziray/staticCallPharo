Class {
	#name : 'RebenchResult',
	#superclass : 'Object',
	#instVars : [
		'result'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'printing' }
RebenchResult >> printOn: aStream [

	aStream nextPutAll: result
]

{ #category : 'accessing' }
RebenchResult >> result [

	^ result
]

{ #category : 'accessing' }
RebenchResult >> result: anObject [

	result := anObject
]
