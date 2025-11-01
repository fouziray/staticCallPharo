Class {
	#name : 'BasicBench',
	#superclass : 'Object',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'benchmarking' }
BasicBench class >> bench: message [

	| runs |
	runs := (1 to: self iterations) collect: [ :i |
		        [
		        1000 timesRepeat: [
			        MsgSendBenchmarkMono new
				        setUp;
				        perform: message ] ] timeToRun ].
	
	^ { runs average. (runs collect: #asMilliSeconds) stdev }
]

{ #category : 'benchmarking' }
BasicBench class >> benchBaseline [

	^ self bench: #benchSendsTo64Yourselves2
]

{ #category : 'benchmarking' }
BasicBench class >> benchStatic [

	^ self bench: #benchSendsTo64YourselvesStatic2
]

{ #category : 'accessing' }
BasicBench class >> iterations [
	
	^ 30
]
