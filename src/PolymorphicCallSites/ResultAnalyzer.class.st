Class {
	#name : 'ResultAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'programs'
	],
	#category : 'PolymorphicCallSites-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Objects'
}

{ #category : 'testing' }
ResultAnalyzer class >> analyze: aCollection [ 
	
	^ self new 
		analyze: aCollection;
		yourself
]

{ #category : 'adding' }
ResultAnalyzer >> addColumnName: anObject on: aWriteStream [ 

	aWriteStream 
		nextPutAll: '\rotatebox{90}{\thead{';
		nextPutAll: anObject asString;
		nextPutAll: '}}'
]

{ #category : 'testing' }
ResultAnalyzer >> analyze: aResultModel [

  programs := aResultModel programs collect: [ :e | ProgramResult for: e ]
]

{ #category : 'as yet unclassified' }
ResultAnalyzer >> generateLatex [

	^ String streamContents: [ :s |
			self generateLatexTableHeader: s.
		  (programs sorted: [ :a :b | a programName < b programName ]) do: [
			  :e | e generateLatexOn: s ] ]
]

{ #category : 'as yet unclassified' }
ResultAnalyzer >> generateLatex1 [

	^ String streamContents: [ :s |
			self generateLatexTableHeader1: s.
		  (programs sorted: [ :a :b | a programName < b programName ]) do: [
			  :e | e generateLatexOn1: s ] ]
]

{ #category : 'as yet unclassified' }
ResultAnalyzer >> generateLatex2 [

	^ String streamContents: [ :s |
			self generateLatexTableHeader2: s.
		  (programs sorted: [ :a :b | a programName < b programName ]) do: [
			  :e | e generateLatexOn2: s ] ]
]

{ #category : 'as yet unclassified' }
ResultAnalyzer >> generateLatexTableHeader1: aStream [

	aStream nextPutAll: '\hline'; crlf.

	self addColumnName: 'Benchmark' on: aStream. self nextFieldOn: aStream.
	self addColumnName: '\# Call Sites' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Monomorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Polymorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Megamorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.

	self addColumnName: 'Spurious Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Spurious Polymorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Spurious Megamorphic Call Sites \\ (\% out of \# call sites)' on: aStream.

	aStream
	   nextPutAll: ' \\ '; 
		crlf;
		nextPutAll: '\hline'; 
		crlf.

]

{ #category : 'as yet unclassified' }
ResultAnalyzer >> generateLatexTableHeader2: aStream [

	aStream nextPutAll: '\hline'; crlf.

	self addColumnName: 'Benchmark' on: aStream. self nextFieldOn: aStream.

	self addColumnName: '\# Calls' on: aStream. self nextFieldOn: aStream.
	self addColumnName: '\% Monomorphic Calls \\ (out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: '\% Polymorphic Calls \\ (out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: '\% Megamorphic Calls \\ (out of \# calls)' on: aStream. self nextFieldOn: aStream.

	self addColumnName: '\% Spurious Calls \\ (out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: '\% Spurious Polymorphic Calls \\ (out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: '\% Spurious Megamorphic Calls \\ (out of \# calls)' on: aStream. 

	aStream
	   nextPutAll: ' \\ '; 
		crlf;
		nextPutAll: '\hline'; 
		crlf.

]

{ #category : 'as yet unclassified' }
ResultAnalyzer >> generateLatexTableHeader: aStream [

	aStream nextPutAll: '\hline'; crlf.

	self addColumnName: 'Benchmark' on: aStream. self nextFieldOn: aStream.
	self addColumnName: '\# Call Sites' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Monomorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Polymorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Megamorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.

	self addColumnName: 'Spurious Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Spurious Polymorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Spurious Megamorphic Call Sites \\ (\% out of \# call sites)' on: aStream. self nextFieldOn: aStream.

	self addColumnName: '\# Calls' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Monomorphic Calls \\ (\% out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Polymorphic Calls \\ (\% out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Megamorphic Calls \\ (\% out of \# calls)' on: aStream. self nextFieldOn: aStream.

	self addColumnName: 'Spurious Calls \\ (\% out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Spurious Polymorphic Calls \\ (\% out of \# calls)' on: aStream. self nextFieldOn: aStream.
	self addColumnName: 'Spurious Megamorphic Calls \\ (\% out of \# calls)' on: aStream. 

	aStream
	   nextPutAll: ' \\ '; 
		crlf;
		nextPutAll: '\hline'; 
		crlf.

]

{ #category : 'as yet unclassified' }
ResultAnalyzer >> nextFieldOn: aWriteStream [

	aWriteStream
		nextPutAll: ' &';
		crlf
]
