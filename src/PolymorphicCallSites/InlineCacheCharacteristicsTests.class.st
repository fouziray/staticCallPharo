Class {
	#name : 'InlineCacheCharacteristicsTests',
	#superclass : 'TestCase',
	#instVars : [
		'transformer',
		'visitorClass'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'deserializing' }
InlineCacheCharacteristicsTests class >> getMessageFromIndex: aString [

	| parts class method index |
	parts := aString splitOn: '/'.
	class := parts first asClassVariable.
	method := (OpalCompiler new
		           source: parts first;
		           evaluate)  lookupSelector: parts second asSymbol.
	method ifNil: [ ^ 'nil' ].
	index := parts third.
	^ method ast sendNodes at: index asInteger
]

{ #category : 'as yet unclassified' }
InlineCacheCharacteristicsTests class >> getRateOfDevirtualizableInDifferentPrograms [
|result  devirtualizableNodes simulator  program |
	
	result := OrderedCollection new.
	program := {[  RSAlpharoExample new example01Basic  ].
[  RSKiviatExample new example01Basic   ].
[  RSLegendExamples new example01Basic   ].
[  RSPieExamples new example01Basic   ]
}.
program do:[:pro | 
	simulator := DevirtualizableCallSites new.
	simulator block: pro.
	simulator execute.		

	devirtualizableNodes := simulator getAllCallSites.
	result add: (PolymorphicCallSitesVisitor rateOfDevirtualizable: devirtualizableNodes) asFloat .
	].

	self assert: (PolymorphicCallSitesVisitor rateOfDevirtualizable: devirtualizableNodes) asFloat rounded equals: 9
	
]

{ #category : 'deserializing' }
InlineCacheCharacteristicsTests class >> reviveClassesMethodMessages: aCollection [

	^ aCollection collect: [ :e |
		  e key
			  ifNotNil: [
				  (self getMessageFromIndex: e key) -> (IdentityDictionary
					   newFromKeys: (e value keys collect: [ :methodPathString |
							    ((methodPathString splitOn: '/') first
								     asClassInEnvironment: self class environment)
								    lookupSelector:
								    (methodPathString splitOn: '/') second asSymbol ])
					   andValues: (e value values collect: [ :v |
							    Bag newFrom:
								    (v collect: [ :className |
									     OpalCompiler evaluate: className ]) ])) ]
			  ifNil: [ nil ] ]
]

{ #category : 'running' }
InlineCacheCharacteristicsTests >> setUp [ 
	visitorClass := PolymorphicCallSitesVisitor  new.
]

{ #category : 'running' }
InlineCacheCharacteristicsTests >> tearDown [

	transformer ifNotNil:[ :e | e rollbackBackedUpAst ]
]

{ #category : 'tests' }
InlineCacheCharacteristicsTests >> testInlineCacheContent [
	| document traceRecordTree devirtualizableNodes candidate method newMethod transformer fullMessageList unopt opt vis |

	traceRecordTree := ScpExecutionRecorder
		                   recordBlock: [ FixtureEscapeAnalysis new plus  ]
		                   as: ScpExecutionRecordTree.


	fullMessageList := self visitRecord:
				                                            traceRecordTree.
	1 halt.
]

{ #category : 'as yet unclassified' }
InlineCacheCharacteristicsTests >> twoCalls [

	Object new class
]

{ #category : 'as yet unclassified' }
InlineCacheCharacteristicsTests >> visitRecord: aSCPRecord [

	^ self visitorClass
		  visitExecutionRecord: aSCPRecord;
		  messageExecutionsDictionary
]

{ #category : 'as yet unclassified' }
InlineCacheCharacteristicsTests >> visitorClass [
	^ visitorClass
]
