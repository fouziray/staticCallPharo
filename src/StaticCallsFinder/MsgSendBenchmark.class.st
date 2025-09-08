Class {
	#name : 'MsgSendBenchmark',
	#superclass : 'MicroBenchStats',
	#instVars : [
		'icType'
	],
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

{ #category : 'running' }
MsgSendBenchmark >> setUp [

 	self initIcType.
	super setUp
]

{ #category : 'as yet unclassified' }
MsgSendBenchmark >> warmUp [

	icType setUp
]
