Class {
	#name : 'CopyDownCostTest',
	#superclass : 'TestCase',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'tests' }
CopyDownCostTest >> testCopyDownProgram [

	CopyDownCost forProgram: [[
	   | simulator |
	   simulator := HGSimulator impossibeRiverPressureMap.
	   0 timesRepeat: [ World doOneCycle ].
	   simulator ] value].
]
