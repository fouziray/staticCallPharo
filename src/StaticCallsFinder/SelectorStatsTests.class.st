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
	|expectedStats|
	PackageOrganizer default packageNamesDo: [ :e | 
	expectedStats := statisticsClass devirtualizableCallSitesOfPackage:
		(PackageOrganizer default packageNamed: e).
		self assert: expectedStats values flattened size isZero . 
	
		].
]

{ #category : 'tests' }
SelectorStatsTests >> testDevirtualizableCallSitesBySpecificScenario [
	"select a running scenario, 
		construct a static call graph in relation to the self variables.
		When looking at the call sites implementations take into consideration the call tree.
		How: do Union of all classes in the nodes of the tree, then implementors needs to be amongst this set (or in their super classes ?).
		
		"
]
