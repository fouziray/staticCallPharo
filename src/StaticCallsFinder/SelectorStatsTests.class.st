Class {
	#name : 'SelectorStatsTests',
	#superclass : 'TestCase',
	#instVars : [
		'statisticsClass'
	],
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'running' }
SelectorStatsTests >> setUp [ 
 
	statisticsClass:= SelectorsStats new.

]

{ #category : 'tests' }
SelectorStatsTests >> testDevirtualizableCallSitesByPackage [
	|expectedStats|
	expectedStats := statisticsClass devirtualizableCallSitesOfPackage:
		(PackageOrganizer default packageNamed: #StaticCallsFinder).
		self assert: expectedStats values flattened size isZero .
]

{ #category : 'tests' }
SelectorStatsTests >> testDevirtualizableCallSitesByPackage2 [
	|expectedStats resultsByPack|
	resultsByPack := Dictionary new.
	
	PackageOrganizer default packageNamesDo: [ :e | 
	
	expectedStats := statisticsClass devirtualizableCallSitesOfPackage:
		(PackageOrganizer default packageNamed: e).
		expectedStats values flattened size isZero ifFalse: [  resultsByPack at: e put:  expectedStats values flattened ].
		 
	
		].
	self assert: resultsByPack values flattened size isZero.
]

{ #category : 'tests' }
SelectorStatsTests >> testDevirtualizableCallSitesBySpecificScenario [
	"select a running scenario, 
		construct a static call graph in relation to the self variables.
		When looking at the call sites implementations take into consideration the call tree.
		How: do Union of all classes in the nodes of the tree, then implementors needs to be amongst this set (or in their super classes ?).
		
		"
]

{ #category : 'tests' }
SelectorStatsTests >> testDevirtualizableSmallExample [

	| tempClass instance result |
	tempClass := Object classInstaller make: [ :builder |
		             builder
			             superclass: Object;
			             name: #DevirtCallFixture;
			             slotsFromString: '';
			             sharedVariablesFromString: '';
			             package: 'StaticCallsFinder';
			             environment: Object environment ].

	tempClass compile: 'foufou
    ^ 42'.
	tempClass compile: 'callDevirtualizable
    ^ self foufou '.


	[
	| expectedStats resultsByPack |
	resultsByPack := Dictionary new.

	expectedStats := statisticsClass devirtualizableCallSitesForMethods:
		                 { (tempClass methodNamed: #callDevirtualizable) }.
	self
		assert: expectedStats values flattened first selector 
		equals: #foufou ] ensure: [
		tempClass removeFromSystem ]
]
