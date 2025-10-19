Class {
	#name : 'MsgSendBenchmarkMono',
	#superclass : 'MsgSendBenchmark',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'as yet unclassified' }
MsgSendBenchmarkMono >> initIcType [

	icType := MonoIcSite with: self
]
