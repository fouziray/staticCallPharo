Class {
	#name : 'PicPatternVisual',
	#superclass : 'Object',
	#category : 'PolymorphicCallSites-CopyDowner',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDowner'
}

{ #category : 'as yet unclassified' }
PicPatternVisual class >> callSitesFromHoneyGinger [

	^ STON fromString: FileSystem workingDirectory / 'tracing'
		  / '33VeritasHoneyGinger new run.ston'
]

{ #category : 'as yet unclassified' }
PicPatternVisual class >> callSitesFromNewTraceHoneyGinger [

	^ STON fromString: FileSystem workingDirectory / 'tracePattern' / 'hgWater.ston'
]

{ #category : 'as yet unclassified' }
PicPatternVisual class >> visualize: aDictionary [

	^ self new visualize: aDictionary
]

{ #category : 'as yet unclassified' }
PicPatternVisual class >> visualizeCallSites: aListOfCallsSiteModels [
	"There needs to be a type patterns in each calls site
	We normalize the x axis, since we have different calls to each site
	Some plots are disproportionate to others which makes observing or concluding difficult
	"

	^ PicPatternVisual new visualizeAllSites: aListOfCallsSiteModels
]

{ #category : 'as yet unclassified' }
PicPatternVisual class >> visualizeHG [

	<script>
	^ self visualizeCallSites: self callSitesFromHoneyGinger
]

{ #category : 'visual' }
PicPatternVisual >> getTransitionTriggerCounter: aCallSiteModel forPattern: aCollection [ 
		
	| y  previousTypes|
	
	y:= OrderedCollection newFrom: {0}.

	previousTypes := Dictionary newFrom: { aCollection first -> 0 }.
 	aCollection allButFirst inject: aCollection first into:[ :e :c |  (e = c )ifTrue:[ y add: y last] ifFalse: [
			previousTypes at: c ifPresent:[ y add: (previousTypes at: c) ] ifAbsentPut: [ y add: y last + 1 . y last + 1 ].
		].	
 	c].
	
	^ y

]

{ #category : 'plot' }
PicPatternVisual >> plotSwitchRatio: aCollection [ 
	| values c plot |
	"
	To interpret this histogram take into consideration the following rule to calculate the ratio
	--> switchCounter / aCallSite numberOfCalls
	This means, higher ratio means more switches --> unstable pics. Less ration is proof of low switch rate.
	"
	
	c := RSCompositeChart new.
	plot := RSHistogramPlot new x: (aCollection collect:#switchRatio) .
	c add: plot.
	c title: 'Hisotgram Of ratio of switch X number of callsites '.
	
	
	^ c
]

{ #category : 'plot' }
PicPatternVisual >> plotSwitchRatioWithCallNum: aCollection [ 
	|composite hist |
	composite := self plotSwitchRatio: aCollection flattened.
	composite  build.

	
	hist := composite plots first.
	hist bars doWithIndex: [ :bar :i |
    | label value |
    value := (aCollection at: i) sum:[:e| e numberOfCalls] .
    label := RSLabel new
        text: value printString;
        color: Color black;
        yourself.
    label translateTo: bar position + (0 @ (bar height / 2 + 10) negated).
    composite canvas add: label.


].
	composite canvas  signalUpdate .
^composite canvas
	
]

{ #category : 'plot' }
PicPatternVisual >> plotSwitchRatioWithCallNum: aCollection fromTotalCalls: aTotalCallNumber [

	| composite hist |
	composite := self plotSwitchRatio: aCollection flattened.
	composite build.


	hist := composite plots first.
	hist bars doWithIndex: [ :bar :i |
		| label value |
		value := ((((aCollection at: i) sum: [ :e | e numberOfCalls ])
		         / aTotalCallNumber) * 100) asFloat .
		label := RSLabel new
			         text: (value printShowingDecimalPlaces: 1) , '%';
			         color: Color black;
			         yourself.

		label translateTo:
			bar position + (0 @ (bar height / 2 + 10) negated).
		composite canvas add: label ].
	composite canvas signalUpdate.
	^ composite canvas
]

{ #category : 'visual' }
PicPatternVisual >> switchRatioPerSite: aCallSite [

	|y switchCounter | 
		y := self getTransitionTriggerCounter: aCallSite forPattern: aCallSite typesPattern.
		y size.
		switchCounter :=0.
		y inject: 0  into: [ :prev :current | prev ~= current ifTrue:[ switchCounter :=switchCounter+1  ]. current].
		"
		We get the ratio the switch calls among all calls in the site
		Helps us order them from most to least stable.
		"
		^ aCallSite switchRatio: (switchCounter / aCallSite numberOfCalls) asFloat 
]

{ #category : 'as yet unclassified' }
PicPatternVisual >> visualize: anAssociation [

	| plt p x |
	anAssociation key. anAssociation value.
	
	^ self visualizeSingleCallSite: anAssociation key forPattern: anAssociation value.
	
]

{ #category : 'as yet unclassified' }
PicPatternVisual >> visualizeAllSites: aCollectionOfCallSites [ 

	^ self visualizeMultipleCallSitesWithPatterns: aCollectionOfCallSites . 
	
]

{ #category : 'as yet unclassified' }
PicPatternVisual >> visualizeAllSites: aCollectionOfCallSites allPatterns: aCollectionOfPatterns [

	^ self visualizeMultipleCallSites: aCollectionOfCallSites forPatterns: aCollectionOfPatterns. 
	
]

{ #category : 'visual' }
PicPatternVisual >> visualizeMultipleCallSites: aCallSiteModelCollection forPatterns: aCollectionOfPatterns [

	|x y plt p |
x := 1 to: (aCallSiteModelCollection collect:#numberOfCalls) max.
	plt := RSCompositeChart new.


	aCallSiteModelCollection doWithIndex: [ :aCallSiteModel :index | 
		y := self getTransitionTriggerCounter: aCallSiteModel forPattern: (aCollectionOfPatterns at: index).
		p := RSLinePlot new x: (1 to: (aCallSiteModel numberOfCalls)) y: y.
		plt add: p.
		
	].
	 
	
	
"	p := RSLinePlot new x: x y: (x raisedTo: 3).
	plt add: p.

	p := RSLinePlot new x: x y: (x raisedTo: 4).
	plt add: p.
"
	plt xlabel: 'Number Of Calls'.
	plt ylabel: 'Site class'.
	plt title: 'PIC Properties'.
	^ plt


]

{ #category : 'visual' }
PicPatternVisual >> visualizeMultipleCallSitesWithPatterns: aCallSiteModelCollection [

	|x y plt p |
x := 0 to: 1.
	plt := RSCompositeChart new.


	aCallSiteModelCollection doWithIndex: [ :aCallSiteModel :index | 
		y := self getTransitionTriggerCounter: aCallSiteModel forPattern: (aCallSiteModel typesPattern ).
		p := RSLinePlot new x: ((1 to: (aCallSiteModel typesPattern size)) / aCallSiteModel typesPattern size) y: y.
		plt add: p.
		self halt.
	].
	 
	
	
"	p := RSLinePlot new x: x y: (x raisedTo: 3).
	plt add: p.

	p := RSLinePlot new x: x y: (x raisedTo: 4).
	plt add: p.
"
	plt xlabel: 'Number Of Calls'.
	plt ylabel: 'Site class'.
	plt title: 'PIC Properties'.
	plt.
	^ plt


]

{ #category : 'visual' }
PicPatternVisual >> visualizeSingleCallSite: aCallSiteModel forPattern: aCollection [

	|x y plt p |

	y:= self getTransitionTriggerCounter: aCallSiteModel forPattern: aCollection. 
	x := 1 to:  aCallSiteModel  numberOfCalls.
	plt := RSCompositeChart new.
	
	p := RSLinePlot new x: x y: y.
	plt add: p.

"	p := RSLinePlot new x: x y: (x raisedTo: 3).
	plt add: p.

	p := RSLinePlot new x: x y: (x raisedTo: 4).
	plt add: p.
"
	plt xlabel: 'Number Of Calls'.
	plt ylabel: 'Site class'.
	plt title: 'PIC Properties'.
	^ plt


]
