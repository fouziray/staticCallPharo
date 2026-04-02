Class {
	#name : 'MatrixSiteType',
	#superclass : 'Object',
	#instVars : [
		'matrixRowLabels',
		'values',
		'name'
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
	matrixRowLabels :=  (values collectAsSet: #keys) flattened.
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

{ #category : 'transformation' }
MatrixSiteType >> rowFrequenciesFor: aCollection [ 
	| typeFrequencies row |
	typeFrequencies := aCollection flattened asBag asDictionary. "fusing different methods types, then collecting their freq"
	row := Dictionary new.
	matrixRowLabels do:[:key | row at: key  put: (typeFrequencies at: key ifPresent: [:v|v]  ifAbsent:[0] ) ].
	
	^ row
]
