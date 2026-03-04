Class {
	#name : 'MicroBenchStats',
	#superclass : 'SMarkSuite',
	#instVars : [
		'program',
		'icCaller'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'as yet unclassified' }
MicroBenchStats class >> benchParsingMicroDown [

	<script>
	| document simulator devirtualizableNodes transformer baselineParse optParse |
	"before opt"
	baselineParse := self reportResults:
		                 (DocParsingBench
			                  runOnly: #benchParseDocument
			                  iterations: 30).
	"after opt"
	document := DocParsingBench smallDocument.
	simulator := DevirtualizableCallSites new.
	simulator block: [ Microdown parse: document ].
	simulator execute.

	devirtualizableNodes := simulator getAllCallSites.
	transformer := StaticCallSiteTransformer new
		               recordedTypes: devirtualizableNodes asDictionary;
		               yourself.
	transformer getNewMethodOfDevirtualizingAll.
	optParse := self reportResults: (DocParsingBench
			             runOnly: #benchParseDocument
			             iterations: 30).
	transformer rollbackBackedUpAst.
	^ {baselineParse , optParse} inspect
]

{ #category : 'as yet unclassified' }
MicroBenchStats class >> benchParsingMicroDown2 [

	<script>
	| document simulator devirtualizableNodes transformer baselineParse optParse |

	"after opt"
	document := DocParsingBench smallDocument.
	simulator := DevirtualizableCallSites new.
	simulator block: [ Microdown parse: document ].
	simulator execute.

	devirtualizableNodes := simulator getAllCallSites.
	transformer := StaticCallSiteTransformer new
		               recordedTypes: devirtualizableNodes asDictionary;
		               yourself.
	transformer getNewMethodOfDevirtualizingAll.
	optParse := self reportResults: (DocParsingBench
			             runOnly: #benchParseDocument
			             iterations: 30).
	transformer rollbackBackedUpAst.
		"before opt"
	baselineParse := self reportResults:
		                 (DocParsingBench
			                  runOnly: #benchParseDocument
			                  iterations: 30).
	^ {baselineParse , optParse} inspect
]

{ #category : 'as yet unclassified' }
MicroBenchStats class >> benchSend64MsgMega [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkMega 
			     runOnly: #benchSendsTo64Yourselves
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkMega
			     runOnly: #benchSendsTo64YourselvesStatic
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroBenchStats class >> benchSend64MsgMega2 [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkMega
			     runOnly: #benchSendsTo64Yourselves2
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkMega
			     runOnly: #benchSendsTo64YourselvesStatic2
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroBenchStats class >> benchSend64MsgMono [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkMono
			     runOnly: #benchSendsTo64Yourselves
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkMono
			     runOnly: #benchSendsTo64YourselvesStatic
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroBenchStats class >> benchSend64MsgPoly [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkPoly 
			     runOnly: #benchSendsTo64Yourselves
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkPoly
			     runOnly: #benchSendsTo64YourselvesStatic
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroBenchStats class >> benchSend64MsgPoly2 [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkPoly
			     runOnly: #benchSendsTo64Yourselves3
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkPoly
			     runOnly: #benchSendsTo64YourselvesStatic3
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroBenchStats class >> reportResults: aResult [

 ^ String streamContents:[ :aStream | aResult reportOn: aStream]


]

{ #category : 'benchmarking' }
MicroBenchStats >> benchFiboStaticWithouMuchRep [

	program iteration: 30.
	program benchFiboStaticWithoutRepetition
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchFiboWithouMuchRep [

	program iteration: 30.
	program benchFiboWithoutRepetition
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchMy1 [

		4 benchFib .
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchMyFactorial [


		program benchFibo.
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchMyFactorialStatic [

		program benchFiboStatic.
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64Yourselves [

	1 to:  (program iteration  last) do: [ :e | icCaller send: Object ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64Yourselves2 [

	1 to: program iteration last do: [ :e | icCaller send: String ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64Yourselves3 [

	1 to: program iteration last do: [ :e | icCaller send: 23 ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64YourselvesStatic [

	1 to: program iteration last do: [ :e | icCaller sendSStatic: Object ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64YourselvesStatic2 [

	1 to: program iteration last do: [ :e | icCaller sendSStatic: String ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64YourselvesStatic3 [

	1 to: program iteration last do: [ :e | icCaller sendSStatic: 23 ]
]

{ #category : 'script entry' }
MicroBenchStats >> defaultNumberOfIterations [
    ^ 50
]

{ #category : 'script entry' }
MicroBenchStats >> defaultNumberOfProcesses [
    ^ 8
]

{ #category : 'script entry' }
MicroBenchStats >> defaultProblemSize [
    ^ 30
]

{ #category : 'accessing' }
MicroBenchStats >> program [

	^ program
]

{ #category : 'accessing' }
MicroBenchStats >> program: anObject [

	program := anObject
]

{ #category : 'running' }
MicroBenchStats >> reinitCaller [

	icCaller := Caller new
]

{ #category : 'as yet unclassified' }
MicroBenchStats >> reportResults: aResult [ 
	^ self class reportResults: aResult 
]

{ #category : 'running' }
MicroBenchStats >> setUp [


	program := BMicroVariedInput iterationNumber: 1000.

	
]

{ #category : 'benchmarking' }
MicroBenchStats >> setUpIcMega [

	self reinitCaller.
	3 timesRepeat: [
		icCaller
			send: Object;
			send: Set;
			send: 1;
			send: Object new;
			send: 'ejejee';
			send: String;
			send: true ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> setUpIcPoly [

	self reinitCaller.
	3 timesRepeat: [
		icCaller
			send: Object;
			send: Set;
			send: 1 ]
]
