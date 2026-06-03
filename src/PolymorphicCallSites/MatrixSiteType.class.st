Class {
	#name : 'MatrixSiteType',
	#superclass : 'Object',
	#instVars : [
		'matrixRowLabels',
		'values',
		'name',
		'programModel'
	],
	#category : 'PolymorphicCallSites-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Objects'
}

{ #category : 'as yet unclassified' }
MatrixSiteType class >> matrixProgram: aProgramModel [ 
	^ self new intializeWith:aProgramModel .
]

{ #category : 'as yet unclassified' }
MatrixSiteType >> intializeWith: aProgramModel [ 
	
	| siteTypesFrequencies |
	
	values := OrderedDictionary new.
	
	
	aProgramModel callSites do:#fetchSelector.
	
	aProgramModel  callSites reject:[:site| { #ifTrue:ifFalse: . #ifFalse:ifTrue: .#ifFalse: . #ifTrue:. #ifEmpty. } includes: site selector ].
	siteTypesFrequencies := aProgramModel  callSites collect: [ :e | e receiverTypesBag ].
	matrixRowLabels := siteTypesFrequencies flattened asSet.
	
	name := aProgramModel programName.
		
	siteTypesFrequencies doWithIndex:[:e :i| values at: i put:( self rowFrequenciesFor: e)].
	matrixRowLabels :=  (values collect: #keys) values first .
	self numpyFormat.
]

{ #category : 'export' }
MatrixSiteType >> numpyFormat [

| matrix rowLabels colLabels stream |

matrix :=  values collect:#values.
rowLabels := values keys .
colLabels := matrixRowLabels.

stream := WriteStream on: String new.

"Header row"
stream nextPutAll: ','.  "empty top-left cell"
colLabels doWithIndex: [:col :i |
    stream nextPutAll: col.
    i < colLabels size ifTrue: [stream nextPutAll: ',']].
stream nextPut: Character cr.

"Data rows with label"
matrix doWithIndex: [:row :ri |
    stream nextPutAll: (rowLabels at: ri) asString.
    stream nextPutAll: ','.
    row doWithIndex: [:val :ci |
        stream nextPutAll: val printString.
        ci < row size ifTrue: [stream nextPutAll: ',']].
    stream nextPut: Character cr.].

('typeFreqNoInlinedMsg_', name ,'.csv') asFileReference writeStreamDo: [:f |
    f nextPutAll: stream contents].

"```


Output:
```
,col1,col2,col3
row1,1,2,3
row2,4,5,6
row3,7,8,9"
]

{ #category : 'export' }
MatrixSiteType >> octaveFormat [

| matrix rowLabels colLabels stream |

matrix :=  values collect:#values.
rowLabels := values keys .
colLabels := matrixRowLabels.

stream := WriteStream on: String new.

"Header row"
stream nextPutAll: ','.  "empty top-left cell"
colLabels doWithIndex: [:col :i |
    stream nextPutAll: col.
    i < colLabels size ifTrue: [stream nextPutAll: ',']].
stream nextPut: Character cr.

"Data rows with label"
matrix doWithIndex: [:row :ri |
    stream nextPutAll: (rowLabels at: ri) asString.
    stream nextPutAll: ','.
    row doWithIndex: [:val :ci |
        stream nextPutAll: val printString.
        ci < row size ifTrue: [stream nextPutAll: ',']].
    stream nextPut: Character cr.].
^ stream contents
"('typeFreqNoInlinedMsg_', name ,'.csv') asFileReference writeStreamDo: [:f |
    f nextPutAll: stream contents].
"
"```


Output:
```
,col1,col2,col3
row1,1,2,3
row2,4,5,6
row3,7,8,9"
]

{ #category : 'export' }
MatrixSiteType >> octaveFormat: aProgramModel [ 

	| stream callNumber|
	stream := WriteStream on: String new.
	stream nextPutAll: 'callsite_id,call_number,type_observed,depth, selector, callerMethod'.
	stream nextPut: Character cr.
	callNumber :=0.
	aProgramModel callSites doWithIndex: [ :callSite :index|
		| siteId |
		siteId := index asString .
		
		callSite typesPattern do: [ :type  |
				callNumber := callNumber +1.
				stream nextPutAll: siteId; nextPutAll: ','.
				stream print: callNumber; nextPutAll: ','.
				stream nextPutAll: type; nextPutAll: ','.
				stream print: callSite depth;nextPutAll: ','.
				stream nextPutAll: callSite selector;nextPutAll:','.
				stream nextPutAll: callSite methodName.
				stream nextPut: Character cr ] ] .


	('octave_', aProgramModel programName , '.csv') asFileReference
		writeStreamDo: [ :f | f nextPutAll: stream contents ]

]

{ #category : 'as yet unclassified' }
MatrixSiteType >> octaveFromProgram: aProgramModel [ 
	
	programModel:= aProgramModel .
	^ self octaveFormat 
]

{ #category : 'transformation' }
MatrixSiteType >> rowFrequenciesFor: aCollection [ 
	| typeFrequencies row |
	typeFrequencies := aCollection flattened asBag asDictionary. "fusing different methods types, then collecting their freq"
	row := Dictionary new.
	matrixRowLabels do:[:key | row at: key  put: (typeFrequencies at: key ifPresent: [:v|v]  ifAbsent:[0] ) ].
	
	^ row
]
