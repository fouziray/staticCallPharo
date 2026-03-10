Class {
	#name : 'ProgramModel',
	#superclass : 'Object',
	#instVars : [
		'blockCode',
		'callSites',
		'programName'
	],
	#category : 'PolymorphicCallSites-Model',
	#package : 'PolymorphicCallSites',
	#tag : 'Model'
}

{ #category : 'accessing' }
ProgramModel >> blockCode [
	^ blockCode
]

{ #category : 'accessing' }
ProgramModel >> callSites [
	^ callSites
]

{ #category : 'instance creation' }
ProgramModel >> fromRaw: anAssociation [ 
	
	blockCode := anAssociation key compiledBlock sourceNode sourceCode.
	callSites := (anAssociation value at: 2) associations reject: [ :e | e key isNil ] thenCollect: [ :e | CallSiteModel fromRaw: e ]
]

{ #category : 'instance creation' }
ProgramModel >> name: aString fromRaw: anAssociation [ 
	
	programName := aString.
	blockCode := anAssociation key compiledBlock sourceNode sourceCode.
	callSites := (anAssociation value) associations reject: [ :e | e key isNil ] thenCollect: [ :e | CallSiteModel fromRaw: e ]
]

{ #category : 'accessing' }
ProgramModel >> programName [
	^ programName
]
