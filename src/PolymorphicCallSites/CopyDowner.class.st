"
This serves as a model to understand:

	 1 - The cost of compilation ( in JIT during execution of a given program )
	 2 - number of calls in a specific Program
	 3 - number of instructions executed
	
	We consider the above parameters to evaluate the efficiency of copy down.
	For different levels of copy down. i.e. by sorting sites to be copied down from most frequently called.
	
I'm used in a pharo Image and give a details on speedup incrementally
"
Class {
	#name : 'CopyDowner',
	#superclass : 'Object',
	#instVars : [
		'insertedMethods',
		'programBlock',
		'maxModifications',
		'sites'
	],
	#category : 'PolymorphicCallSites-CopyDowner',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDowner'
}

{ #category : 'as yet unclassified' }
CopyDowner class >> forProgram: aBlock [
	^ self new forProgram: aBlock 
]

{ #category : 'as yet unclassified' }
CopyDowner class >> forProgram: aBlock modifyUpTo: aNumber [
	^ self new maxModifications: aNumber; forProgram: aBlock 
]

{ #category : 'copying' }
CopyDowner >> copyDown: method into: aClass having: callSite [

	(RBMoveMethodToClassTransformation method: method class: aClass)
		checkPreconditions.
	" once it passes the preconditions usually used in Refactoring (not defined in the subclass"
	insertedMethods add: (InsertedMethod withMethod: method associatedTo: callSite).
	aClass compile: method sourceCode
]

{ #category : 'testing' }
CopyDowner >> copyDownMessages: aCollectionOfSites [

	| mostDominantReceiverClass lookedUp lookedUpClass |
	aCollectionOfSites do: [ :callsite |
		mostDominantReceiverClass := callsite dominantClass.
		lookedUp := self lookupMethodContainingTheSite: callsite.
		lookedUpClass := lookedUp methodClass.
		((self is: mostDominantReceiverClass possibleTargetFor: callsite ) and: [ self stillUnderLimit ])
			ifTrue: [ self copyDown: lookedUp into: mostDominantReceiverClass having: callsite  ] ].
		^ self evaluateProgram 
]

{ #category : 'copying' }
CopyDowner >> copyItUpTo: aNumber [
	"then evaluate and return the result as tupe of <runtime, jitCompilationOverhead>"

	self maxModifications: aNumber.
	programBlock := TracingRawResult defaultInstance programBlock .
	^ self nodesToCopyDown: TracingRawResult defaultInstance traceDict
]

{ #category : 'benchmarking' }
CopyDowner >> evaluateProgram [

	| window resultMicroSec compilationTimeBefore compilationTimeAfter |
	Smalltalk garbageCollect.
	compilationTimeBefore := Smalltalk vm totalJITCompileTime.

	resultMicroSec := [ window := programBlock value ] microsecondsToRun.

	compilationTimeAfter := Smalltalk vm totalJITCompileTime.

	^ (CopyDownResult
		  runtimePerformance: resultMicroSec
		  compilationInJitTime: compilationTimeAfter - compilationTimeBefore)
		  insertedMethodsSize: insertedMethods size
]

{ #category : 'accessing' }
CopyDowner >> forProgram: aBlock [

	| simulator blockReturn devirtualizableNodes result value |
	simulator := DevirtualizableCallSites new.
	programBlock := aBlock.
	simulator block: aBlock.
	blockReturn := simulator execute.
1 halt.
	[(blockReturn isKindOf: Morph) ifTrue: [
		blockReturn containingWindow ifNotNil: #close ].
] onErrorDo: [  ].
	devirtualizableNodes := simulator getAllCallSites.
	result := ProgramModel new
		          name: 'blank'
		          fromRaw: aBlock -> devirtualizableNodes.
	self nodesToCopyDown: devirtualizableNodes.
	self rollbackCopiedMethod.
]

{ #category : 'initialization' }
CopyDowner >> initialize [

	super initialize.
	maxModifications:= 5.
	insertedMethods := OrderedCollection new
]

{ #category : 'accessing' }
CopyDowner >> insertedMethods [

	^ insertedMethods
]

{ #category : 'accessing' }
CopyDowner >> insertedMethods: anObject [

	insertedMethods := anObject
]

{ #category : 'testing' }
CopyDowner >> is: aClass possibleTargetFor: aCallSiteModel [

	^ (self lookupMethodContainingTheSite: aCallSiteModel) methodClass ~= aClass 
		and: [ (aClass includesSelector: aCallSiteModel methodSelector) not ]
]

{ #category : 'lookup' }
CopyDowner >> lookupMethodContainingTheSite: aCallSiteModel [ 
	"This could be delegated to the site"
	
	^ aCallSiteModel dominantClass lookupSelector: aCallSiteModel methodSelector asSymbol.
]

{ #category : 'initialization' }
CopyDowner >> maxModifications [

	^ maxModifications
]

{ #category : 'initialization' }
CopyDowner >> maxModifications: aNumber [

	maxModifications := aNumber
]

{ #category : 'filtering' }
CopyDowner >> nodesToCopyDown: aCollection [

	| result sortedCallsFrequent frequentSelfMessages |
	result := ProgramModel new
		          name: 'black'
		          fromRaw: [ 'aBlock' ] -> aCollection.
	sortedCallsFrequent := (result callSites select: [ :e |
		                        (e dominantTypeWithThreshold: 80) isNotNil ])
		                       sorted: [ :a :b |
		                       a numberOfCalls > b numberOfCalls ].

	frequentSelfMessages:= sortedCallsFrequent select: [ :c |
		                       c isSelfSend and:[ c numberOfReceiverClasses > 1]].

 ^ 	self copyDownMessages: frequentSelfMessages.
	
]

{ #category : 'initialization' }
CopyDowner >> rollbackCopiedMethod [
	"removes copied down methods from the child classes "

	(insertedMethods collect: #method) do: [ :e |
		e methodClass removeSelector: e selector ]
]

{ #category : 'initialization' }
CopyDowner >> sites: aCollectionOfCallSites [ 
	sites := aCollectionOfCallSites
]

{ #category : 'initialization' }
CopyDowner >> stillUnderLimit [

	^ insertedMethods size < maxModifications
]
