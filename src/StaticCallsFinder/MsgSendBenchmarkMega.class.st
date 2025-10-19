Class {
	#name : 'MsgSendBenchmarkMega',
	#superclass : 'MsgSendBenchmark',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'as yet unclassified' }
MsgSendBenchmarkMega >> initIcType [

	icType := MegaIcSite with: self
]
