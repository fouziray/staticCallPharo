Class {
	#name : 'PolyIcSite',
	#superclass : 'IcSiteType',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'benchmarking' }
PolyIcSite >> setUp [

	self reinitCaller.
	3 timesRepeat:  [caller performSend: Object; performSend: Set; performSend: 1 ].
]
