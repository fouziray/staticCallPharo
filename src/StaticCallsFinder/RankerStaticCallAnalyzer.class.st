Class {
	#name : 'RankerStaticCallAnalyzer',
	#superclass : 'StaticCallAnalyzer',
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'printing' }
RankerStaticCallAnalyzer >> printStatisticsFor: candidate on: stream [

	^ stream
		  nextPutAll: ' (confidence: ';
		  nextPutAll: (candidate confidence * 100) rounded asString;
		  nextPutAll: '%, benefit: ';
		  nextPutAll: candidate benefit rounded asString;
		  nextPutAll: ')';
		  cr
]

{ #category : 'as yet unclassified' }
RankerStaticCallAnalyzer >> rankCandidates: candidates forMethod: aMethod [ 
	"Rank candidates by potential performance benefit"
	^( candidates collect: [ :candidate |
		candidate
			confidence: (self calculateConfidence: candidate);
			benefit: (self calculateBenefit: candidate);
			yourself
	]) sort: [ :a :b | a benefit > b benefit ].
]
