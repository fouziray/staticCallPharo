"
I'm used in rebench, least possible rollbacks and evaluations are done by batch of modification
"
Class {
	#name : 'CopyDownCostRebench',
	#superclass : 'CopyDownCost',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
CopyDownCostRebench class >> traceHGveritas [
	<script>
	
	self forProgram: [ VeritasHoneyGinger new run ].
]

{ #category : 'as yet unclassified' }
CopyDownCostRebench >> canBeCopiedDown: aCollection [

	| actualClass lookedUp lookedUpClass |
	aCollection do: [ :callsite |
		actualClass := OpalCompiler new
			               source: callsite dominantType;
			               evaluate.
		lookedUp := actualClass lookupSelector: callsite selector asSymbol.
		lookedUpClass := lookedUp classBinding value.
		(((actualClass isKindOf: lookedUpClass) and: [
			  actualClass ~= lookedUpClass ]) and: [ self stillUnderLimit ])
			ifTrue: [ self copyDown: lookedUp into: actualClass having: callsite  ] .
			  
			].
		self evaluateProgram
]

{ #category : 'as yet unclassified' }
CopyDownCostRebench >> copyDown: aCollection into: aMetaclass having: callSite [

	(RBMoveMethodToClassTransformation
		 method: aCollection
		 class: aMetaclass) checkPreconditions.
	" once it passes the preconditions usually used in Refactoring (not defined in the subclass"

	aMetaclass compile: aCollection sourceCode.
	insertedMethods add: (InsertedMethod withMethod:(OpalCompiler new
			 source: aMetaclass asString , '>>' , ('#' , aCollection selector);
			 evaluate) associatedTo: callSite ).

]

{ #category : 'copying' }
CopyDownCostRebench >> copyIt [
	"then evaluate and return the result as tupe of <runtime, jitCompilationOverhead>"

	^ self nodesToCopyDown: TracingRawResult defaultInstance
]

{ #category : 'copying' }
CopyDownCostRebench >> copyItUpTo: aNumber [
	"then evaluate and return the result as tupe of <runtime, jitCompilationOverhead>"

	self maxModifications: aNumber.
	programBlock := TracingRawResult defaultInstance programBlock .
	^ self nodesToCopyDown: TracingRawResult defaultInstance traceDict
]

{ #category : 'benchmarking' }
CopyDownCostRebench >> evaluateProgram [

	| window resultMicroSec compilationTimeBefore compilationTimeAfter |
	Smalltalk garbageCollect.
	compilationTimeBefore := Smalltalk vm totalJITCompileTime.

	resultMicroSec := [ window := programBlock value ] microsecondsToRun.
	
	compilationTimeAfter := Smalltalk vm totalJITCompileTime.
	
	[window containingWindow ifNotNil: #close.] onErrorDo: [  ].
	 ^ (CopyDownResult runtimePerformance: resultMicroSec compilationInJitTime: (compilationTimeAfter - compilationTimeBefore) ).
	
]

{ #category : 'as yet unclassified' }
CopyDownCostRebench >> forProgram: aBlock [

	| simulator blockReturn devirtualizableNodes |
	simulator := DevirtualizableCallSites new.
	programBlock := aBlock.
	simulator block: aBlock.
	blockReturn := simulator execute.

	[(blockReturn isKindOf: Morph) ifTrue: [
		blockReturn containingWindow ifNotNil: #close ].
] onErrorDo: [  ].
	devirtualizableNodes := simulator getAllCallSites.
	TracingRawResult from: devirtualizableNodes ofProgram: programBlock .
	
	
]

{ #category : 'filtering' }
CopyDownCostRebench >> nodesToCopyDown: aCollection [

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

	^ canBeCopiedDown
]
