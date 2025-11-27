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

{ #category : 'veritas' }
MsgSendBenchmarkMono >> trivialCase1 [

	{Object new. String new. Class . OrderedCollection newFrom: { 2. 3 . 5.3 } . 'sasaa'}  collect:[ :e | e printString ]


]
