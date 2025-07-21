Class {
	#name : 'MicrodownWithStaticCallBenchmarkSuite',
	#superclass : 'Object',
	#instVars : [
		'analyzer',
		'results',
		'optimizedMethods',
		'baselineTime',
		'optimizedTime',
		'profiler'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite class >> quickTest [ 
	"small document"
	^ self new runQuickBenchmark
]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite class >> runFullBenchmark [ 

	^ self new runFullBenchmarkSuite
]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> analyzeAllMicroDownPackages [

	profiler addLinkToNodes: profiler selectMicrodownPackages.
	 
]

{ #category : 'initialization' }
MicrodownWithStaticCallBenchmarkSuite >> analyzeMicrodownPackage [

	| candidates |
	candidates := OrderedCollection new.

	((PackageOrganizer default packageNamed: #MicroDown)
		 classesTaggedWith: #Parser) do: [ :class |
		| classCandidates |
		classCandidates := analyzer analyzeClass: class.
		candidates addAll: classCandidates ].


	results at: #candidates put: candidates
]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> appendRecommendations: aStream [ 
	"Append optimization recommendations"
	| hotSpots |
	hotSpots := results at: #hotSpots ifAbsent: [ #() ].
	
	aStream nextPutAll: '1. **Focus on string operations** - Many parsing methods use string manipulation'; cr.
	aStream nextPutAll: '2. **Optimize collection access** - Array/OrderedCollection operations are frequent'; cr.
	aStream nextPutAll: '3. **Target arithmetic operations** - Position calculations and comparisons'; cr.
	aStream nextPutAll: '4. **Consider AST node creation** - Object instantiation patterns'; cr.
	
	hotSpots size > 20 ifTrue: [
		aStream nextPutAll: '5. **High optimization potential** - ', hotSpots size asString, 
		           ' hot spots identified for static calls'; cr.
	].
	
	aStream nextPutAll: '6. **Profile in production** - Run with actual documents to validate improvements'; cr.

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> appendTopCandidates: aStream [ 
	
	| candidates |
	candidates := results at: #candidates ifAbsent: [ #() ].
	
	(candidates first: (candidates size min: 10)) do: [ :candidate |
		aStream 
			nextPutAll: '- **', candidate method methodClass name, 
			           '>>', candidate method selector, '** -> `', 
			           candidate selector asString.
	].

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> applyOptimizations [
	"Simulate applying static call optimizations"

	| hotSpots backupMethods transformer newMethod |
	hotSpots := results at: #candidates.
	backupMethods := Dictionary new.
	transformer := StaticCallSiteTransformer new.


	hotSpots do: [ :candidate |
		| method originalSource newAst newSource |
		method := candidate method.
		originalSource := method sourceCode.
		backupMethods at: method put: originalSource.

		newAst := transformer
			          transformMethod: method
			          forCandidate: candidate.
		newMethod := newAst generateMethod.

		method methodClass
			addSelectorSilently: newMethod selector
			withMethod: newMethod.

		optimizedMethods add: candidate method ].
	results at: #backupMethods put: backupMethods.
	results at: #optimizedMethodCount put: optimizedMethods size
]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> calculateImprovementFactor [ 
	"Calculate expected improvement based on static call opportunities"
	| hotSpots totalCandidates staticCallDensity |
	hotSpots := results at: #hotSpots ifAbsent: [ 0 ].
	totalCandidates := results at: #totalCandidates ifAbsent: [ 1 ].
	
	staticCallDensity := hotSpots / totalCandidates.
	
	"Conservative estimate: 5-15% improvement based on density"
	^ (staticCallDensity * 0.15) max: 0.02 "At least 2% improvement"

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> createBookDocument [ 

	^ String streamContents: [ :s |
		s nextPutAll: '# The Complete Pharo Book'; cr; cr.
		s nextPutAll: 'A comprehensive guide to Pharo development.'; cr; cr.
		
		1 to: 50 do: [ :chapter |
			s nextPutAll: '# Chapter ', chapter asString, ': Advanced Topics'; cr; cr.
			
			1 to: 20 do: [ :section |
				s nextPutAll: '## Section ', chapter asString, '.', section asString; cr; cr.
				
				"Add substantial content per section"
				1 to: 10 do: [ :para |
					s nextPutAll: 'This is paragraph ', para asString, ' of section ', section asString, 
					             '. It contains detailed explanations about Pharo development, ';
					 nextPutAll: 'including **object-oriented programming**, *dynamic typing*, and ';
					nextPutAll: '`live programming` concepts. The paragraph continues with more ';
					nextPutAll: 'technical details and examples.'; cr; cr.
				].
				
				"Add code blocks"
				s nextPutAll: '```smalltalk'; cr.
				s nextPutAll: 'Object subclass: #ExampleClass'; cr.
				s nextPutAll: '	instanceVariableNames: ''name value'''; cr.
				s nextPutAll: '	classVariableNames: '''''; cr.
				s nextPutAll: '	package: ''Examples'''; cr; cr.
				s nextPutAll: 'ExampleClass >> initialize'; cr.
				s nextPutAll: '	super initialize.'; cr.
				s nextPutAll: '	name := ''default''.'; cr.
				s nextPutAll: '	value := 0'; cr.
				s nextPutAll: '```'; cr; cr.
			]
		]
	]

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> createLargeDocument [ 
	"Generate a large Microdown document (~100KB)"
	^ String streamContents: [ :s |
		s nextPutAll: '# Large Test Document'; cr; cr.
		
		1 to: 200 do: [ :i |
			s nextPutAll: '## Chapter ', i asString; cr; cr.
			s nextPutAll: 'This is a longer chapter with multiple paragraphs. '; cr.
			s nextPutAll: 'We include **bold text**, *italic text*, and `inline code`.'; cr; cr.
			
			s nextPutAll: '### Code Examples'; cr; cr.
			s nextPutAll: '```smalltalk'; cr.
			s nextPutAll: 'testMethod'; cr.
			s nextPutAll: '	| temp |'; cr.
			s nextPutAll: '	temp := Array new: 10.'; cr.
			s nextPutAll: '	temp at: 1 put: ''hello''.'; cr.
			s nextPutAll: '	^ temp'; cr.
			s nextPutAll: '```'; cr; cr.
			
			"Add some tables and lists"
			i \\ 5 = 0 ifTrue: [
				s nextPutAll: '| Column 1 | Column 2 | Column 3 |'; cr.
				s nextPutAll: '|----------|----------|----------|'; cr.
				s nextPutAll: '| Data 1   | Data 2   | Data 3   |'; cr.
				s nextPutAll: '| More 1   | More 2   | More 3   |'; cr; cr.
			].
		]
	]

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> createMediumDocument [ 

	^ String streamContents: [ :s |
		s nextPutAll: '# Medium size Test Document'; cr; cr.
		
		1 to: 20 do: [ :i |
			s nextPutAll: '## Section ', i asString; cr; cr.
			s nextPutAll: 'This is section ', i asString, ' with some **bold text** and *italic text*.'; cr; cr.
			
			s nextPutAll: '### Subsection'; cr; cr.
			s nextPutAll: 'Here is a code block:'; cr; cr.
			s nextPutAll: '```smalltalk'; cr.
			s nextPutAll: 'Object new'; cr.
			s nextPutAll: '```'; cr; cr.
			
			s nextPutAll: '1. First item'; cr.
			s nextPutAll: '2. Second item'; cr.
			s nextPutAll: '3. Third item'; cr; cr.
		]
	]




]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> createSmallDocument [ 

	^ String streamContents: [ :s |
		s nextPutAll: '# Small Test Document'; cr.
		s nextPutAll: ''; cr.
		s nextPutAll: 'This is a **small test** document for benchmarking.'; cr.
		s nextPutAll: ''; cr.
		s nextPutAll: '## Code Example'; cr.
		s nextPutAll: ''; cr.
		s nextPutAll: '```smalltalk'; cr.
		s nextPutAll: '| result |'; cr.
		s nextPutAll: 'result := 42 + 24.'; cr.
		s nextPutAll: 'result printString'; cr.
		s nextPutAll: '```'; cr.
		s nextPutAll: ''; cr.
		s nextPutAll: '- Item 1'; cr.
		s nextPutAll: '- Item 2'; cr.
		s nextPutAll: '- Item 3'; cr.
	]


]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> generateBenchmarkReport [ 
	"Generate comprehensive benchmark report"
			
		| baselines optimized |
	^ String streamContents: [ :s |
		s nextPutAll: '# Microdown Static Call Optimization Benchmark Report'; cr; cr.
		
		s nextPutAll: '## Analysis Summary'; cr.
		s nextPutAll: '- Total static call candidates: ', (results at: #candidates) size asString; cr.
		
		s nextPutAll: '- Methods optimized: ', (results at: #optimizedMethodCount ifAbsent: [ 0 ]) asString; cr; cr.
		
		s nextPutAll: '## Performance Results'; cr; cr.
		
		"Performance table"
		s nextPutAll: '| Document Size | Baseline (ms) | Optimized (ms) | Improvement |'; cr.
		s nextPutAll: '|---------------|---------------|----------------|-------------|'; cr.

		baselines := results at: #baselineTimes ifAbsent: [ Dictionary new ].
		optimized := results at: #optimizedTimes ifAbsent: [ Dictionary new ].
		
		baselines keysAndValuesDo: [ :size :baseTime |
			| optTime improvement |
			optTime := optimized at: size ifAbsent: [ baseTime ].
			improvement := ((baseTime - optTime) / baseTime * 100.0) rounded.
			
			s nextPutAll: '| ', size asString capitalized, ' | ', 
			             baseTime asString, ' | ',
			             optTime asString, ' | ',
			             improvement asString, '% |'; cr.
		].
		
		s cr.
		s nextPutAll: '## Book Loading Impact'; cr.
		s nextPutAll: 'For a typical book-sized document (~1MB):'; cr.
		s nextPutAll: '- Baseline loading time: ', (baselineTime ifNil: [ 'N/A' ] ifNotNil: [ baselineTime  asString, 'ms' ]); cr.
		s nextPutAll: '- Optimized loading time: ', (optimizedTime ifNil: [ 'N/A' ] ifNotNil: [ optimizedTime  asString, 'ms' ]); cr.
		
		baselineTime ifNotNil: [ optimizedTime ifNotNil: [
			| totalImprovement |
			totalImprovement := ((baselineTime - optimizedTime) / baselineTime * 100.0) rounded.
			s nextPutAll: '- **Total improvement: ', totalImprovement asString, '%**'; cr.
		]].
		
		s cr.
		s nextPutAll: '## Top Optimization Candidates'; cr.
		self appendTopCandidates: s.
		
		s cr.
		s nextPutAll: '## Recommendations'; cr.
		self appendRecommendations: s.
	]

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> generateQuickReport [ 
	"Generate quick test report"
	^ String streamContents: [ :s |
		s nextPutAll: 'Quick Microdown Benchmark Report'; cr.
		s nextPutAll: 'Static call candidates: ', (results at: #totalCandidates ifAbsent: [ 0 ]) asString; cr.
		s nextPutAll: 'Hot spots: ', (results at: #hotSpots ifAbsent: [ #() ]) size asString; cr.
		s nextPutAll: 'Quick test time: ', (results at: #quickBaseline ifAbsent: [ 0 ]) asString, 'ms'; cr.
	]

]

{ #category : 'initialization' }
MicrodownWithStaticCallBenchmarkSuite >> initialize [ 
	super initialize.
	analyzer := StaticCallAnalyzer new.
	results := Dictionary new.
	optimizedMethods := Set new.
]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> measureBaselinePerformance [ 
	"Measure baseline parsing performance"
	| documents times |
	documents := results at: #testDocuments.
	times := Dictionary new.
	
	
	documents keysAndValuesDo: [ :size :content |
		| time parser |
		parser := Microdown.
		
		"Warm up"
		"3 timesRepeat: [ parser parse: content ]."
		
		"Measure"
		time := [ 3 timesRepeat: [ parser parse: content ] ] timeToRun.
		times at: size put: time / 10.0. "Average per parse"
		
		Transcript show: '  ', size asString, ': ', (time / 10.0) asString, 'ms average'; cr.
	].
	
	results at: #baselineTimes put: times.
	baselineTime := times at: #book ifAbsent: [ times values max ].

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> measureOptimizedPerformance [ 
	"Measure performance with simulated optimizations"
	| documents times improvementFactor parser |
	documents := results at: #testDocuments.
	times := Dictionary new.
	improvementFactor :=Dictionary new.
	
	parser := MicrodownParser.
	documents keysAndValuesDo: [ :size :content |
		| baseTime optimizedTime time |
		baseTime := (results at: #baselineTimes) at: size.
		time := [ 3 timesRepeat: [ parser parse: content ] ] timeToRun.
		times at: size put: time / 10.0. "Average per parse"
		improvementFactor at: size put:  (baseTime - optimizedTime) / baseTime .
		times at: size put: optimizedTime.
		
		Transcript show: '  ', size asString, ': ', optimizedTime asString, 'ms (', 
		                 ((baseTime - optimizedTime) / baseTime * 100.0) rounded asString, 
		                 '% improvement)'; cr.
	].
	
	results at: #optimizedTimes put: times.
	results at: #improvementFactor put: improvementFactor.
	optimizedTime := times at: #book ifAbsent: [ times values min ].

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> measureQuickPerformance [ 
	"Quick performance measurement"
	| doc time parser |
	doc := (results at: #testDocuments) at: #quick.
	parser := MicrodownParser new.
	
	"Baseline"
	time := [ 10 timesRepeat: [ parser parse: doc ] ] timeToRun.
	results at: #quickBaseline put: time / 10.0.
	
	Transcript show: 'Quick baseline: ', (time / 10.0) asString, 'ms'; cr.


]

{ #category : 'initialization' }
MicrodownWithStaticCallBenchmarkSuite >> profileToGetStaticCallSites [

	|report|

	self analyzeAllMicroDownPackages.
	
	self setupTestDocuments.
	
	self measureBaselinePerformance.
	self measureTestCasesPerformance.
	self applyOptimizations.
	
	self measureOptimizedPerformance.
	self measureOptimizedTestCasesPerformance.

	self removeMetaLinks.
	
	report := self generateBenchmarkReport.

	^ report
]

{ #category : 'accessing' }
MicrodownWithStaticCallBenchmarkSuite >> profiler [

	^ profiler
]

{ #category : 'accessing' }
MicrodownWithStaticCallBenchmarkSuite >> profiler: aProfiler [

	profiler:= aProfiler 
]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> rollbackOptimizations [ 

	| backupMethods |
	backupMethods := results at: #backupMethods ifAbsent: [ Dictionary new ].
	
	Transcript show: 'Rolling back ', backupMethods size asString, ' optimizations...'; cr.
	
	backupMethods keysAndValuesDo: [ :method :originalSource |
		[ 
			method methodClass compile: originalSource classified: method protocol.
			Transcript show: '  ✓ Restored: ', method methodClass name, '>>', method selector; cr.
		] on: Error do: [ :error |
			Transcript show: '   Failed to restore: ', method methodClass name, 
			                 '>>', method selector, ' (', error messageText, ')'; cr.
		].
	].
	
	optimizedMethods := Set new.
	results removeKey: #backupMethods ifAbsent: [].
	
	Transcript show: 'Rollback complete'; cr.

]

{ #category : 'initialization' }
MicrodownWithStaticCallBenchmarkSuite >> runFullBenchmarkSuite [

	| report |
	self analyzeMicrodownPackage.

	"Phase 2: Create test documents of various sizes"
	self setupTestDocuments.

	"Phase 3: Baseline performance measurement"
	self measureBaselinePerformance.

	"Phase 4: Apply optimizations (simulate static calls)"
	self applyOptimizations.

	"Phase 5: Measure optimized performance"
	self measureOptimizedPerformance.

	"Phase 6: Generate comprehensive report"
	report := self generateBenchmarkReport.

	self rollbackOptimizations.
	Transcript
		show: 'Benchmark complete!';
		cr.
	^ report
]

{ #category : 'initialization' }
MicrodownWithStaticCallBenchmarkSuite >> runQuickBenchmark [ 
	" benchmark with minimal setup"
	self analyzeMicrodownPackage.
	self setupQuickTest.
	self measureQuickPerformance.
	^ self generateQuickReport

]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> setupQuickTest [
	"Setup minimal test for quick runs"

	| doc |
	doc := Dictionary new.
	doc at: #quick put: self createSmallDocument.
	results at: #testDocuments put: doc
]

{ #category : 'as yet unclassified' }
MicrodownWithStaticCallBenchmarkSuite >> setupTestDocuments [
	"Create test documents of various sizes"

	| documents |
	documents := Dictionary new.

	documents at: #small put: self createSmallDocument.

	
	documents at: #medium put: self createMediumDocument.

	documents at: #large put: self createLargeDocument.

	
	documents at: #book put: self createBookDocument.

	results at: #testDocuments put: documents.

]
