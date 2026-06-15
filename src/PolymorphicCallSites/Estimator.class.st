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

{ #category : 'as yet unclassified' }
Estimator class >> estimateFrom: aFileName [
<script>
| files filesStoned |
files:= (FileSystem disk workingDirectory / aFileName ).

filesStoned := STON fromString: files  contents.
	^ self new estimateFromModel: filesStoned.
]

{ #category : 'as yet unclassified' }
Estimator class >> estimateFromBloc [
<script>
| files filesStoned |
files:= (FileSystem disk workingDirectory / 'trace-veritasbloc.ston' ).

filesStoned :=  STON fromString: files  contents.
	^ self new estimateFromModel: filesStoned .
]

{ #category : 'as yet unclassified' }
Estimator class >> estimateFromHG2 [
<script>
| files filesStoned |
files:= (FileSystem disk workingDirectory / '33VeritasHoneyGinger new run.ston' ).

filesStoned :=  STON fromString: files  contents.
	^ self new estimateFromModel: filesStoned .
]

{ #category : 'as yet unclassified' }
Estimator class >> estimateFromHGSimulator1 [
<script>
| files filesStoned |
files:= (FileSystem disk workingDirectory / 'NI2_HGSimulator impossibeRiverPressureMap.ston' ).

filesStoned :=  STON fromString: files  contents.
	^ self new estimateFromModel: filesStoned.
]

{ #category : 'as yet unclassified' }
Estimator class >> estimateFromMicroDownModel [
<script>
| files filesStoned |
files:= (FileSystem disk workingDirectory / 'NI2_HGSimulator impossibeRiverPressureMap.ston' ).

filesStoned :=  STON fromString: files  contents.
	^ self new estimateFromModel: TracingRawResult defaultInstance.
]

{ #category : 'as yet unclassified' }
Estimator class >> estimateFromStons [
<script>
| filesStoned estimator estimations |
filesStoned := ((FileSystem disk workingDirectory /'pharo-local'/'iceberg'/'fouziray'/'staticCallPharo') files select: [ :f | f extension = 'ston' ] ) collect: [:f | STON fromString: f  contents].
	
	estimator:=self new. 
	estimations :=filesStoned collect: [ :f | estimator estimateFromModel: f].
	estimations inspect.
]

{ #category : 'as yet unclassified' }
Estimator class >> estimateFromStonsInCurrentDir [
<script>
| filesStoned estimator estimations |
filesStoned := ((FileSystem disk workingDirectory / 'tracing' ) files select: [ :f | f extension = 'ston' ] ) collect: [:f | STON fromString: f  contents].
	
	estimator:=self new. 
	estimations :=filesStoned collect: [ :f | estimator estimateFromModel: f].
	estimations inspect.
]

{ #category : 'calcul' }
Estimator >> estimate: aTracingRawResult [ 
	
	| result sortedCallsFrequent frequentSelfMessages numberOfReceivers numberOfCallsToSelfPic totalGain program numberOfTotalCallsMONO numberOfTotalCallsPOLY numberOfTotalCallsMega |
	result := ProgramModel new
		          name: 'block'
		          fromRaw: [ 'aBlock' ] -> aTracingRawResult traceDict.
	
	program := ProgramResult for: result .	
	
	sortedCallsFrequent := (result callSites select: [ :e |
		                        (e dominantTypeWithThreshold: 80) isNotNil ])
		                       sorted: [ :a :b |
		                       a numberOfCalls > b numberOfCalls ].

	frequentSelfMessages := result callSites select: [ :c |
		                       c isSelfSend and:[ c numberOfReceiverClasses > 1]].
	numberOfReceivers := frequentSelfMessages sum:[:e | e numberOfReceiverClasses ].
	numberOfCallsToSelfPic := frequentSelfMessages sum:[:e | e numberOfCalls ].
1 halt.
	numberOfTotalCallsMONO := program .
	numberOfTotalCallsPOLY := program.
	numberOfTotalCallsMega := program.
	
	totalGain := numberOfCallsToSelfPic * 0.497. 
	
	^ ({  'potential copy downs :'-> numberOfReceivers . 'potential covered calls' -> numberOfCallsToSelfPic . 'potential gain' -> totalGain }) inspect

]

{ #category : 'calcul' }
Estimator >> estimateFromModel: aModel [ 
	
	| result sortedCallsFrequent frequentSelfMessages numberOfReceivers numberOfCallsToSelfPic totalGain program numberOfTotalCallsMONO numberOfTotalCallsPOLY numberOfTotalCallsMega |
	result := aModel. 
	
	program := ProgramResult for: result .	
	
	"sortedCallsFrequent := (result callSites select: [ :e |
		                        (e dominantTypeWithThreshold: 80) isNotNil ])
		                       sorted: [ :a :b |
		                       a numberOfCalls > b numberOfCalls ]."

	frequentSelfMessages := result callSites select: [ :c |
		                       c isSelfSend and:[ c numberOfReceiverClasses > 1]].
	numberOfReceivers := frequentSelfMessages sum:[:e | e numberOfReceiverClasses ].
	numberOfCallsToSelfPic := frequentSelfMessages sum:[:e | e numberOfCalls ].

	numberOfTotalCallsMONO := program numberOfMonoCalls "113913".
	numberOfTotalCallsPOLY := program numberOfPolyCalls "14010".
	numberOfTotalCallsMega := program numberOfMegaCalls "23130".
	
	totalGain := (numberOfTotalCallsMega + numberOfTotalCallsPOLY) * singleCallGain. 
	
	^ (   { aModel programName. 'numberOfTotalCallsMono'-> numberOfTotalCallsMONO . 'numberOfTotalCallsMega'-> numberOfTotalCallsMega . 'numberOfTotalCallsPoly'-> numberOfTotalCallsPOLY.  'potential copy downs :'-> numberOfReceivers . 'potential covered calls' -> numberOfCallsToSelfPic . 'potential gain' -> totalGain }) 

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
