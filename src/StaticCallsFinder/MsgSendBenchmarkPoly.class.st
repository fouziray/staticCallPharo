Class {
	#name : 'MsgSendBenchmarkPoly',
	#superclass : 'MsgSendBenchmark',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'as yet unclassified' }
MsgSendBenchmarkPoly >> initIcType [

	icType := PolyIcSite with: self
]
