Class {
	#name : 'LongestSequenceFrequentType',
	#superclass : 'PicPatternVisual',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'divide' }
LongestSequenceFrequentType >> partitionIntoSublists: aCollectionOfCallSiteModels usingBins: bins [ 

    ^ bins allButLast collectWithIndex: [ :val1 :index |
        | val2 condition |
        val2 := bins at: index + 1.
        condition := index + 1 = bins size
            ifTrue: [ [ :value | value  between: val1 and: val2 ] ]
            ifFalse: [ [ :value | val1 <= value  and: [ value  < val2 ] ] ].
        aCollectionOfCallSiteModels select: condition
    ]
]

{ #category : 'plot' }
LongestSequenceFrequentType >> plotSwitchRatio: aCollection [ 
	| c plot |
	"
	To interpret this histogram take into consideration the following rule to calculate the ratio
	--> switchCounter / aCallSite numberOfCalls
	This means, higher ratio means more switches --> unstable pics. Less ration is proof of low switch rate.
	"
	
	c := RSCompositeChart new.
	plot := RSHistogramPlot new x: (aCollection ) .
	c add: plot.
	c title: 'Histogram Of ratio of switch X number of callsites'.
	^ c
]

{ #category : 'plot' }
LongestSequenceFrequentType >> plotSwitchRatioWithCallNum: aCollection fromTotalCalls: aTotalCallNumber [

	| composite hist |
	composite := self plotSwitchRatio: aCollection flattened.
	composite build.


	hist := composite plots first.
	hist bars doWithIndex: [ :bar :i |
		| label value |
		value := ((((aCollection at: i) sum: [ :e | e numberOfCalls ])
		         / aTotalCallNumber) * 100) asFloat .
		label := RSLabel new
			         text: (value printShowingDecimalPlaces: 1) , '%';
			         color: Color black;
			         yourself.

		label translateTo:
			bar position + (0 @ (bar height / 2 + 10) negated).
		composite canvas add: label ].
	composite canvas signalUpdate.
	^ composite canvas
]

{ #category : 'plot' }
LongestSequenceFrequentType >> plotSwitchRatioWithCallNum: aCollection fromTotalCalls: aTotalCallNumber withLongestSequence: aSequence [

	| composite hist |
1 halt.
	composite := self plotSwitchRatio: aSequence.
	composite build.


	hist := composite plots first.
	hist bars doWithIndex: [ :bar :i |
		| label value |
		value := ((((aCollection at: i) sum: [ :e | e numberOfCalls ])
		         / aTotalCallNumber) * 100) asFloat .
		label := RSLabel new
			         text: (value printShowingDecimalPlaces: 1) , '%';
			         color: Color black;
			         yourself.

		label translateTo:
			bar position + (0 @ (bar height / 2 + 10) negated).
		composite canvas add: label ].
	composite canvas signalUpdate.
	^ composite canvas
]
