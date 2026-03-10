Class {
	#name : 'ResultAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'programs'
	],
	#category : 'PolymorphicCallSites-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Objects'
}

{ #category : 'testing' }
ResultAnalyzer class >> analyze: aCollection [ 
	
	^ self new 
		analyze: aCollection;
		yourself
]

{ #category : 'testing' }
ResultAnalyzer >> analyze: aResultModel [

  programs := aResultModel programs collect: [ :e | ProgramResult for: e ]
]
