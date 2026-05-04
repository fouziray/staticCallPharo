Class {
	#name : 'InlineCacheCharacteristicsTests',
	#superclass : 'TestCase',
	#instVars : [
		'transformer',
		'visitorClass'
	],
	#category : 'PolymorphicCallSites-Tests',
	#package : 'PolymorphicCallSites',
	#tag : 'Tests'
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
	| traceRecordTree fullMessageList programModel resultModel disparitiesAssociation |

	traceRecordTree := ScpExecutionRecorder
		                   recordBlock: [ self threeTypes  ]
		                   as: ScpExecutionRecordTree.

	fullMessageList := self visitRecord: traceRecordTree.
programModel:= 	ProgramModel new fromTraceMessages: fullMessageList.
resultModel := ProgramResult for: programModel.
disparitiesAssociation:= (resultModel disparities ).
self assert: disparitiesAssociation first value equals: 1/4.
self assert:( disparitiesAssociation select:[:e | resultModel isSpurious: e key] ) size equals: disparitiesAssociation size.	
]

{ #category : 'as yet unclassified' }
InlineCacheCharacteristicsTests >> threeTypes [
	{ Object new. 3. 4.0. 'ss' } do: [:each | each class ]
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
