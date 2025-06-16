Class {
	#name : 'StaticCallDetectionTest',
	#superclass : 'TestCase',
	#instVars : [
		'analyzer',
		'visitor'
	],
	#category : 'StaticCallsFinder-tests',
	#package : 'StaticCallsFinder',
	#tag : 'tests'
}

{ #category : 'as yet unclassified' }
StaticCallDetectionTest class >> sampleMethodWithClassReceiver [

	^ SmallInteger readFrom: '30'.
]

{ #category : 'as yet unclassified' }
StaticCallDetectionTest class >> sampleMethodWithLiteralReceiver [

	^ 3 asFloat.
]

{ #category : 'running' }
StaticCallDetectionTest >> setUp [ 
	super setUp.
	analyzer := StaticCallAnalyzer new.
	visitor := StaticCallVisitor new.

]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithClassReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  StaticCallDetectionTest class >> #sampleMethodWithClassReceiver.
	
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	
	visitor visitMessageNode: literalMessageNode.
	
	self assert: visitor candidates isNotEmpty.
	self assert: visitor candidates first receiverType equals: 'SmallInteger' 
]

{ #category : 'tests' }
StaticCallDetectionTest >> testVisitMessageNodeWithLiteralReceiver [ 
	"Test message with literal receiver (high static call potential)"
	| method ast literalMessageNode |
	
	method :=  StaticCallDetectionTest class >> #sampleMethodWithLiteralReceiver.
	ast := method parseTree.
	literalMessageNode := ast sendNodes first.
	
	visitor visitMessageNode: literalMessageNode.
	
	self assert: visitor candidates isNotEmpty.
	self assert: visitor candidates first receiverType equals: 'SmallInteger' 
]
