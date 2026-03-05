Class {
	#name : 'MsgSendBenchmark',
	#superclass : 'MicroBenchStats',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
MsgSendBenchmark >> caller [

	^ icCaller
]

{ #category : 'running' }
MsgSendBenchmark >> initIcType [

	self subclassResponsibility
]

{ #category : 'benchmarking' }
MsgSendBenchmark >> problemSize [ 

	^ 10000
]

{ #category : 'running' }
MsgSendBenchmark >> setUp [

 	self initIcType.
		self warmUp. 
	super setUp
]

{ #category : 'as yet unclassified' }
MsgSendBenchmark >> warmUp [

	icType setUp
]
