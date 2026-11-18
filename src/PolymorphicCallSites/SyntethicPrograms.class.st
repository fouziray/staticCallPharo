Class {
	#name : 'SyntethicPrograms',
	#superclass : 'Object',
	#instVars : [
		'types',
		'repetitionRate',
		'sizeOfProcessedData'
	],
	#category : 'PolymorphicCallSites-Synth-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Synth-Objects'
}

{ #category : 'as yet unclassified' }
SyntethicPrograms class >> launchTrace [

	<script>
	| tracer |
	tracer := PatternCallSites.
	tracer initialize.

	tracer trace: [ self main ] outputFileSuffix: 'synthProgram'.


]

{ #category : 'as yet unclassified' }
SyntethicPrograms class >> launchTraceForBlockOnly [

	<script>
	| tracer |
	tracer := PatternCallSites.
	tracer initialize.

	tracer trace: [ self mainBlock ] outputFileSuffix: 'synthProgramBLock'.


]

{ #category : 'accessing' }
SyntethicPrograms class >> main [

	<script>
	^ self new main
]

{ #category : 'accessing' }
SyntethicPrograms class >> mainBlock [

	<script>
	^ self new mainBlock
]

{ #category : 'initialization' }
SyntethicPrograms class >> setPIC [

	<script>
	PatternCallSites setPicsOn: 'trace-synthProgram'
]

{ #category : 'initialization' }
SyntethicPrograms class >> setPICBlock [

	<script>
	PatternCallSites setPicsOn: 'trace-synthProgramBLock'
]

{ #category : 'initialization' }
SyntethicPrograms class >> setPicsOnHoneyGingerWatershowDots [

	<script>
	PatternCallSites setPicsFor: 'trace-synthProgram'
]

{ #category : 'as yet unclassified' }
SyntethicPrograms >> callOperation: anObject [

	anObject operation 
]

{ #category : 'accessing' }
SyntethicPrograms >> callOperationFor: inputArray [

	inputArray withIndexDo: [ :index  :each |
			each timesRepeat: [ (types at: index) perform: #operation 
 ].
				 ]
]

{ #category : 'accessing' }
SyntethicPrograms >> callOperations [
	types := types collect:[:t | t new].
	types do:[:each | 
		repetitionRate timesRepeat: [ each operation ] ]
]

{ #category : 'as yet unclassified' }
SyntethicPrograms >> callYourself: anObject [

	anObject yourself
]

{ #category : 'as yet unclassified' }
SyntethicPrograms >> callYourselfBlock: anObject [

	[ anObject yourself ] value
]

{ #category : 'as yet unclassified' }
SyntethicPrograms >> callYourselfBlockBlock: anObject [

	[ [ anObject yourself ] ] value
]

{ #category : 'accessing' }
SyntethicPrograms >> createReceiverPatternOf: sizeOfProcessedData [
	types := ((1 to: sizeOfProcessedData) collect:[ :e |  PMReceiver allSubclasses ]) flattened.
]

{ #category : 'as yet unclassified' }
SyntethicPrograms >> initialize [
	
	repetitionRate := 200.
	sizeOfProcessedData := 100.
	self createReceiverPatternOf: sizeOfProcessedData.
	types := types collect:[ :t | t new ].

]

{ #category : 'accessing' }
SyntethicPrograms >> main [
	"Let's create a program with a long profound loop"

	"run with:
		self new main
	"

	| sizeOfProcessedData |
	sizeOfProcessedData := 500.
	self createReceiverPatternOf: sizeOfProcessedData.
	self callOperations
]

{ #category : 'accessing' }
SyntethicPrograms >> mainBlock [
	"Let's create a program with a long profound loop"

	"run with:
		self new mainBlock
	"
	types do:[:each |  each operation ]
]

{ #category : 'as yet unclassified' }
SyntethicPrograms >> repetitionRate [

	^ repetitionRate
]

{ #category : 'as yet unclassified' }
SyntethicPrograms >> repetitionRate: aNumber [

	repetitionRate := aNumber
]
