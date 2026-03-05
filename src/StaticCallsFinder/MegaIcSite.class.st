Class {
	#name : 'MegaIcSite',
	#superclass : 'IcSiteType',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'running' }
MegaIcSite >> setUp [

receivers := {Object . Set . 1 .Object new.  'ejejee' . String. true} asOrderedCollection .
	self reinitCaller.
	3 timesRepeat: [
		caller
			send: Object;
			send: Set;
			send: 1;
			send: Object new;
			send: 'ejejee';
			send: String;
			send: true ]
]
