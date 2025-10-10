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

{ #category : 'as yet unclassified' }
ProfilingStaticCallsTest >> multiReceiverExample: anObject [

	anObject yourself2
]

{ #category : 'as yet unclassified' }
ProfilingStaticCallsTest >> multiReceiverInterproceduralExample: anObject [

	self secondCall: anObject
]

{ #category : 'as yet unclassified' }
ProfilingStaticCallsTest >> multiReceiverInterproceduralExample: anObject

	selfsecondCall: anObject [ 
]

{ #category : 'as yet unclassified' }
ProfilingStaticCallsTest >> secondCall [

	^ self
]

{ #category : 'as yet unclassified' }
ProfilingStaticCallsTest >> secondCall: anObject [

	anObject foo.
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

	self installProfilerToSendsOf: self class >> #multiReceiverExample:.
	{
		Object new.
		5.
		String } do: [ :e | self multiReceiverExample: e ].

	self
		assert: (profiler receiverProfileTypesAt:
				 (self class >> #multiReceiverExample:) ast sendNodes first) size
		equals: 3
]

{ #category : 'tests' }
ProfilingStaticCallsTest >> testProfilingInterproceduralClass [
"the instrumentation should be propagated into multiple levels of the execution"
	self installProfilerToSendsOf:
		self class >> #multiReceiverInterproceduralExample:.
	{
		Object new.
		5.
		String } do: [ :e | self multiReceiverInterproceduralExample: e ].

	self
		assert: (profiler receiverProfileTypesAt:
				 (self class >> #multiReceiverInterproceduralExample:) ast
					 sendNodes first) size
		equals: 1.
	self
		assert: (profiler receiverProfileTypesAt:
				 (self class >> #secondCall:) ast sendNodes first) size
		equals: 3
]

{ #category : 'tests' }
ProfilingStaticCallsTest >> testProfilingOnMicrodown [
	"the instrumentation should be propagated into multiple levels of the execution"

	"self installProfilerToSendsOf: MicrodownParser >> #parse:."
	self installProfilerToSendsOf: MicrodownWithStaticCallBenchmarkSuite >> #runQuickBenchmarkForTest.	
	MicrodownWithStaticCallBenchmarkSuite new runQuickBenchmarkForTest.
	self deny: true.
	self
		assert: (profiler receiverProfileTypesAt:
				 (self class >> #multiReceiverInterproceduralExample:) ast
					 sendNodes first) size
		equals: 1.
	self
		assert: (profiler receiverProfileTypesAt:
				 (self class >> #secondCall:) ast sendNodes first) size
		equals: 3
]
