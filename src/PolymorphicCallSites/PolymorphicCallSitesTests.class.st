Class {
	#name : 'PolymorphicCallSitesTests',
	#superclass : 'TestCase',
	#instVars : [
		'transformer'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'deserializing' }
PolymorphicCallSitesTests class >> getMessageFromIndex: aString [

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

{ #category : 'deserializing' }
PolymorphicCallSitesTests class >> reviveClassesMethodMessages: aCollection [

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

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> methodWithPolymorphicCallSiteNonDevirtualizable [

	{
		Object new.
		3.
		4.0 } do: [ :each | each defaultLabel ]
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> methodWithPolymorphicCallSites [

	{ Object new. 3. 4.0 } do: [:each | each class ]
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> recoverVeritasCSVDataInto [
	| object |
	object := 'mydata.ston' asFileReference readStreamDo: [ :stream |
    STON fromStream: stream ].

	self reviveClassesMethodMessages: object.
]

{ #category : 'running' }
PolymorphicCallSitesTests >> tearDown [

	transformer ifNotNil:[:e | e rollbackBackedUpAst]
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testFalsePolymorphicIsMonoMorphic [

| traceRecordTree targetMethodsDict targetMethodAssociationWithTypes |	
traceRecordTree := ScpExecutionRecorder recordBlock: [ 

	self methodWithPolymorphicCallSites
  
] as: ScpExecutionRecordTree.

targetMethodsDict := self visitRecord: traceRecordTree.
targetMethodAssociationWithTypes :=(targetMethodsDict at: (self class >> #methodWithPolymorphicCallSites) ast sendNodes last ) associations first.

self assert: (targetMethodsDict associations select: [ :messageTargetAndReceiver | messageTargetAndReceiver value keys size = 1    ]) equals: targetMethodsDict associations .
self assert: targetMethodAssociationWithTypes value size equals: 3.

self assert:  targetMethodAssociationWithTypes key equals: ProtoObject >> #class
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testFalsePolymorphicIsMonoMorphicFiltering [

	| traceRecordTree targetMethodsDict targetMethodAssociationWithTypes |
	traceRecordTree := ScpExecutionRecorder
		                   recordBlock: [
		                   self methodWithPolymorphicCallSites ]
		                   as: ScpExecutionRecordTree.

	targetMethodsDict := self visitRecord: traceRecordTree.
	targetMethodAssociationWithTypes := (targetMethodsDict at:
		                                     (self class
		                                      >>
		                                      #methodWithPolymorphicCallSites)
			                                     ast sendNodes last)
		                                    associations first.
	self
		assert: (self visitorClass filterFakePoly: targetMethodsDict) first
		equals: targetMethodsDict associations last.

	self assert: targetMethodAssociationWithTypes value size equals: 3.

	self
		assert: targetMethodAssociationWithTypes key
		equals: ProtoObject >> #class
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testFilteringDevirutalisableSites [

	| traceRecordTree targetMethodsDict document devirtualisable |
	document := MicrodownWithStaticCallBenchmarkSuite new
		            createSmallDocument.
	traceRecordTree := ScpExecutionRecorder
		                   recordBlock: [ MicrodownParser parse: document ]
		                   as: ScpExecutionRecordTree.

	targetMethodsDict := self visitRecord: traceRecordTree.

	devirtualisable := self visitorClass filterFakePoly:
		                   targetMethodsDict.

	self assert: devirtualisable size equals: 38.
	self assert: devirtualisable first value asArray first size > 1
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testMooseDevirtualize [

	|   devirtualizableNodes   |
	
	devirtualizableNodes := MOO.

	transformer := StaticCallSiteTransformer new
		               recordedTypes: devirtualizableNodes asDictionary;
		               yourself.
	transformer	getNewMethodOfDevirtualizingAll.
		RollbackImageStaticBytecodes action: [ transformer rollbackBackedUpAst ].
	1halt.
	
	"devirtualizableNodes  do:[ :each | (each isMessage and:[ each receiver isMessage not ]) ifTrue:[self remove: each. self add: each. ] ].
	"

	transformer rollbackBackedUpAst.
	
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testMooseIsDevirtualized [

	|   devirtualizableNodes   |
	
	devirtualizableNodes := MOO.
	self assert: (((MOO collect:#key ) collect:#methodNode) select: #hasStaticCall ) size > 0 .
	
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testMooseIsRevirtualized [

	|   devirtualizableNodes   |
	RollbackImageStaticBytecodes default rollbackAction.
	devirtualizableNodes := MOO.
	RollbackImageStaticBytecodes default rollbackAst: (((MOO collect:#key ) collect:#methodNode) select: #hasStaticCall ).
	
	
	RollbackImageStaticBytecodes default replaceSMsgWithNormal.
	self assert: (((MOO collect:#key ) collect:#methodNode) select: #hasStaticCall ) size = 0 .
	
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testRefactorFakePoly [

	| document traceRecordTree devirtualizableNodes candidate method newMethod transformer fullMessageList simulator optTime baselinetime baselinetime2 optTime2 |
	document := MicrodownWithStaticCallBenchmarkSuite new
		            createSmallDocument.
		
	baselinetime := [ Microdown parse: document ] timeToRun .
	baselinetime2 := [ Microdown parse: document ] timeToRun .
	simulator := DevirtualizableCallSites new.
	simulator block: [ Microdown parse: document ].
	simulator execute.		

	devirtualizableNodes := simulator getAllCallSites.
1 halt.
	transformer := StaticCallSiteTransformer new
		               recordedTypes: devirtualizableNodes asDictionary;
		               yourself.
	transformer	getNewMethodOfDevirtualizingAll.
	1halt.
		optTime:= [ Microdown parse: document ] timeToRun .
		optTime2:= [ Microdown parse: document ] timeToRun .
	"devirtualizableNodes  do:[ :each | (each isMessage and:[ each receiver isMessage not ]) ifTrue:[self remove: each. self add: each. ] ].
	"


	transformer rollbackBackedUpAst.
	
	{baselinetime. baselinetime2. optTime . optTime2 } inspect.
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testRefactorFakePolyInCormas [

	| devirtualizableNodes |
	devirtualizableNodes := STORECormasFakePoly.
	
	transformer := StaticCallSiteTransformer new
		               recordedTypes:(( devirtualizableNodes associations select: [:e | e key ifNotNil:[ e key methodNode compiledMethod classBinding value package name beginsWithAnyOf:{ 'Kernel' }] ifNil:[ false ] ] ) asDictionary );
		               yourself.	

	transformer	getNewMethodOfDevirtualizingAll.
	1halt.
	
	"devirtualizableNodes  do:[ :each | (each isMessage and:[ each receiver isMessage not ]) ifTrue:[self remove: each. self add: each. ] ].
	"


	transformer rollbackBackedUpAst.
	
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testRefactorFakePolyInTrivialCase [

	| devirtualizableNodes |
	devirtualizableNodes := STORECormasFakePoly.
	
	transformer := StaticCallSiteTransformer new
		               recordedTypes:(( devirtualizableNodes associations select: [:e | e key ifNotNil:[ e key methodNode compiledMethod classBinding value package name beginsWithAnyOf:{ 'Kernel' }] ifNil:[ false ] ] ) asDictionary );
		               yourself.	

	transformer	getNewMethodOfDevirtualizingAll.
	1halt.
	
	"devirtualizableNodes  do:[ :each | (each isMessage and:[ each receiver isMessage not ]) ifTrue:[self remove: each. self add: each. ] ].
	"


	transformer rollbackBackedUpAst.
	
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testRefactorFakePolyInTrivialCase1 [

	| devirtualizableNodes |
	devirtualizableNodes := TRIVIALCase1.
	
	transformer := StaticCallSiteTransformer new
		               recordedTypes: devirtualizableNodes asDictionary ;
		               yourself.	

	transformer	getNewMethodOfDevirtualizingAll.
	1halt.
	
	"devirtualizableNodes  do:[ :each | (each isMessage and:[ each receiver isMessage not ]) ifTrue:[self remove: each. self add: each. ] ].
	"


	transformer rollbackBackedUpAst.
	
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testRefactorFakePolyInVeritas [

	| devirtualizableNodes |
	devirtualizableNodes := DEVIRT_VERITAS1.
	
	transformer := StaticCallSiteTransformer new
		               recordedTypes: (devirtualizableNodes select: [:e | e key methodNode compiledMethod classBinding value package name beginsWithAnyOf:{ 'DataFrame'. 'Neo' }]) asDictionary;
		               yourself.	
	1 halt.
	transformer	getNewMethodOfDevirtualizingAll.
	1halt.
	
	"devirtualizableNodes  do:[ :each | (each isMessage and:[ each receiver isMessage not ]) ifTrue:[self remove: each. self add: each. ] ].
	"


	transformer rollbackBackedUpAst.
	
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testRefactorFakePolyWithBench [

	| document traceRecordTree devirtualizableNodes candidate method newMethod transformer fullMessageList unopt opt |
	document := MicrodownWithStaticCallBenchmarkSuite new
		            createSmallDocument.
	

	traceRecordTree := ScpExecutionRecorder
		                   recordBlock: [ MicrodownParser parse: document ]
		                   as: ScpExecutionRecordTree.


	devirtualizableNodes := PolymorphicCallSitesVisitor filterFakePoly:
		                        (fullMessageList := PolymorphicCallSitesVisitor
			                                            new
			                                            visitExecutionRecord:
				                                            traceRecordTree;
			
				                                            messageExecutionsDictionary).
	transformer := StaticCallSiteTransformer new
		               recordedTypes: fullMessageList asDictionary;
		               yourself.
	devirtualizableNodes := devirtualizableNodes asOrderedCollection.
	devirtualizableNodes do: [ :each |
		(each key isMessage and: [ each key receiver isMessage not ])
			ifTrue: [
				devirtualizableNodes remove: each.
				devirtualizableNodes add: each ] ].
	devirtualizableNodes do: [ :each |
		each value keys first.

		transformer message: each key.
		candidate := StaticCallCandidate
			             method: each value keys first
			             callSite: each key
			             selector: each key methodNode selector
			             receiver:
			             each value values first asOrderedCollection first
			             receiverType:
			             (each key receiver acceptVisitor: transformer).



		newMethod := transformer getNewMethodOfDevirtualizing: candidate .
].
	opt := [ MicrodownParser parse: document ] timeToRun.
	{	unopt.
		opt } inspect.
	transformer rollbackBackedUpAst
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testRefactorTwoNestedCallsInOneMessage [

	| document traceRecordTree devirtualizableNodes candidate method newMethod transformer fullMessageList |
	traceRecordTree := ScpExecutionRecorder
		                   recordBlock: [ self twoCalls ]
		                   as: ScpExecutionRecordTree.


	devirtualizableNodes := PolymorphicCallSitesVisitor filterFakePoly:
		                        (fullMessageList := PolymorphicCallSitesVisitor
			                                            new
			                                            visitExecutionRecord:
				                                            traceRecordTree;
			
				                                            messageExecutionsDictionary).
	
	transformer := StaticCallSiteTransformer new
		               recordedTypes: fullMessageList asDictionary;
		               yourself.
	devirtualizableNodes do: [ :each |
		each value keys first.

		transformer message: each key.
		candidate := StaticCallCandidate
			             method: each value keys first
			             callSite: each key
			             selector: each key methodNode selector
			             receiver:
			             each value values first asOrderedCollection first
			             receiverType:
			             (each key receiver acceptVisitor: transformer).

		newMethod := transformer getNewMethodOfDevirtualizing: candidate ].
	transformer rollbackBackedUpAst
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> testRefactorVeritasHoneyGinger [

	| devirtualizableNodes |
	devirtualizableNodes := STORE2.
	
	transformer := StaticCallSiteTransformer new
		               recordedTypes: devirtualizableNodes ;
		               yourself.	
	1 halt.
	transformer	getNewMethodOfDevirtualizingAll.
	1halt.
	
	"devirtualizableNodes  do:[ :each | (each isMessage and:[ each receiver isMessage not ]) ifTrue:[self remove: each. self add: each. ] ].
	"


	transformer rollbackBackedUpAst.
	
]

{ #category : 'tests' }
PolymorphicCallSitesTests >> testTruePolymorphic [

| traceRecordTree targetMethodsDict targetMethodAssociationWithTypes |	
traceRecordTree := ScpExecutionRecorder recordBlock: [ 

	self methodWithPolymorphicCallSiteNonDevirtualizable
  
] as: ScpExecutionRecordTree.

targetMethodsDict := self visitRecord: traceRecordTree.
targetMethodAssociationWithTypes :=(targetMethodsDict at: (self class >> #methodWithPolymorphicCallSiteNonDevirtualizable ) ast sendNodes last ) associations first.

self assert: (targetMethodsDict associations select: [ :messageTargetAndReceiver | messageTargetAndReceiver value keys size = 1   ]) size equals: targetMethodsDict size - 1 .
self assert: targetMethodAssociationWithTypes value size equals: 2.

self assert:  targetMethodAssociationWithTypes key equals: Number>>#defaultLabel.

targetMethodAssociationWithTypes :=(targetMethodsDict at: (self class >> #methodWithPolymorphicCallSiteNonDevirtualizable ) ast sendNodes last ) associations last.

self assert: targetMethodAssociationWithTypes value size equals: 1.

self assert:  targetMethodAssociationWithTypes key equals: Object>>#defaultLabel.
]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> trivialCase1 [

	{Object new. String new. Class . OrderedCollection newFrom: { 2. 3 . 5.3 } . 'sasaa'}  collect:[ :e | e printString ]


]

{ #category : 'veritas' }
PolymorphicCallSitesTests >> trivialCase2 [

	{Object new. String new. Class . 3 . 2.34 . 'sasaa'}  collect:[ :e | e class ]


]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> twoCalls [

	Object new class
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> visitRecord: aSCPRecord [

	^ self visitorClass new
		  visitExecutionRecord: aSCPRecord;
		  messageExecutionsDictionary
]

{ #category : 'as yet unclassified' }
PolymorphicCallSitesTests >> visitorClass [
	^ PolymorphicCallSitesVisitor 
]
