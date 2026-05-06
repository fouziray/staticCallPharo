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

{ #category : 'accessing' }
ProgramModel >> callSites: aCol [
	callSites := aCol 
]

{ #category : 'as yet unclassified' }
ProgramModel >> filterOutInlinedMethodsByCompiled [

 callSites := callSites reject:[:site| { #ifTrue:ifFalse: . #ifFalse:ifTrue: .#ifFalse: . #ifTrue:. #ifEmpty. } includes: site selector ].
"haven't yet executed this portion"
]

{ #category : 'instance creation' }
ProgramModel >> fromRaw: anAssociation [ 
	
	blockCode := anAssociation key compiledBlock sourceNode sourceCode.
	callSites := (anAssociation value at: 2) associations reject: [ :e | e key isNil ] thenCollect: [ :e | CallSiteModel fromRaw: e ]
]

{ #category : 'instance creation' }
ProgramModel >> fromTraceMessages: traceAssociatons [
	
	callSites := (traceAssociatons) associations reject: [ :e | e key isNil ] thenCollect: [ :e | CallSiteModel fromRaw: e ]
]

{ #category : 'instance creation' }
ProgramModel >> name: aString fromRaw: anAssociation [ 
	
	programName := aString.
	blockCode := anAssociation key compiledBlock sourceNode sourceCode.
	callSites := (anAssociation value) associations reject: [ :e | e key isNil ] thenCollect: [ :e | CallSiteModel fromRaw: e ]
]

{ #category : 'instance creation' }
ProgramModel >> name: aName fromTraceMessages: traceAssociatons [
	programName := aName.
	callSites := (traceAssociatons) associations reject: [ :e | e key isNil ] thenCollect: [ :e | CallSiteModel fromRaw: e ]
]

{ #category : 'accessing' }
ProgramModel >> numberOfCalls [
	
	^ callSites sum: [ :cs | cs numberOfCalls ]
]

{ #category : 'printing' }
ProgramModel >> printOn: aStream [

	super printOn: aStream.
	aStream nextPutAll: ' ', self programName, ' sites: '.
	aStream print: self callSites size. 
	aStream nextPutAll: ' calls: '.
	aStream print: self numberOfCalls.
	
	
]

{ #category : 'accessing' }
ProgramModel >> programName [
	^ programName
]

{ #category : 'as yet unclassified' }
ProgramModel >> serializeModel [

	(self programName asFileReference withExtension: 'ston')
		writeStreamDo: [:s | STON put: self onStream: s].
	
]
