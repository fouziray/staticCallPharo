Class {
	#name : 'TracingRawResult',
	#superclass : 'Object',
	#instVars : [
		'nodesAndTypes',
		'programBlock'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
TracingRawResult class >> defaultInstance [

 ^uniqueInstance 
]

{ #category : 'instance creation' }
TracingRawResult class >> from: aCollection [

	uniqueInstance
		ifNil: [ uniqueInstance := self new with: aCollection ]
		ifNotNil: [ uniqueInstance with: aCollection ].
	^ uniqueInstance
]

{ #category : 'instance creation' }
TracingRawResult class >> from: aCollection ofProgram: aProgramBlock [

	^ (self from: aCollection ) programBlock: aProgramBlock .
]

{ #category : 'accessing' }
TracingRawResult >> programBlock [

	^ programBlock
]

{ #category : 'accessing' }
TracingRawResult >> programBlock: aProgramBlock [

	programBlock := aProgramBlock .
]

{ #category : 'instance creation' }
TracingRawResult >> traceDict [ 
	^ nodesAndTypes 
]

{ #category : 'instance creation' }
TracingRawResult >> with: aCollection [

	nodesAndTypes := aCollection
]
