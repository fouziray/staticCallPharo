Class {
	#name : 'PatternCallSites',
	#superclass : 'DevirtualizableCallSites',
	#instVars : [
		'typePatterns',
		'messageDepthDictionary',
		'depth',
		'arrowsToParentMessages',
		'previousNode'
	],
	#classInstVars : [
		'tracePatternsDir'
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

	^  self deserializeStonFor: tracePatternsDir / aFileNameString 
	
	
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

{ #category : 'as yet unclassified' }
PatternCallSites class >> tracePatternsOfButterBalll [
	<script>
	| simulator blockReturn program |
	simulator := self new .
	simulator block: [ HGSimulator butterBallAtDie . WorldMorph doOneCycle . WorldMorph doOneCycle ].
	blockReturn := simulator execute.		
	
	program := ProgramModel new name:'	ButterBallAtDie '  fromRaw: ( [ HGSimulator butterBallAtDie . WorldMorph doOneCycle . WorldMorph doOneCycle ]) -> simulator getAllCallSites andPatterns: simulator typePatterns. 
	( tracePatternsDir / 'butterBallAtDie.ston' ) asFileReference writeStreamDo: [ :stream |
    STON put: program onStream: stream
].
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> tracePatternsOfHg [
	<script>
	| simulator blockReturn program |
	simulator := self new .
	simulator block: [ HGSimulator watershowPressureMap. WorldMorph doOneCycle . WorldMorph doOneCycle .
		"(Duration seconds: 3) wait" ].
	blockReturn := simulator execute.		
	
	program := ProgramModel new name:'	hgWater '  fromRaw: ([ HGSimulator watershowPressureMap. WorldMorph doOneCycle . WorldMorph doOneCycle .
	
	"(Duration seconds: 3) wait" ]) -> simulator getAllCallSites andPatterns: simulator typePatterns withDepthOfMessages: simulator messageDepthDictionary. 
	( tracePatternsDir /'hgWaterDepth.ston') asFileReference writeStreamDo: [ :stream |
    STON put: program onStream: stream
].
]

{ #category : 'Full example' }
PatternCallSites class >> tracePatternsOfHgWithGraph [
	<script>
	| simulator blockReturn program |
	simulator := self new .
	simulator block: [ HGSimulator watershowPressureMap. WorldMorph doOneCycle . WorldMorph doOneCycle .
		"(Duration seconds: 3) wait" ].
	blockReturn := simulator execute.		
	
	program :=  simulator constructProgram .
	1 halt.
	
	"Matrixify - for thourough analysis in python"
	"MatrixSiteType new octaveFormat: program "
	
	"export trace into directory local"
	
	"( tracePatternsDir /'hgWaterDepth.ston') asFileReference writeStreamDo: [ :stream |
    STON put: program onStream: stream
]".
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> typeSwitchAnalysis [
	
	<script>

	| program callSitesPartitions patternsVisualizer ordered plot plot2 |
	patternsVisualizer := PicPatternVisual new.
	program :=  self deserializeTracePatternsForFile: 'waterMap.ston'.

	ordered := (program callSites do:[:site | patternsVisualizer switchRatioPerSite: site. ]) sort: [ :a :b | a switchRatio > b switchRatio ].
	plot:= 	(patternsVisualizer plotSwitchRatio: ordered) inspect .	
	plot plots first bins inject: 0 into:[:prev :cur | ] .
	callSitesPartitions := self partitionIntoSublists: ordered usingBins: plot plots first bins.
   plot2:= patternsVisualizer plotSwitchRatioWithCallNum: callSitesPartitions fromTotalCalls: program numberOfCalls .
	plot2 inspect
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

{ #category : 'initialization' }
PatternCallSites >> initialize [
	super initialize.
	typePatterns := IdentityDictionary new. 
	depth:= 0.
	messageDepthDictionary := IdentityDictionary new.
	arrowsToParentMessages := IdentityDictionary new.
	previousNode := nil. "initial do it message"
]

{ #category : 'private - execution' }
PatternCallSites >> message: aNode method: aMethod receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
   | arguments result parentSave |
	arguments := aArguments.
	(aMethod selector = #doesNotUnderstand:) ifTrue: [ 
			arguments := { (MessageSend
						receiver: aReceiver
                 selector: aMethod selector 
                 arguments: aArguments) }
   	].

	(aNode isNotNil and: [ aNode methodNode isNil ]) 
		ifTrue: [ ^ aReceiver withArgs: arguments executeMethod: aMethod ].
	aNode ifNotNil: [ 
		(inlinedMethods includes: aNode selector) 
			ifTrue: [ ^ aReceiver withArgs: arguments executeMethod: aMethod
    ].

	typePatterns at: aNode 
		ifPresent: [ :m |  m add: aReceiver class ]
		ifAbsentPut: [ "Dictionary new
			at: aMethod put: (Bag new
				add: aReceiver class;
				yourself);
			yourself"
			OrderedCollection newFrom: { aReceiver class }
		].
	callsites at: aNode 
		ifPresent: [ :m | m at: aMethod 
			ifPresent: [ :r | r add: aReceiver class ]
			ifAbsentPut: [ Bag new
				add: aReceiver class;
				yourself ]
		]
		ifAbsentPut: [ Dictionary new
			at: aMethod put: (Bag new
				add: aReceiver class;
				yourself);
			yourself
		].
	arrowsToParentMessages at: aNode
    ifPresent: [ :parents | parents add: previousNode ]
    ifAbsentPut: [ Set new add: previousNode; yourself ].

		messageDepthDictionary
            at: aNode
            ifPresent: [ :depths | depths add:   depth ]
            
				ifAbsentPut: [ Bag new add: depth; yourself ] 
	
	].
 	 
	
	parentSave := previousNode.
	depth := depth + 1.
	previousNode := aNode.
	result := aReceiver withArgs: arguments executeMethod: aMethod.
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

{ #category : 'accessing' }
PatternCallSites >> typePatterns [

	^ typePatterns
]
