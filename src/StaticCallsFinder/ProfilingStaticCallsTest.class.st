Class {
	#name : 'ProfilingStaticCallsTest',
	#superclass : 'TestCase',
	#instVars : [
		'profiler',
		'benchmarkSuite'
	],
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'profiling' }
ProfilingStaticCallsTest >> installProfilerToSendsOf: cMethod [

	profiler addLinkToNodes: (cMethod ast  sendNodes ) 
]

{ #category : 'tests - fixture' }
ProfilingStaticCallsTest >> multiReceiverExample [
	self yourself.
]

{ #category : 'as yet unclassified' }
ProfilingStaticCallsTest >> multiReceiverExample: anObject [

	anObject yourself
]

{ #category : 'running' }
ProfilingStaticCallsTest >> setUp [ 

profiler := ProfilingMessageReceiverType new.
]

{ #category : 'tests' }
ProfilingStaticCallsTest >> tearDown [

	profiler uninstallLink
]

{ #category : 'tests' }
ProfilingStaticCallsTest >> testProfilingClass [

	self installProfilerToSendsOf: (self class>>#multiReceiverExample:) .
	{ Object new. 5 . String } do: [ :e | self multiReceiverExample: e ].

	self
		assert: (profiler receiverProfileTypesAt:
				 (self class>>#multiReceiverExample:) ast sendNodes first) size
		equals: 3
]
