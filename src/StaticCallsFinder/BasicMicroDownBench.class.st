Class {
	#name : 'BasicMicroDownBench',
	#superclass : 'Object',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'benchmarking' }
BasicMicroDownBench class >> bench [

	| runs |
	runs := (1 to: self iterations) collect: [ :i |
		        [1000 timesRepeat: [ self runOnce ]] timeToRun ].

	^ {
		  runs average.
		  (runs collect: #asMilliSeconds) stdev }
]

{ #category : 'benchmarking' }
BasicMicroDownBench class >> expectedOutput [

	^ 'Small Test Document
This is a small test document for benchmarking.

Code Example
smalltalk





result := 42 + 24.
result printString

•	Item 1
•	Item 2
•	Item 3'
]

{ #category : 'benchmarking' }
BasicMicroDownBench class >> iterations [

	^ 30
]

{ #category : 'benchmarking' }
BasicMicroDownBench class >> runOnce [

	| composer text |
	composer := MicRichTextComposer new.

	text := composer visit:
	(Microdown parse: (String streamContents: [ :s |
                s nextPutAll: '# Small Test Document'; cr.
                s nextPutAll: ''; cr.
                s nextPutAll: 'This is a **small test** document for benchmarking.'; cr.
                s nextPutAll: ''; cr.
                s nextPutAll: '## Code Example'; cr.
                s nextPutAll: ''; cr.
                s nextPutAll: 'smalltalk'; cr.
                s nextPutAll: '| result |'; cr.
                s nextPutAll: 'result := 42 + 24.'; cr.
                s nextPutAll: 'result printString'; cr.
                s nextPutAll: ''; cr.
                s nextPutAll: ''; cr.
                s nextPutAll: '- Item 1'; cr.
                s nextPutAll: '- Item 2'; cr.
                s nextPutAll: '- Item 3'; cr.
              ])).

	text asString = self expectedOutput ifFalse: [ self error: 'Not the same' ].

]
