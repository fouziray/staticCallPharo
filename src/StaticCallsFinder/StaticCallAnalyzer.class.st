Class {
	#name : 'StaticCallAnalyzer',
	#superclass : 'Object',
	#instVars : [
		'candidates',
		'hotMethods',
		'callFrequencies',
		'typeInferences'
	],
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

{ #category : 'testing' }
StaticCallAnalyzer class >> analyze: aClass [

	^ self new analyzeClass: aClass
]

{ #category : 'as yet unclassified' }
StaticCallAnalyzer class >> analyzeMethod: aCompiledMethod [
	"Single method analysis"

	^ self new analyzeCompiledMethod: aCompiledMethod
]

{ #category : 'as yet unclassified' }
StaticCallAnalyzer class >> analyzePackage: aPackageName [

	^ self new analyzePackage: aPackageName

]

{ #category : 'as yet unclassified' }
StaticCallAnalyzer >> analyzeClass: aClass [ 
	"Analyze all methods in a class for static call opportunities"
	| results |
	results := OrderedCollection new.
	
	aClass methods do: [ :method |
		results addAll: (self analyzeCompiledMethod: method)
	].
	
	aClass class methods do: [ :method |
		results addAll: (self analyzeCompiledMethod: method)
	].
	
	^ results

]

{ #category : 'as yet unclassified' }
StaticCallAnalyzer >> analyzeCompiledMethod: aCompiledMethod [ 
	"Analyze a single compiled method for static call opportunities"
	| ast visitor results |
	
	ast := aCompiledMethod ast.
	visitor := StaticCallVisitor new.
	visitor method: aCompiledMethod.
	
	ast acceptVisitor: visitor.
	
	results := visitor candidates.
	
	"Filter and rank candidates"
	^ self rankCandidates: results forMethod: aCompiledMethod

]

{ #category : 'as yet unclassified' }
StaticCallAnalyzer >> analyzePackage: aPackageName [
	"Analyze all classes in a package"

	| package results |
	package := PackageOrganizer default packageNamed: aPackageName.
	results := OrderedCollection new.

	package definedClasses do: [ :class |
		results addAll: (self analyzeClass: class) ].

	^ results
]

{ #category : 'accessing' }
StaticCallAnalyzer >> candidates: aCollection [ 
	candidates := aCollection
]

{ #category : 'testing' }
StaticCallAnalyzer >> generateReport [
	"Generate a readable report of all candidates"

	| stream |
	stream := WriteStream on: String new.

	stream
		nextPutAll: 'Static Call Optimization Candidates';
		cr;
		cr.

	candidates do: [ :candidate |
		stream
			nextPutAll: candidate method methodClass name;
			nextPutAll: '>>';
			nextPutAll: candidate method selector;
			cr;
			nextPutAll: '  Call: ';
			nextPutAll: candidate selector asString;
			cr;
			nextPutAll: '  Receiver type: ';
			nextPutAll: candidate receiverType asString;
			cr;
			cr.
			
		self printStatisticsFor: candidate on: stream ].

	^ stream contents
]

{ #category : 'testing' }
StaticCallAnalyzer >> getCallFrequency: aSelector [ 
	^ callFrequencies at: aSelector ifAbsent: [ 1.0 ]

]

{ #category : 'testing' }
StaticCallAnalyzer >> getMethodComplexity: aMethod [ 

	^ (aMethod numLiterals + aMethod numArgs + aMethod numTemps) asFloat / 10.0 max: 1.0
]

{ #category : 'testing' }
StaticCallAnalyzer >> hasTypeHint: aNode [ 
	"Check if variable name suggests a specific type"
	| name |
	aNode isVariable ifFalse: [ ^ false ].
	
	
	name := aNode name asLowercase.
	
	^ (#('astring' 'anumber' 'aninteger' 'afloat' 'aboolean' 'anarray' 'acollection' 'aset' 'adictionary') 
		anySatisfy: [ :hint | name beginsWith: hint ])
		or: [ name endsWith: 'class' ]

]

{ #category : 'initialization' }
StaticCallAnalyzer >> initialize [ 
	super initialize.
	candidates := OrderedCollection new.
	hotMethods := Dictionary new.
	callFrequencies := Dictionary new.
	typeInferences := Dictionary new.


]

{ #category : 'printing' }
StaticCallAnalyzer >> printStatisticsFor: candidate on: stream [

]

{ #category : 'as yet unclassified' }
StaticCallAnalyzer >> rankCandidates: candidates forMethod: aMethod [

	^ candidates
]
