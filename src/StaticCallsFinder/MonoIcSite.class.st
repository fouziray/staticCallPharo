Class {
	#name : 'MonoIcSite',
	#superclass : 'IcSiteType',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'benchmarking' }
MonoIcSite >> setUp [

	self reinitCaller.
	3 timesRepeat: [ self caller performSend: Object ]
]
