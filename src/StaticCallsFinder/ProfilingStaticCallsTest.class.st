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

{ #category : 'running' }
ProfilingStaticCallsTest >> setUp [ 
	
	profiler := ProfilingMessageReceiverType new.
	benchmarkSuite := MicrodownWithStaticCallBenchmarkSuite new.
	benchmarkSuite profiler: profiler.

	benchmarkSuite profileToGetStaticCallSites.
]

{ #category : 'tests' }
ProfilingStaticCallsTest >> testProfilingClass [
	
	
]
