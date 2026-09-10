Class {
	#name : 'PatternCallSites',
	#superclass : 'DevirtualizableCallSites',
	#instVars : [
		'typePatterns',
		'messageDepthDictionary',
		'depth',
		'arrowsToParentMessages',
		'previousNode',
		'finished'
	],
	#classInstVars : [
		'tracePatternsDir',
		'visualClass'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
PatternCallSites class >> deserializeButterBallAtDie [	
	<script>

	^  self deserializeStonFor: tracePatternsDir / 'butterBallAtDie.ston' 
	
	
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> deserializeStonFor: aFileReference [

	^ aFileReference readStreamDo: [ :stream | STON fromStream: stream ]
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> deserializeTracePatternsForFile: aFileNameString [	

	^  self deserializeStonFor: (tracePatternsDir asFileReference / aFileNameString 
	)
	
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> deserializeTracePatternsHg [	
	<script>

	^  self deserializeStonFor: tracePatternsDir / 'waterMap.ston' 
	
	
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> deserializeTracePatternsHgWithDepth [	
	<script>

	^  self deserializeStonFor: tracePatternsDir / 'hgWaterDepth.ston' 
	
	
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> firstTypeSwitchAnalysis [
	"this gives  how many calls before a new type pops up X number of call sites "
	<script>

	| program callSitesPartitions patternsVisualizer ordered plot plot2 callsites |
	patternsVisualizer := PicPatternVisual new.
	program :=  self deserializeTracePatternsForFile: 'hgWater.ston'.
	callsites := program callSites select:[ :site | site numberOfReceiverClasses  > 1]. 
	ordered := (callsites do:[:site | patternsVisualizer nbCallsBeforeSecondTypeOccurence: site. ]) sort: [ :a :b | a firstSwitchIndex > b firstSwitchIndex ].
"	plot:= 	(patternsVisualizer plotSwitchRatio: ordered) inspect .	
	plot plots first bins inject: 0 into:[:prev :cur | ] .
	callSitesPartitions := self partitionIntoSublists: ordered usingBins: plot plots first bins.
   plot2:= patternsVisualizer plotSwitchRatioWithCallNum: callSitesPartitions fromTotalCalls: program numberOfCalls .
	plot2 inspect"
	1 halt.
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> generatePositionalTableOfCallSites [
	<script>
	| traceProgram toExport |
	"export sites data Position-wise, lacks depth in call graph"
	traceProgram := self deserializeTracePatternsForFile: 'waterMap.ston'.
	toExport := traceProgram callSites collect: [:site | {site methodName. site selector. site bytecodeStart }  ].
	1 halt.
]

{ #category : 'class initialization' }
PatternCallSites class >> initialize [
	super initialize.
	tracePatternsDir := FileSystem  workingDirectory /'pharo-local' /'iceberg'/'fouziray'/'staticCallPharo'/'patternTrace'.
	
	(tracePatternsDir ) asFileReference exists ifFalse:[self error: 'gotta create a directory named: patternTrace
	- regenerate the trace using tracePatterns... for all program or copy it from elsewhere']

]

{ #category : 'divide' }
PatternCallSites class >> partitionIntoSublists: aCollectionOfCallSiteModels usingBins: bins [ 

    ^ bins allButLast collectWithIndex: [ :val1 :index |
        | val2 condition |
        val2 := bins at: index + 1.
        condition := index + 1 = bins size
            ifTrue: [ [ :value | value switchRatio between: val1 and: val2 ] ]
            ifFalse: [ [ :value | val1 <= value switchRatio and: [ value switchRatio < val2 ] ] ].
        aCollectionOfCallSiteModels select: condition
    ]
]

{ #category : 'switch' }
PatternCallSites class >> predomAnalysisStability [

	<script>
	
	self visualClass: LongestSequenceFrequentType. "irrelevant now"
	
	self predomTypeStableOn: 'trace-veritaswatershowDots'
]

{ #category : 'switch' }
PatternCallSites class >> predomTypeStableOn: aStonName [

	<script>
	| program |
	tracePatternsDir := FileSystem workingDirectory.
	program := self deserializeTracePatternsForFile:
		           ((aStonName endsWith: '.ston')
			            ifFalse: [ (aStonName , '.ston') asString ]
			            ifTrue: [ aStonName ]).

	self visualClass new plotPredomTypeStablity: program
]

{ #category : 'Full example' }
PatternCallSites class >> trace: aBlock outputFileSuffix: suffix [

	| simulator blockReturn program |
	simulator := self new.
	simulator block: aBlock.
	blockReturn := simulator execute.

	program := simulator constructProgram.

	"Matrixify - for thourough analysis in python"
"	MatrixSiteType new octaveFormat: program.
"
	"export trace into directory local"

	('trace-' , suffix , '.ston') asFileReference
		writeStreamDo: [ :stream | STON put: program onStream: stream ]
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfBloc [

	<script>
	self
		trace: [ VeritasBloc new run ]
		outputFileSuffix: 'veritasbloc'
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfCormas [

	<script>
	self
		trace: [ VeritasCormas new run ]
		outputFileSuffix: 'veritascormas'
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfDataFrame [

	<script>
	self
		trace: [ VeritasDataFrame new runTinySynthetic ]
		outputFileSuffix: 'veritasdf'
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfHoneyGinger [

	<script>
	self
		trace: [ VeritasHoneyGinger new run ]
		outputFileSuffix: 'veritashg'
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfMicrodown [

	<script>
	self
		trace: [ VeritasMicrodown new run ]
		outputFileSuffix: 'veritasmd'
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfMoose [

	<script>
	self
		trace: [ VeritasMoose new run ]
		outputFileSuffix: 'veritasmoo'
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfReMobidyc [

	<script>
	self
		trace: [ VeritasReMobidyc new run ]
		outputFileSuffix: 'veritasmobidyc'
]

{ #category : 'switch' }
PatternCallSites class >> typeSequenceStabiliyAnalysis [
	"a more general version of the frequent type stability analysis.
If a type is frequent  but only appears once in between sequences, that makes the analysis 
long sequences are not exclusive to frequent type only "

	<script>
	self visualClass: LongestSequenceFrequentType. "irrelevant now"

	self typeStableSequencesOn: 'trace-veritaswatershowDots'
]

{ #category : 'switch' }
PatternCallSites class >> typeStableSequencesOn: aStonName [

	<script>
	| program |
	tracePatternsDir := FileSystem workingDirectory.
	program := self deserializeTracePatternsForFile:
		           ((aStonName endsWith: '.ston')
			            ifFalse: [ (aStonName , '.ston') asString ]
			            ifTrue: [ aStonName ]).

	self visualClass new typeStableSequencesOn: program
]

{ #category : 'switch' }
PatternCallSites class >> typeSwitchAnalysis [

	<script>
	tracePatternsDir := FileSystem workingDirectory .
	self typeSwitchAnalysisOn: 'trace-veritaswatershowDots'
]

{ #category : 'switch' }
PatternCallSites class >> typeSwitchAnalysis: aFileName [

	<script>
	tracePatternsDir := FileSystem workingDirectory .
	self typeSwitchAnalysisOn: aFileName
]

{ #category : 'switch' }
PatternCallSites class >> typeSwitchAnalysisHG1 [

	<script>
	self typeSwitchAnalysisOn: 'waterMap'
]

{ #category : 'switch' }
PatternCallSites class >> typeSwitchAnalysisHG2 [

	<script>
	tracePatternsDir := FileSystem workingDirectory .
	self typeSwitchAnalysisOn: 'trace-veritaswatershowDots'
]

{ #category : 'switch' }
PatternCallSites class >> typeSwitchAnalysisOn: aStonName [

	<script>
	| program patternsVisualizer |
	patternsVisualizer := PicPatternVisual new.

	program := self deserializeTracePatternsForFile: (aStonName,'.ston') asString.

	patternsVisualizer plotSwitch: program
]

{ #category : 'switch' }
PatternCallSites class >> visualClass [

	^ visualClass ifNil:[ visualClass := PicPatternVisual ]
]

{ #category : 'switch' }
PatternCallSites class >> visualClass: aClass [

	visualClass := aClass
]

{ #category : 'accessing' }
PatternCallSites >> arrowsToParentMessages [

	^ arrowsToParentMessages 
]

{ #category : 'initialize' }
PatternCallSites >> constructProgram [

	| siteModels program |
	program := ProgramModel new
		           name: self block asString
		           fromRaw: self block -> self getAllCallSites
		           andPatterns: self typePatterns
		           withDepthOfMessages: self messageDepthDictionary.

	arrowsToParentMessages associationsDo: [ :a |
		a value  ifNotNil: [
			siteModels := a key propertyAt: #callsiteModel. "program siteWith: a key"
			a value do: [ :parentsite | parentsite ifNotNil: [ 
				siteModels pointTo: (parentsite propertyAt: #callsiteModel) callsiteid ] ] ] ].
	^ program
]

{ #category : 'initialize' }
PatternCallSites >> execute [

	super execute.

	"Some benchmarks launch concurrent threads that keep sending messages.
	Stop tracing now to handle all data collected up to this point"
	self stopTracing.
]

{ #category : 'initialization' }
PatternCallSites >> initialize [
	super initialize.
	typePatterns := IdentityDictionary new. 
	depth:= 0.
	messageDepthDictionary := IdentityDictionary new.
	arrowsToParentMessages := IdentityDictionary new.
	previousNode := nil. "initial do it message".
	
	finished := false.
]

{ #category : 'private - execution' }
PatternCallSites >> message: aNode method: aMethod receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
	| arguments result parentSave |
	finished ifTrue: [
		^ aReceiver withArgs: aArguments executeMethod: aMethod ].

	arguments := aArguments.
	aMethod selector = #doesNotUnderstand: ifTrue: [
		arguments := { (MessageSend
			              receiver: aReceiver
			              selector: aMethod selector
			              arguments: aArguments) } ].

	(aNode isNotNil and: [ aNode methodNode isNil ]) ifTrue: [
		^ aReceiver withArgs: arguments executeMethod: aMethod ].
	aNode ifNotNil: [
		(inlinedMethods includes: aNode selector) ifTrue: [
			^ aReceiver withArgs: arguments executeMethod: aMethod ].

		typePatterns
			at: aNode
			ifPresent: [ :m | m add: aReceiver class ]
			ifAbsentPut: [ "Dictionary new
			at: aMethod put: (Bag new
				add: aReceiver class;
				yourself);
			yourself"
				OrderedCollection newFrom: { aReceiver class } ].
		callsites
			at: aNode
			ifPresent: [ :m |
				m
					at: aMethod
					ifPresent: [ :r | r add: aReceiver class ]
					ifAbsentPut: [
						Bag new
							add: aReceiver class;
							yourself ] ]
			ifAbsentPut: [
				Dictionary new
					at: aMethod put: (Bag new
							 add: aReceiver class;
							 yourself);
					yourself ].
		arrowsToParentMessages
			at: aNode
			ifPresent: [ :parents | parents add: previousNode ]
			ifAbsentPut: [
				Set new
					add: previousNode;
					yourself ].

		messageDepthDictionary
			at: aNode
			ifPresent: [ :depths | depths add: depth ]
			ifAbsentPut: [
				Bag new
					add: depth;
					yourself ] ].


	parentSave := previousNode.
	depth := depth + 1.
	previousNode := aNode.

	result := aMethod selector = #whileFalse:
		          ifTrue: [
		          [ aReceiver value ] whileFalse: [ arguments first value ] ]
		          ifFalse: [
			          aMethod selector = #whileFalse
				          ifTrue: [ [ aReceiver value ] whileFalse ]
				          ifFalse: [
					          aMethod selector = #whileTrue
						          ifTrue: [ [ aReceiver value ] whileTrue ]
						          ifFalse: [
							          aMethod selector = #whileTrue:
								          ifTrue: [
								          [ aReceiver value ] whileTrue: [
									          arguments first value ] ]
								          ifFalse: [
								          aReceiver withArgs: arguments executeMethod: aMethod ] ] ] ].

	depth := depth - 1.
	previousNode := parentSave.
	"
	depth := depth + 1.   
    result := aReceiver withArgs: arguments executeMethod: aMethod.
    depth := depth - 1. 
	previousNode:= aNode."

	^ result
]

{ #category : 'accessing' }
PatternCallSites >> messageDepthDictionary [
	^ messageDepthDictionary
]

{ #category : 'initialization' }
PatternCallSites >> stopTracing [

	finished := true
]

{ #category : 'accessing' }
PatternCallSites >> typePatterns [

	^ typePatterns
]
