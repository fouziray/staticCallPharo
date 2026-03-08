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
	           3 timesRepeat: [
		           caller
			           send: Set;
			           send: 1;
			           send: OrderedCollection new;
			           send: 1.0;
			           send: 'toto';
			           send: Object ]
]
