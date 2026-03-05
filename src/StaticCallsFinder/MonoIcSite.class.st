Class {
	#name : 'MonoIcSite',
	#superclass : 'IcSiteType',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'benchmarking' }
MonoIcSite >> setUp [

receivers := {Object} asOrderedCollection .
	self reinitCaller.
	3 timesRepeat: [ self caller send: Object ]
]
