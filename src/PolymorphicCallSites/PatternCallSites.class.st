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

{ #category : 'class initialization' }
PatternCallSites class >> initialize [
	super initialize.
	tracePatternsDir:= FileSystem  workingDirectory /'pharo-local' /'iceberg'/'fouziray'/'staticCallPharo'/'patternTrace'.
	
	(tracePatternsDir ) asFileReference exists ifFalse:[self error: 'gotta create a directory named: patternTrace
	- regenerate the trace using tracePatterns... for all program or copy it from elsewhere']

]

{ #category : 'as yet unclassified' }
PatternCallSites class >> tracePatternsOfHg [
	<script>
	| simulator blockReturn program |
	simulator := self new .
	simulator block: [ HGSimulator watershowPressureMap. WorldMorph doOneCycle . WorldMorph doOneCycle .
		(Duration seconds: 3) wait ].
	blockReturn := simulator execute.		
	
	program := ProgramModel new name:'	hgWater '  fromRaw: ([ HGSimulator watershowPressureMap. WorldMorph doOneCycle . WorldMorph doOneCycle .
	
	(Duration seconds: 3) wait ]) -> simulator getAllCallSites andPatterns: simulator typePatterns. 
	( tracePatternsDir ) asFileReference writeStreamDo: [ :stream |
    STON put: program onStream: stream
].
]

{ #category : 'as yet unclassified' }
PatternCallSites class >> typeSwitchAnalysis [
	
	<script>

	| program patternsVisualizer ordered |
	patternsVisualizer := PicPatternVisual new.
	program :=  self deserializeTracePatternsForFile: 'waterMap.ston'.
	
	ordered := (program callSites do:[:site | patternsVisualizer switchRatioPerSite: site. ]) sort: [ :a :b | a switchRatio > b switchRatio ].
	^ patternsVisualizer plotSwitchRatio: ordered.	
	

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
			OrderedCollection newFrom: { aReceiver }
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
