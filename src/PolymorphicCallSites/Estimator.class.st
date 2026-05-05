Class {
	#name : 'Estimator',
	#superclass : 'Object',
	#instVars : [
		'singleCallGain'
	],
	#category : 'PolymorphicCallSites-CopyDowner',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDowner'
}

{ #category : 'as yet unclassified' }
Estimator class >> estimate [
<script>
	^ self new estimate: TracingRawResult defaultInstance.
]

{ #category : 'calcul' }
Estimator >> estimate: aTracingRawResult [ 
	
	| result sortedCallsFrequent frequentSelfMessages numberOfReceivers numberOfCalls NumberOfCallsForSubclasses totalGain |
	result := ProgramModel new
		          name: 'block'
		          fromRaw: [ 'aBlock' ] -> aTracingRawResult traceDict.
	aTracingRawResult.	
	sortedCallsFrequent := (result callSites select: [ :e |
		                        (e dominantTypeWithThreshold: 80) isNotNil ])
		                       sorted: [ :a :b |
		                       a numberOfCalls > b numberOfCalls ].

	frequentSelfMessages := sortedCallsFrequent select: [ :c |
		                       c isSelfSend and:[ c numberOfReceiverClasses > 1]].
	numberOfReceivers :=frequentSelfMessages sum:[:e | e numberOfReceiverClasses ].
	numberOfCalls := frequentSelfMessages sum:[:e | e numberOfCalls ].
	totalGain := numberOfCalls * 0.497. 
	^ ({  'potential copy downs :'-> numberOfReceivers . 'potential covered calls' -> numberOfCalls . 'potential gain' -> totalGain }) inspect

]

{ #category : 'initialization' }
Estimator >> initialize [ 
	
	singleCallGain := 0.497 "nano seconds"
	
	"How do we calculate it ?
	temps call poly - temps call mono
	in our example we had 64 * 20 000 call 
	we get individual call overhead. 
	"
]
