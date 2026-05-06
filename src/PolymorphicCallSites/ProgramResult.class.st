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
		'numberOfSingleImplementationMega',
		'disparities'
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

	numberOfMonoCallSites := self monoCallSites size.

	numberOfPolyCallSites := self polyCallSites size.

	numberOfMegaCallSites := self megaCallSites size.

	numberCalls := self callSites sum: [ :e | self numberOfCallsFor: e ].
	numberOfMonoCalls := self monoCallSites sum: [ :e |
		                     self numberOfCallsFor: e ].
	numberOfPolyCalls := self polyCallSites sum: [ :e |
		                     self numberOfCallsFor: e ].
	numberOfMegaCalls := self megaCallSites sum: [ :e |
		                     self numberOfCallsFor: e ].

"	numberOfSingleImplementationPoly := self
		                                    polyCallSitesSingleImplementation
		                                    size.
	numberOfSingleImplementationMega := self
		                                    megaCallSitesSingleImplementation
		                                    size"
]

{ #category : 'as yet unclassified' }
ProgramResult >> calculateData [

	self calculateCalls.
	self calculateSpurious
]

{ #category : 'properties' }
ProgramResult >> calculateInlineCacheIndividualCalls [
	| spurious |
	spurious:= self callSites select: [:e| self isSpurious: e].
	spurious collect:#receiverClassesFrequency.
	disparities:= spurious  collect: #findDisparities

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

{ #category : 'accessing' }
ProgramResult >> disparities [
	^ ((self callSites collect:[:e |
		e -> e disparity ] )select:[:e | e value isNotNil]) sortDescending: #value
]

{ #category : 'printing' }
ProgramResult >> generateLatexOn1: aStream [
	"super printOn: aStream."

	self putLatex: programName on: aStream. self nextFieldOn: aStream.
	self putLatex: numberCallSites asStringWithCommas on: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfMonoCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfPolyCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfMegaCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.

	self putLatexWithPercentage: spuriousCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: spuriousPolySites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: spuriousMegaSites total: numberCallSites On: aStream. self nextRowOn: aStream.

]

{ #category : 'printing' }
ProgramResult >> generateLatexOn2: aStream [
	"super printOn: aStream."

	self putLatex: programName on: aStream. self nextFieldOn: aStream.

	self putLatex: numberCalls  asStringWithCommas on: aStream. self nextFieldOn: aStream.
	self putPercentage: numberOfMonoCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putPercentage: numberOfPolyCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putPercentage: numberOfMegaCalls total: numberCalls On: aStream. self nextFieldOn: aStream.

	self putPercentage: spuriousCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putPercentage: spuriousPolyCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putPercentage: spuriousMegaCalls total: numberCalls On: aStream. self nextRowOn: aStream.
	
]

{ #category : 'printing' }
ProgramResult >> generateLatexOn: aStream [
	"super printOn: aStream."

	self putLatex: programName on: aStream. self nextFieldOn: aStream.
	self putLatex: numberCallSites on: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfMonoCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfPolyCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfMegaCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.

	self putLatexWithPercentage: spuriousCallSites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: spuriousPolySites total: numberCallSites On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: spuriousMegaSites total: numberCallSites On: aStream. self nextFieldOn: aStream.

	self putLatex: numberCalls on: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfMonoCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfPolyCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: numberOfMegaCalls total: numberCalls On: aStream. self nextFieldOn: aStream.

	self putLatexWithPercentage: spuriousCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: spuriousPolyCalls total: numberCalls On: aStream. self nextFieldOn: aStream.
	self putLatexWithPercentage: spuriousMegaCalls total: numberCalls On: aStream. self nextRowOn: aStream.
	
]

{ #category : 'as yet unclassified' }
ProgramResult >> graphs [

	| full c p p2 x y size intervalCallsites threshold|
	threshold := 0.5.
	intervalCallsites := OrderedDictionary new.
 full:= (self callSites collect:[:e | e -> e disparity  ]) sorted: [ :a :b | a key numberOfCalls > b key numberOfCalls ].
	x := 0 to: full first key numberOfCalls count: 10.
	y := full do:[:value |
    x doWithConsecutivePairs: [:e :b | (e < value key numberOfCalls  and: [ b > value key numberOfCalls ] ) ifTrue: [  intervalCallsites at: { e. b } ifPresent: [ :col | col add: value value ] ifAbsentPut: [OrderedCollection new]]]].
y:= intervalCallsites values collect:#size.
	c := RSCompositeChart new.
	p := RSBarPlot new x: x y: {0.y.0} flattened.
	size := 6.
	p barSize: size.
	p barOffset: size / 2.
	p2 := RSBarPlot new x: x y:{ 0. (intervalCallsites values collect: [:e |  (e select:[:e | e > threshold ]) size]). 0
} flattened.
	p2 barSize: size.
	p2 barOffset: size / -2.
	c add: p.
	c add: p2.
	c horizontalTick doNotUseNiceLabel;
			 numberOfTicks: x size - 1;
			 asFloat: 5;
			 useVerticalLabel.

	c build.
	p bars @ RSPopup.

	p2 bars
		when: RSMouseEnter
		do: [ :evt |
			| color |
			color := Color random.
			p2 bars do: [ :shape | shape color: color ].
			evt signalUpdate ]
		for: self.
		1 halt.
		
	^ c canvas
]

{ #category : 'initialization' }
ProgramResult >> initializeFor: aProgramModel [ 

	originalData := aProgramModel.
	programName := aProgramModel programName.

	self calculateData.
	self calculateInlineCacheIndividualCalls.
	self assertData.
"	self graphs."
	"MatrixSiteType matrixProgram: aProgramModel ."
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
ProgramResult >> nextFieldOn: aWriteStream [ 
	
	aWriteStream nextPutAll: ' & '
]

{ #category : 'as yet unclassified' }
ProgramResult >> nextRowOn: aWriteStream [ 
	
	aWriteStream 
		nextPutAll: ' \\ ';
		crlf
]

{ #category : 'as yet unclassified' }
ProgramResult >> numberOfCallsFor: aCallSiteModel [ 
	
	^ aCallSiteModel numberOfCalls 
]

{ #category : 'accessing' }
ProgramResult >> numberOfMegaCalls [

	^ numberOfMegaCalls
]

{ #category : 'accessing' }
ProgramResult >> numberOfMegaCalls: anObject [

	numberOfMegaCalls := anObject
]

{ #category : 'accessing' }
ProgramResult >> numberOfMonoCalls [

	^ numberOfMonoCalls
]

{ #category : 'accessing' }
ProgramResult >> numberOfMonoCalls: anObject [

	numberOfMonoCalls := anObject
]

{ #category : 'accessing' }
ProgramResult >> numberOfPolyCalls [

	^ numberOfPolyCalls
]

{ #category : 'accessing' }
ProgramResult >> numberOfPolyCalls: anObject [

	numberOfPolyCalls := anObject
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
		nextPutAll: programName;
		nextPutAll: ' & ';
		nextPutAll: numberCallSites asString;
		nextPutAll: ' & ';
		nextPutAll: numberOfMonoCallSites asString;
		nextPutAll: ' & ';
		nextPutAll: numberOfPolyCallSites asString , ' ('
			, numberOfSingleImplementationPoly asString , ')';
		nextPutAll: ' & ';
		nextPutAll: numberOfMegaCallSites asString , ' ('
			, numberOfSingleImplementationMega asString , ')';
		nextPutAll: ' & ';
		nextPutAll: spuriousCallSites asString;
		nextPutAll: ' & ';
		nextPutAll:
			((spuriousCalls / numberCalls * 100) asFloat round: 2) asString;
		nextPutAll: '\\ ';
		nextPutAll: ' '
]

{ #category : 'accessing' }
ProgramResult >> programName [
	^ programName
]

{ #category : 'as yet unclassified' }
ProgramResult >> putLatex: anObject on: aWriteStream [ 
	
	aWriteStream nextPutAll: anObject asString
]

{ #category : 'as yet unclassified' }
ProgramResult >> putLatexWithPercentage: aValue total: total On: aWriteStream [ 
	
	aWriteStream 
		nextPutAll: aValue asStringWithCommas;
		nextPutAll: '~( ' ;
		nextPutAll: ((aValue / total * 100.0) round: 2) asString;
		nextPutAll: ' \%)'
		
]

{ #category : 'as yet unclassified' }
ProgramResult >> putPercentage: aValue total: total On: aWriteStream [ 
	
	aWriteStream 
		nextPutAll: ((aValue / total * 100.0) round: 2) asString;
		nextPutAll: ' \%'
		
]

{ #category : 'as yet unclassified' }
ProgramResult >> spuriousCallSites [ 

	^ spuriousCallSites
]
