"
This serves as a model to understand:

	 1 - The cost of compilation ( in JIT during execution of a given program )
	 2 - number of calls in a specific Program
	 3 - number of instructions executed
	
	We consider the above parameters to evaluate the efficiency of copy down.
	For different levels of copy down. i.e. by sorting sites to be copied down from most frequently called.
	
"
Class {
	#name : 'CopyDownCost',
	#superclass : 'Object',
	#instVars : [
		'insertedMethods',
		'programBlock',
		'maxModifications'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
CopyDownCost class >> forProgram: aBlock [
	^ self new forProgram: aBlock 
]

{ #category : 'as yet unclassified' }
CopyDownCost class >> forProgram: aBlock modifyUpTo: aNumber [
	^ self new maxModifications: aNumber; forProgram: aBlock 
]

{ #category : 'testing' }
CopyDownCost >> canBeCopiedDown: aCollection [

	| actualClass lookedUp lookedUpClass |
	aCollection do: [ :callsite |
		actualClass := OpalCompiler new
			               source: callsite dominantType;
			               evaluate.
		lookedUp := actualClass lookupSelector: callsite selector asSymbol.
		lookedUpClass := lookedUp classBinding value.
		(((actualClass isKindOf: lookedUpClass) and: [
			  actualClass ~= lookedUpClass ]) and: [ self stillUnderLimit ])
			ifTrue: [ self copyDown: lookedUp into: actualClass having: callsite  ] ]
]

{ #category : 'copying' }
CopyDownCost >> copyDown: aCollection into: aMetaclass [


	(RBMoveMethodToClassTransformation
		 method: aCollection
		 class: aMetaclass) checkPreconditions.
	" once it passes the preconditions usually used in Refactoring (not defined in the subclass"
	
	aMetaclass compile: aCollection sourceCode.
	insertedMethods add: (OpalCompiler new
			 source: aMetaclass asString , '>>' , ('#' , aCollection selector);
			 evaluate).
	self evaluateProgram
]

{ #category : 'copying' }
CopyDownCost >> copyDown: aCollection into: aMetaclass having: callSite [

	(RBMoveMethodToClassTransformation
		 method: aCollection
		 class: aMetaclass) checkPreconditions.
	" once it passes the preconditions usually used in Refactoring (not defined in the subclass"

	aMetaclass compile: aCollection sourceCode.
	insertedMethods add: (InsertedMethod withMethod:(OpalCompiler new
			 source: aMetaclass asString , '>>' , ('#' , aCollection selector);
			 evaluate) associatedTo: callSite ).
	self evaluateProgram
]

{ #category : 'benchmarking' }
CopyDownCost >> evaluateProgram [

	| window resultMicroSec compilationTimeBefore compilationTimeAfter |
	Smalltalk garbageCollect.
	compilationTimeBefore := Smalltalk vm totalJITCompileTime.
		
	resultMicroSec := [ window := programBlock value ] microsecondsToRun.
	
	compilationTimeAfter := Smalltalk vm totalJITCompileTime.
	
	Transcript
		show:
			programBlock asString , ' , MicroSeconds: '
			, resultMicroSec asString , ' NumberOfChanges: '
			, insertedMethods size asString;
		cr.
	insertedMethods last compilationVsPerformance: (CopyDownResult runtimePerformance: resultMicroSec compilationInJitTime: (compilationTimeAfter - compilationTimeBefore) ).
	window containingWindow ifNotNil: #close
]

{ #category : 'as yet unclassified' }
CopyDownCost >> forProgram: aBlock [

	| simulator blockReturn devirtualizableNodes result value |
	simulator := DevirtualizableCallSites new.
	programBlock := aBlock.
	simulator block: aBlock.
	blockReturn := simulator execute.

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

{ #category : 'as yet unclassified' }
CopyDownCost >> initialize [

	super initialize.
	maxModifications:= 5.
	insertedMethods := OrderedCollection new
]

{ #category : 'accessing' }
CopyDownCost >> insertedMethods [

	^ insertedMethods
]

{ #category : 'accessing' }
CopyDownCost >> insertedMethods: anObject [

	insertedMethods := anObject
]

{ #category : 'as yet unclassified' }
CopyDownCost >> maxModifications [

	^ maxModifications
]

{ #category : 'as yet unclassified' }
CopyDownCost >> maxModifications: aNumber [

	maxModifications := aNumber
]

{ #category : 'filtering' }
CopyDownCost >> nodesToCopyDown: aCollection [

	| result sortedCallsFrequent frequentSelfMessage frequentVariableMessage canBeCopiedDown |
	result := ProgramModel new
		          name: 'black'
		          fromRaw: [ 'aBlock' ] -> aCollection.
	result callSites
		collect: [ :e | e dominantTypeWithThreshold: 80 ]
		thenReject: #isNil.

	sortedCallsFrequent := (result callSites select: [ :e |
		                        (e dominantTypeWithThreshold: 80) isNotNil ])
		                       sorted: [ :a :b |
		                       a numberOfCalls > b numberOfCalls ].

	frequentSelfMessage := sortedCallsFrequent select: [ :c |
		                       c isSelfSend ].
	frequentVariableMessage := sortedCallsFrequent select: [ :e |
		                           e isSelfSend not ].

	canBeCopiedDown := self canBeCopiedDown: frequentSelfMessage.

	self rollbackCopiedMethod.
]

{ #category : 'as yet unclassified' }
CopyDownCost >> rollbackCopiedMethod [
	"removes copied down methods from the child classes "

	(insertedMethods collect:#method) do: [ :e |
		e classBinding value removeSelector: e selector ]
]

{ #category : 'as yet unclassified' }
CopyDownCost >> stillUnderLimit [

	^ insertedMethods size < maxModifications
]
