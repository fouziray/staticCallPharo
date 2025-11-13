Class {
	#name : 'PTOSVeritasBench',
	#superclass : 'BasicMicroDownBench',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'benchmarking' }
PTOSVeritasBench class >> runOnce [

	VeritasDataFrame new run
]
