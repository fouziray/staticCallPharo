Class {
	#name : 'MicroStats',
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
MicroStats class >> benchSend64MsgMega [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkMega 
			     runOnly: #benchSendsTo64Yourselves
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkMega
			     runOnly: #benchSendsTo64YourselvesStatic
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroStats class >> benchSend64MsgMono [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkMono
			     runOnly: #benchSendsTo64Yourselves
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkMono
			     runOnly: #benchSendsTo64YourselvesStatic
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroStats class >> benchSend64MsgPoly [

	<script>
	^ ((self reportResults: (MsgSendBenchmarkPoly 
			     runOnly: #benchSendsTo64Yourselves
			     iterations: 30)) , (self reportResults: (MsgSendBenchmarkPoly
			     runOnly: #benchSendsTo64YourselvesStatic
			     iterations: 30))) inspect
]

{ #category : 'as yet unclassified' }
MicroStats class >> reportResults: aResult [

 ^ String streamContents:[ :aStream | aResult reportOn: aStream]


]

{ #category : 'benchmarking' }
MicroStats >> benchFiboStaticWithouMuchRep [

	program iteration: 30.
	program benchFiboStaticWithoutRepetition
]

{ #category : 'benchmarking' }
MicroStats >> benchFiboWithouMuchRep [

	program iteration: 30.
	program benchFiboWithoutRepetition
]

{ #category : 'benchmarking' }
MicroStats >> benchMy1 [

		4 benchFib .
]

{ #category : 'benchmarking' }
MicroStats >> benchMyFactorial [


		program benchFibo.
]

{ #category : 'benchmarking' }
MicroStats >> benchMyFactorialStatic [

		program benchFiboStatic.
]

{ #category : 'benchmarking' }
MicroStats >> benchSendsTo64Yourselves [

	1 to:  (program iteration  last) do: [ :e | icCaller send: Object ]
]

{ #category : 'benchmarking' }
MicroStats >> benchSendsTo64YourselvesStatic [

	1 to: program iteration last do: [ :e | icCaller sendSStatic: Object ]
]

{ #category : 'script entry' }
MicroStats >> defaultNumberOfIterations [
    ^ 50
]

{ #category : 'script entry' }
MicroStats >> defaultNumberOfProcesses [
    ^ 8
]

{ #category : 'script entry' }
MicroStats >> defaultProblemSize [
    ^ 30
]

{ #category : 'running' }
MicroStats >> reinitCaller [

	icCaller := Caller new
]

{ #category : 'as yet unclassified' }
MicroStats >> reportResults: aResult [ 
	^ self class reportResults: aResult 
]

{ #category : 'running' }
MicroStats >> setUp [

	self warmUp.
	program := BMicroVariedInput iterationNumber: 500.

	
]

{ #category : 'benchmarking' }
MicroStats >> setUpIcMega [

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
MicroStats >> setUpIcPoly [

	self reinitCaller.
	3 timesRepeat: [
		icCaller
			send: Object;
			send: Set;
			send: 1 ]
]
