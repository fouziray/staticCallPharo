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
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
CopyDownCost class >> forProgram: aBlock [
	^ self new forProgram: aBlock 
]

{ #category : 'testing' }
CopyDownCost >> canBeCopiedDown: aCollection [ 
| actualClass lookedUp lookedUpClass |

	actualClass := OpalCompiler evaluate:  aCollection first dominantType.
	lookedUp := (actualClass lookupSelector: aCollection first selector asSymbol) .
	lookedUpClass := lookedUp classBinding value.
	  ((actualClass isKindOf: lookedUpClass)  and:[ actualClass ~= lookedUpClass]) ifTrue:[
		self copyDown: lookedUp into: actualClass. 
		].
]

{ #category : 'copying' }
CopyDownCost >> copyDown: aCollection into: aMetaclass [ 
	self shouldBeImplemented.
]

{ #category : 'as yet unclassified' }
CopyDownCost >> forProgram: aBlock [

	| simulator blockReturn devirtualizableNodes result value |
	simulator := DevirtualizableCallSites new.
	simulator block: aBlock.
	blockReturn := simulator execute.

	(blockReturn isKindOf: Morph) ifTrue: [
		blockReturn containingWindow ifNotNil: #close ].

	devirtualizableNodes := simulator getAllCallSites.
	result := ProgramModel new
		          name: 'blank'
		          fromRaw: aBlock -> devirtualizableNodes.
	self nodesToCopyDown: devirtualizableNodes .
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

	sortedCallsFrequent:= (result callSites select: [ :e |
		(e dominantTypeWithThreshold: 80) isNotNil ]) sorted: [ :a :b | a numberOfCalls > b numberOfCalls ].

	frequentSelfMessage:= sortedCallsFrequent select:[:c | c isSelfSend  ].
	frequentVariableMessage := sortedCallsFrequent select: [ :e | e isSelfSend not ].
		
	canBeCopiedDown := self canBeCopiedDown: frequentSelfMessage.
			1 halt.
]
