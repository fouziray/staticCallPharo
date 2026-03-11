Class {
	#name : 'ProgramResult',
	#superclass : 'Object',
	#instVars : [
		'originalData',
		'programName',
		'numberCallSites',
		'numberCalls',
		'numberOfMonoCallSites',
		'numberOfPolyCallSites',
		'numberOfMegaCallSites',
		'numberOfMonoCalls',
		'numberOfPolyCalls',
		'numberOfMegaCalls',
		'spuriousCallSites',
		'spuriousPolySites',
		'spuriousMegaSites',
		'spuriousCalls',
		'spuriousPolyCalls',
		'spuriousMegaCalls',
		'numberOfSingleImplementationPoly',
		'numberOfSingleImplementationMega'
	],
	#category : 'PolymorphicCallSites-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Objects'
}

{ #category : 'instance creation' }
ProgramResult class >> for: anAssociation [ 
	
	^ self new
		initializeFor: anAssociation;
		yourself 
]

{ #category : 'as yet unclassified' }
ProgramResult >> assertData [

	self assert: numberCallSites = (numberOfMonoCallSites + numberOfPolyCallSites + numberOfMegaCallSites).
	self assert: numberCalls = (numberOfMonoCalls + numberOfPolyCalls + numberOfMegaCalls).
	self assert: spuriousCallSites = (spuriousMegaSites + spuriousPolySites).
	self assert: spuriousCalls = (spuriousMegaCalls + spuriousPolyCalls).
	
]

{ #category : 'as yet unclassified' }
ProgramResult >> calculateCalls [

	numberCallSites := self callSites size.

	numberOfMonoCallSites := self
		                         monoCallSites
		                         size.

	numberOfPolyCallSites := self
		                         polyCallSites
		                         size.

	numberOfMegaCallSites := self
		                         megaCallSites
		                         size.

	numberCalls := self callSites sum: [ :e |
		               self numberOfCallsFor: e ].
	numberOfMonoCalls := self monoCallSites
		                     sum: [ :e |
		                     self
			                     numberOfCallsFor:
			                     e ].
	numberOfPolyCalls := self polyCallSites
		                     sum: [ :e |
		                     self
			                     numberOfCallsFor:
			                     e ].
	numberOfMegaCalls := self megaCallSites
		                     sum: [ :e |
		                     self
			                     numberOfCallsFor:
			                     e ].
	numberOfSingleImplementationPoly:= self polyCallSitesSingleImplementation size.
	numberOfSingleImplementationMega := self megaCallSitesSingleImplementation size.
]

{ #category : 'as yet unclassified' }
ProgramResult >> calculateData [

	self calculateCalls.
	self calculateSpurious
]

{ #category : 'as yet unclassified' }
ProgramResult >> calculateSpurious [
	
	spuriousCallSites := self callSites count: [ :e | self isSpurious: e ].
	spuriousPolySites := self polyCallSites count: [ :e | self isSpurious: e ].
	spuriousMegaSites := self megaCallSites count: [ :e | self isSpurious: e ].
	
	spuriousCalls := (self callSites select: [ :e | self isSpurious: e ]) sum: [ :e | self numberOfCallsFor: e ].
	spuriousPolyCalls := (self polyCallSites select: [ :e | self isSpurious: e ]) sum: [ :e | self numberOfCallsFor: e ].
	spuriousMegaCalls := (self megaCallSites select: [ :e | self isSpurious: e ]) sum: [ :e | self numberOfCallsFor: e ].	
]

{ #category : 'accessing' }
ProgramResult >> callSites [

	^ originalData callSites
]

{ #category : 'initialization' }
ProgramResult >> initializeFor: aProgramModel [ 
	
	originalData := aProgramModel.
	programName := aProgramModel programName.
	
	self calculateData.
	self assertData
]

{ #category : 'testing' }
ProgramResult >> isMegaMorphicCallSite: aCollection [ 
	
	^ (self numberOfReceiverClasses: aCollection) > 6
]

{ #category : 'testing' }
ProgramResult >> isMonoMorphicCallSite: aCollection [ 
	
	^ (self numberOfReceiverClasses: aCollection) = 1
]

{ #category : 'testing' }
ProgramResult >> isPolyMorphicCallSite: aCollection [ 

	| value |
	value := (self numberOfReceiverClasses: aCollection).

	^ value > 1 and: [ value < 7 ]
]

{ #category : 'testing' }
ProgramResult >> isSpurious: aCallSiteModel [ 
	
	^ (self isMonoMorphicCallSite: aCallSiteModel) not and: [ aCallSiteModel numberOfDifferentMethods = 1 ] 
]

{ #category : 'as yet unclassified' }
ProgramResult >> megaCallSites [

	^ (self callSites select: [:e | self isMegaMorphicCallSite: e])
]

{ #category : 'as yet unclassified' }
ProgramResult >> megaCallSitesSingleImplementation [

	^ (self megaCallSites select: [:e | e selector ifNotNil:[:e | e asSymbol implementors size =1  ]ifNil:[false]])
]

{ #category : 'as yet unclassified' }
ProgramResult >> monoCallSites [

	^ (self callSites select: [:e | self isMonoMorphicCallSite: e])
]

{ #category : 'as yet unclassified' }
ProgramResult >> numberOfCallsFor: aCallSiteModel [ 
	
	^ aCallSiteModel numberOfCalls 
]

{ #category : 'as yet unclassified' }
ProgramResult >> numberOfReceiverClasses: aCallSiteModel [ 
	
	^ aCallSiteModel numberOfReceiverClasses
]

{ #category : 'as yet unclassified' }
ProgramResult >> polyCallSites [

	^ (self callSites select: [:e | self isPolyMorphicCallSite: e])
]

{ #category : 'as yet unclassified' }
ProgramResult >> polyCallSitesSingleImplementation [

	^ (self polyCallSites select: [:e | e selector ifNotNil:[:e | e asSymbol implementors size =1 ] ifNil:[false]]) 
]

{ #category : 'printing' }
ProgramResult >> printOn: aStream [

                              "super printOn: aStream."
						
                               aStream
											nextPutAll: programName ;
                                  nextPutAll: ' & ';
                                  nextPutAll: numberCallSites asString;
                                  nextPutAll: ' & ';
                                  nextPutAll:
                                     numberOfMonoCallSites asString;
                                  nextPutAll: ' & ';
                                  nextPutAll:
                                     numberOfPolyCallSites asString ,' (', numberOfSingleImplementationPoly asString ,')';
                                  nextPutAll: ' & ';
                                  nextPutAll:
                                     numberOfMegaCallSites asString,' (',numberOfSingleImplementationMega asString ,')';
                                  nextPutAll: ' & ';
                                  nextPutAll:
                                     spuriousCallSites asString;
                                  nextPutAll: ' & ';
                                  nextPutAll:
                                     ((spuriousCalls / numberCalls
                                      * 100) asFloat round:2) asString;
                                  nextPutAll: '\\ ';
                                  nextPutAll: ' '
]
