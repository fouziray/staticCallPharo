Class {
	#name : 'StaticCallDetectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'analyzer',
		'visitor',
		'interproceduralVisitor'
	],
	#category : 'StaticCallsFinder-tests',
	#package : 'StaticCallsFinder',
	#tag : 'tests'
}

{ #category : 'as yet unclassified' }
StaticCallDetectionTest class >> sampleMethodWithArrayReceiver [

	^ { 21 } do:[ nil] .
]

{ #category : 'as yet unclassified' }
StaticCallDetectionTest class >> sampleMethodWithBlockReceiver [

	^ [ { 21 } do:[ nil] ] value .
]

{ #category : 'as yet unclassified' }
StaticCallDetectionTest class >> sampleMethodWithClassReceiver [

	^ SmallInteger readFrom: '30'.
]

{ #category : 'as yet unclassified' }
StaticCallDetectionTest class >> sampleMethodWithLiteralReceiver [

	^ 3 asFloat.
]

{ #category : 'as yet unclassified' }
StaticCallDetectionTest class >> sampleMethodWithSelfReceiver [

	^ self sampleMethodWithLiteralReceiver .
]

{ #category : 'running' }
StaticCallDetectionTest >> setUp [ 
	super setUp.
	analyzer := StaticCallAnalyzer new.
	visitor := StaticCallVisitor new.

]

{ #category : 'tests' }
StaticCallDetectionTest >> testMixPointsto [
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  MockSCDTest class >> #sampleMethodWithSuperReceiver.
	ast := method parseTree.
	
	interproceduralVisitor := DevirtualizeAnalyzer new. 
	
	interproceduralVisitor perMethodSCall: visitor .
	interproceduralVisitor pass: method.
	self assert: visitor candidates asSet isNotEmpty.
	self assert: visitor candidates first receiverType equals: StaticCallDetectionTest class .
	self assert: visitor candidates second receiverType equals: SmallInteger . 
	self assert: interproceduralVisitor ctxListLog size equals: 2
]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithArrayReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  StaticCallDetectionTest class >> #sampleMethodWithArrayReceiver.
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	visitor method: method.
	ast acceptVisitor: visitor.
	self assert: visitor candidates isNotEmpty.
	self assert: visitor candidates first receiverType equals: SequenceableCollection 
]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithBlockReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  StaticCallDetectionTest class >> #sampleMethodWithBlockReceiver .
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	visitor method: method.
	ast acceptVisitor: visitor.
	self assert: visitor candidates isEmpty. "we don't consider blocks as statically known types for now "

]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithClassReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  StaticCallDetectionTest class >> #sampleMethodWithClassReceiver.
	
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	
	visitor method: method.
	"visitor visitMessageNode: literalMessageNode."
	ast acceptVisitor: visitor.
	
	self assert: visitor candidates isNotEmpty.
	self assert: visitor candidates first receiverType equals: Integer class
]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithLiteralReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  StaticCallDetectionTest class >> #sampleMethodWithLiteralReceiver.
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	visitor method: method.
	ast acceptVisitor: visitor.
	self assert: visitor candidates isNotEmpty.
	self assert: visitor candidates first receiverType equals: SmallInteger 
]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithSelfReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  StaticCallDetectionTest class >> #sampleMethodWithSelfReceiver.
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	visitor method: method.
	ast acceptVisitor: visitor.
	self assert: visitor candidates isNotEmpty.
	self assert: visitor candidates first receiverType equals: StaticCallDetectionTest class 
]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithSuperReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  MockSCDTest class >> #sampleMethodWithSuperReceiver.
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	visitor method: method.
	ast acceptVisitor: visitor.
	self assert: visitor candidates isNotEmpty.
	self assert: visitor candidates first receiverType equals: StaticCallDetectionTest class 
]
