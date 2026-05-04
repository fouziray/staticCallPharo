Class {
	#name : 'MicroBenchStats',
	#superclass : 'SMarkSuite',
	#instVars : [
		'program',
		'icCaller',
		'icType',
		'iterations',
		'receivers'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64Yourselves2 [

	1 to: program iteration last do: [ :e | icCaller send: Object ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64YourselvesBestCase [

	1 to:  (program iteration  last) do: [ :e | icCaller send: Set ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> benchSendsTo64YourselvesStatic2 [

	1 to: program iteration last do: [ :e | icCaller sendSStatic: Object ]
]

{ #category : 'alternating Types' }
MicroBenchStats >> benchWithAlternatingTypes [


	1 to:  (iterations) do: [ :e | icCaller send: receivers next ]
]

{ #category : 'alternating Types' }
MicroBenchStats >> benchWithAlternatingTypesStatic [


	1 to:  (iterations) do: [ :e | icCaller sendSStatic: receivers next ]
]

{ #category : 'accessing' }
MicroBenchStats >> iterations [

	^ iterations
]

{ #category : 'accessing' }
MicroBenchStats >> iterations: anObject [

	iterations := anObject.

	
	receivers := (OrderedCollection newFrom:  icType receivers).
	(iterations / icType receivers size)asInteger timesRepeat: [ receivers  addAll: icType receivers ].
	receivers := ReadStream on: receivers.
]

{ #category : 'running' }
MicroBenchStats >> setUp [


	program := BMicroVariedInput iterationNumber: 1000.

	iterations:= 1000.
]

{ #category : 'as yet unclassified' }
MicroBenchStats >> timesToRun: aBenchName [
	^ [self perform: aBenchName] microsecondsToRun asInteger asString

]

{ #category : 'benchmarking' }
MicroBenchStats >> yourselfIterations [

	1 to: iterations do: [ :e | icCaller send: Object ]
]

{ #category : 'benchmarking' }
MicroBenchStats >> yourselfIterationsStatic [

	1 to: iterations do: [ :e | icCaller sendSStatic: Object ]
]
