Class {
	#name : 'CallSitesStatsTests',
	#superclass : 'TestCase',
	#instVars : [
		'genericVisitor',
		'devirtualizer',
		'callSitesReceiversAssociations'
	],
	#category : 'PolymorphicCallSites-Tests',
	#package : 'PolymorphicCallSites',
	#tag : 'Tests'
}

{ #category : 'display' }
CallSitesStatsTests >> drawPieGraphicallyFor: aCollection [ 
| canvas data angles colors startAngle wedges colorsPattern |

"Your data"

data := aCollection asOrderedDictionary values.
colorsPattern := {'mono' -> Color red. 'poly'->Color blue. 'mega' -> Color green } asDictionary .
colors := aCollection keys collect: [ :k | colorsPattern at: k].

"Create canvas"
canvas := RSCanvas new.

"Calculate angles (in radians)"
angles := data collect: [ :value | 
    (value / data sum) * Float twoPi ].

"Draw pie wedges"
startAngle := 0.
wedges := angles withIndexCollect: [ :angle :index |
    | wedge |
    wedge := RSPieSlice new
        alphaAngle: startAngle;
        betaAngle: startAngle + angle;
        innerRadius: 0;
        externalRadius: 100;
        color: (colors at: index).
    startAngle := startAngle + angle.
    wedge ].

canvas addAll: wedges.
canvas open
]

{ #category : 'running' }
CallSitesStatsTests >> setUp [

	super setUp.
	genericVisitor := CallSitesFrequencyVisitor.
	devirtualizer := PolymorphicCallSitesVisitor.
	callSitesReceiversAssociations := self traceMicrodownParsingDocument . 
]

{ #category : 'tests' }
CallSitesStatsTests >> testPieChart [
	| frequencies |
	genericVisitor.
	"PolymorphicCallSitesVisitor filterFakePoly: self.
	"
frequencies := devirtualizer countFrequencyOfMessage: (devirtualizer getCallFrequencyForMessages: callSitesReceiversAssociations
) keys.
self assert: frequencies values sum equals: 11417.

self drawPieGraphicallyFor: frequencies.
"( (PolymorphicCallSitesVisitor filterFakePoly: self))
"	
]

{ #category : 'as yet unclassified' }
CallSitesStatsTests >> traceMicrodownParsingDocument [

		| document simulator devirtualizableNodes |
	document := MicrodownWithStaticCallBenchmarkSuite new
		            createSmallDocument.
	simulator := DevirtualizableCallSites new.
	simulator block: [ Microdown parse: document ].
	simulator execute.		

	devirtualizableNodes := simulator getAllCallSites.
	^ devirtualizableNodes 
]
