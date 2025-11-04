Class {
	#name : 'CallSitesStatsTests',
	#superclass : 'TestCase',
	#instVars : [
		'genericVisitor',
		'devirtualizer',
		'callSitesReceiversAssociations'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

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
