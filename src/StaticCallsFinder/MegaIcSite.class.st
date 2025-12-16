Class {
	#name : 'MegaIcSite',
	#superclass : 'IcSiteType',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'running' }
MegaIcSite >> setUp [

	self reinitCaller.
	3 timesRepeat: [
		caller
			performSend: Object;
			performSend: Set;
			performSend: 1;
			performSend: Object new;
			performSend: 'ejejee';
			performSend: String;
			performSend: true ]
]
