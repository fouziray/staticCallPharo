Class {
	#name : 'CopyDownCostTest',
	#superclass : 'TestCase',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'running' }
CopyDownCostTest >> tearDown [ 
	
]

{ #category : 'tests' }
CopyDownCostTest >> testCopyDownProgram [

	CopyDownCost forProgram: [
		[
		| simulator |
		simulator := HGSimulator impossibeRiverPressureMap.
		1 timesRepeat: [ World doOneCycle ].
		simulator ] value ]
]
