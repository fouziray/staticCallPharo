Class {
	#name : 'PatternCallSites',
	#superclass : 'DevirtualizableCallSites',
	#instVars : [
		'typePatterns'
	],
	#classInstVars : [
		'tracePatternsDir'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

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
PatternCallSites class >> tracePatternsOfHg [
	<script>
	| simulator blockReturn program |
	simulator := self new .
	simulator block: [ HGSimulator watershowPressureMap. WorldMorph doOneCycle . WorldMorph doOneCycle .
		"(Duration seconds: 3) wait" ].
	blockReturn := simulator execute.		
	
	program := ProgramModel new name:'	hgWater '  fromRaw: ([ HGSimulator watershowPressureMap. WorldMorph doOneCycle . WorldMorph doOneCycle .
	
	(Duration seconds: 3) wait ]) -> simulator getAllCallSites andPatterns: simulator typePatterns. 
	( tracePatternsDir /'hgWater.ston') asFileReference writeStreamDo: [ :stream |
    STON put: program onStream: stream
].
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

{ #category : 'initialization' }
PatternCallSites >> initialize [
	super initialize.
	typePatterns := IdentityDictionary new. 
]

{ #category : 'private - execution' }
PatternCallSites >> message: aNode method: aMethod receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
   | arguments |
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
	
	
	].
	^ aReceiver withArgs: arguments executeMethod: aMethod
   
]

{ #category : 'accessing' }
PatternCallSites >> typePatterns [

	^ typePatterns
]
