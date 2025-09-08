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

	program iteration: 30.
	icCaller send: Object
]

{ #category : 'benchmarking' }
MicroStats >> benchSendsTo64YourselvesStatic [

	program iteration: 30.
	icCaller sendSStatic: Object
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
MicroStats >> setUp [

	1 halt.
	program := BMicroVariedInput iterationNumber: 30.
	icCaller := Caller new
]

{ #category : 'benchmarking' }
MicroStats >> setUpIcMega [

	icCaller := Caller new.
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
MicroStats >> setUpIcMono [

	icCaller := Caller new.
	3 timesRepeat: [ icCaller send: Object ]
]

{ #category : 'benchmarking' }
MicroStats >> setUpIcPoly [

	
	icCaller := Caller new.
	3 timesRepeat: [
		icCaller
			send: Object;
			send: Set;
			send: 1 ].
]
