Class {
	#name : 'ResultModel',
	#superclass : 'Object',
	#instVars : [
		'programs'
	],
	#category : 'PolymorphicCallSites-Model',
	#package : 'PolymorphicCallSites',
	#tag : 'Model'
}

{ #category : 'instance creation' }
ResultModel class >> from: aCollection [ 
	
	^ self new
		fromRaw: aCollection;
		yourself
]

{ #category : 'instance creation' }
ResultModel >> fromRaw: aCollection [ 
	
	programs := aCollection collect: [ :e |  ProgramModel fromRaw: e ]
]

{ #category : 'accessing' }
ResultModel >> programs [
	^ programs
]

{ #category : 'accessing' }
ResultModel >> programs: aCollection [ 
	programs := aCollection
]
