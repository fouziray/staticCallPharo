Class {
	#name : 'BMicroVariedInput',
	#superclass : 'StaticStats',
	#instVars : [
		'iteration',
		'methodName',
		'step'
	],
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'as yet unclassified' }
BMicroVariedInput class >> iterationNumber: x [

	^ self
		  new
		step: 5;
		  iteration: x
]

{ #category : 'as yet unclassified' }
BMicroVariedInput >> benchFactorial [

	| result |
	result := Dictionary new.
	methodName ifNil: [ methodName := (Integer >> #slowFactorial) ].
	iteration do: [ :aVar |
		result
			at: aVar
			put: [ 10 timesRepeat: [ aVar slowFactorial ] ] bench iterations ].
	^ result
]

{ #category : 'as yet unclassified' }
BMicroVariedInput >> benchFactorialStatic [

	| result |
	result := Dictionary new.
	methodName ifNil: [ methodName := (Integer >> #benchFibo ) ].
	
	iteration do: [ :aVar |
		result at: aVar put: [
			10 timesRepeat: [ aVar slowFactorialStatic ]. ] bench iterations ].
	^ result
]

{ #category : 'as yet unclassified' }
BMicroVariedInput >> benchFibo [

	| result |
	result := Dictionary new.
	methodName ifNil: [ methodName := (Integer >> #benchFib ) ].
	
	iteration do: [ :aVar |
		result at: aVar put: [
			self
				runProgram: Integer >> #benchFib
				withArgs: {  }
				receiver: aVar
				for: 10 ] bench iterations ].
	^ result
]

{ #category : 'as yet unclassified' }
BMicroVariedInput >> benchFiboStatic [

	| result |
	result := Dictionary new.
	methodName ifNil: [ methodName := (Integer >> #benchFibo ) ].
	
	iteration do: [ :aVar |
		result at: aVar put: [
			10 timesRepeat: [ aVar benchFibStatic ]. ] bench iterations ].
	^ result
]

{ #category : 'initialization' }
BMicroVariedInput >> initialize [ 

iteration:= 1 to: 20 by: 5
]

{ #category : 'initialization' }
BMicroVariedInput >> iteration [

	^ iteration
]

{ #category : 'accessing' }
BMicroVariedInput >> iteration: x [

	iteration := 1 to: x by: step
]

{ #category : 'as yet unclassified' }
BMicroVariedInput >> plotx: x2 y: y [

	| plt p x|
	 
	plt := RSCompositeChart new.
	p := RSLinePlot new x: iteration y: y; color: Color red.
	plt add: p.

	p := RSLinePlot new x: iteration y: x2.
	plt add: p.


	plt xlabel: 'Receiver'.
	plt ylabel: 'Iterations'.
	plt title: methodName selector, ' Benchmark'.
	^ plt
]

{ #category : 'as yet unclassified' }
BMicroVariedInput >> runProgram: aCompiledMethod withArgs: anArray receiver: aReceiver for: iterationNumber [

	iterationNumber timesRepeat: [
		aReceiver withArgs: anArray executeMethod: aCompiledMethod ]
]

{ #category : 'accessing' }
BMicroVariedInput >> step [

	^ step
]

{ #category : 'accessing' }
BMicroVariedInput >> step: a [

	step := a
]
