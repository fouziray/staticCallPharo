Class {
	#name : 'FindingStatsTest',
	#superclass : 'TestCase',
	#category : 'PolymorphicCallSites-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Objects'
}

{ #category : 'tests' }
FindingStatsTest >> callSiteMulitpleTarget [
	"self new callSiteMulitpleTarget"
		
	| dict  |
	dict := Dictionary new. 
	dict 
		at: Fraction>>#asFloat
		put: (Bag newFrom: { (1/2)class . (1/2)class . (1/2)class  }). 
	dict 
		at: Float>>#asFloat
		put: (Bag newFrom: { (0.2)class . (2.3)class   }).
	^ CallSiteModel fromRaw: (FindingStatsTest >>#polyCallClass) ast sendNodes second ->  dict

]

{ #category : 'tests' }
FindingStatsTest >> callSiteMulitpleTargetWithHighDominance [
	"self new callSiteMulitpleTarget"
		
	| dict  |
	dict := Dictionary new. 
	dict 
		at: Fraction>>#asFloat
		put: (Bag newFrom: { (1/2)class . (1/2)class . (1/2)class.(1/2)class .  (1/2)class . (1/2)class . (1/2)class.(1/2)class . (1/2)class. (1/2)class .}). 
	dict 
		at: Float>>#asFloat
		put: (Bag newFrom: { (0.2)class . (2.3)class   }).
	^ CallSiteModel fromRaw: (FindingStatsTest >>#polyCallClass) ast sendNodes second ->  dict

]

{ #category : 'tests' }
FindingStatsTest >> callSiteOne [
	"self new callSiteOne"
		
	| dict  |
	dict := Dictionary new. 
	dict 
		at: ProtoObject>>#class
		put: (Bag newFrom: { Object. Object. SmallInteger }). 
	^ CallSiteModel fromRaw: (FindingStatsTest >>#classCall) ast sendNodes first ->  dict

]

{ #category : 'as yet unclassified' }
FindingStatsTest >> classCall [

	Object new class
]

{ #category : 'as yet unclassified' }
FindingStatsTest >> classCallTwice [

	Object new class.
	
	self callSiteOne.
	
	4 class.
]

{ #category : 'as yet unclassified' }
FindingStatsTest >> polyCallClass [
"pay attention that types here are examples and just used to access message node for test setup"
	{1/2 . 4/5. 2.66 } do: #asFloat
]

{ #category : 'tests' }
FindingStatsTest >> testCallSiteCreationWithoutMessageNOde [

	
	| dict |
	dict := Dictionary new.
	dict at: ProtoObject >> #class put: (Bag newFrom: {
				 (1 / 2) class.
				 (1 / 2) class.
				 (1 / 2) class }).
	dict at: Float >> #asFloat put: (Bag newFrom: {
				 0.2 class.
				 2.3 class }).
	CallSiteModel fromRaw:
		  (FindingStatsTest >> #classCallTwice) ast sendNodes second -> dict.
	
"	self
		assert: (m ast pcsForNode: m ast sendNodes first) first
		equals: 59.
	self
		assert: m ast sendNodes first callSiteName
		equals: 'FindingStatsTest>>#classCallTwice !59'
	""    nodeOffsets := m symbolic.
"""
]

{ #category : 'tests' }
FindingStatsTest >> testFindingDominantType [
	
	self 
		assert: self callSiteOne dominantType 
		equals: 'Object class'
]

{ #category : 'tests' }
FindingStatsTest >> testFindingDominantTypeAboveThreshold [

	self
		assert: (self callSiteMulitpleTargetWithHighDominance dominantTypeWithThreshold:80) isNotNil.
		
]

{ #category : 'tests' }
FindingStatsTest >> testFindingDominantTypePoly [

	self
		assert: self callSiteMulitpleTarget dominantType
		equals: 'Fraction class'
]

{ #category : 'tests' }
FindingStatsTest >> testMessageIntoItsCallerAndBCOffset [

	| m node |
	m := FindingStatsTest >> #classCallTwice.
	node := m ast sendNodes first.
	self
		assert: (m ast pcsForNode: node) first
		equals: 59.
	self
		assert: node callSiteName
		equals: 'FindingStatsTest>>#classCallTwice !59'
	"    nodeOffsets := m symbolic.
"
]

{ #category : 'tests' }
FindingStatsTest >> testMessageIntoItsCallerAndBCOffsetTwo [

	| m node |
	
	m := FindingStatsTest >> #classCallTwice.
	node := m ast sendNodes fourth.
	self assert: node selector equals: #class.
	self
		assert: (m ast pcsForNode: node) first
		equals: 65.
	self
		assert: node callSiteName
		equals: 'FindingStatsTest>>#classCallTwice !65'
	"    nodeOffsets := m symbolic.
"
]

{ #category : 'tests' }
FindingStatsTest >> testNumberOfReceiverClasses [

	self
		assert: self callSiteMulitpleTarget numberOfReceiverClasses
		equals: 2
]
