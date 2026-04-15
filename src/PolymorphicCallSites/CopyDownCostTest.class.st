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

	| copier |
	copier := CopyDownCost forProgram: [
		[
		| simulator |
		simulator := HGSimulator impossibeRiverPressureMap.
		0 timesRepeat: [ World doOneCycle ].
		simulator ] value ].
self assert: copier insertedMethods size equals: 5 .

]

{ #category : 'tests' }
CopyDownCostTest >> testCopyDownProgramElements [

	| copier |
	copier := CopyDownCost forProgram: [
		          [
		          | simulator |
		          simulator := HGSimulator impossibeRiverPressureMap.
		          0 timesRepeat: [ World doOneCycle ].
		          simulator ] value ].
1 halt.
	self
		assert: copier insertedMethods first callSite dominantType
		equals: 'IdentityDictionary class' "Or something else because i have not removed some copied stuff"
]
