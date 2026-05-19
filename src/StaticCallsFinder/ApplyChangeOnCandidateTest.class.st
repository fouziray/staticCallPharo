Class {
	#name : 'ApplyChangeOnCandidateTest',
	#superclass : 'TestCase',
	#instVars : [
		'transformer',
		'method',
		'backupMethods'
	],
	#category : 'StaticCallsFinder-tests',
	#package : 'StaticCallsFinder',
	#tag : 'tests'
}

{ #category : 'as yet unclassified' }
ApplyChangeOnCandidateTest >> example01 [

^	1 asInteger 
]

{ #category : 'as yet unclassified' }
ApplyChangeOnCandidateTest >> example02 [

^	[1 asInteger] value 
]

{ #category : 'as yet unclassified' }
ApplyChangeOnCandidateTest >> retrieveOldAstOf: aMethod [ 
	
	aMethod classBinding value addSelectorSilently: aMethod selector withMethod: ((RBParser parseMethod: aMethod sourceCode) generateMethod) 
]

{ #category : 'running' }
ApplyChangeOnCandidateTest >> setUp [ 
backupMethods := Dictionary new.
	transformer:= StaticCallSiteTransformer new.
]

{ #category : 'running' }
ApplyChangeOnCandidateTest >> tearDown [ 
method isNotNil ifTrue:[
	self retrieveOldAstOf: method].

	transformer rollbackBackedUpAst
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testApplyChangeOntodo [

	| newAst candidate newMethod originalSource |
	method := ApplyChangeOnCandidateTest >> #example01.
	originalSource := method sourceCode.
	"method ast hasBlock ifFalse: [
		"
	backupMethods at: method put: originalSource.
	candidate := StaticCallCandidate
		             method: method
		             callSite: (method ast allChildren at: 4)
		             selector: method selector
		             receiver: (method ast allChildren at: 4) receiver
		             receiverType: Number.
	newAst := transformer transformCandidate: candidate.

	ASTCache default at: newAst compiledMethod put: newAst.

	newMethod := newAst generateMethod.

	ASTCache default at: newAst compiledMethod put: newAst.

	self assert:
		((newMethod ast allChildren at: 4) isKindOf: RBStaticMessageNode)

	"self class
		addSelectorSilently: newMethod selector
		withMethod: newMethod.
		""]ifTrue: [  1 halt ]"
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testApplyChangeOntodoWrappedWithUnopt [

	| newAst candidate newMethod originalSource |
	method := ApplyChangeOnCandidateTest >> #example01.
	originalSource := method sourceCode.
	"method ast hasBlock ifFalse: [
		"
			backupMethods at: method put: originalSource.
	candidate := StaticCallCandidate
		             method: method
		             callSite: (method ast allChildren at: 4)
		             selector: method selector
		             receiver: (method ast allChildren at: 4) receiver
		             receiverType: Number.
	newAst := transformer transformFirstWrappingStatementOfMessage: method forCandidate: candidate.
	
	ASTCache default at: newAst compiledMethod put: newAst.
	newAst doSemanticAnalysis.
	newMethod := newAst generateMethod.

	ASTCache default at: newAst compiledMethod put: newAst.

	self assert: (((newMethod ast allChildren select:#isMessage ) select:#isStaticCall) isNotEmpty ).
	
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testDevirtualizationRefactoring [

	| candidate newMethod originalSource |
	method := ApplyChangeOnCandidateTest >> #example01.
	originalSource := method sourceCode.

	candidate := StaticCallCandidate
		             method: method
		             callSite: method ast sendNodes first
		             selector: method selector
		             receiver: method ast sendNodes first receiver
		             receiverType: Number.

self assert: method bytecodes second equals: 128.

	newMethod := transformer getNewMethodOfDevirtualizing: candidate.


	self assert:
		(newMethod ast sendNodes first isKindOf: RBStaticMessageNode).
1 halt.
	self assert: newMethod bytecodes second equals: 246.
	
	self class addSelector: newMethod selector withMethod: newMethod.
	1 halt.
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testDevirtualizationRefactoringInsideBlock [

	| candidate newMethod originalSource |
	method := ApplyChangeOnCandidateTest >> #example02.
	originalSource := method sourceCode.

	candidate := StaticCallCandidate
		             method: method
		             callSite: method ast sendNodes first
		             selector: method selector
		             receiver: method ast sendNodes first receiver
		             receiverType: Number.

	newMethod := transformer getNewMethodOfDevirtualizing: candidate.


	self assert:
		(newMethod ast sendNodes first isKindOf: RBStaticMessageNode).

	self class addSelector: newMethod selector withMethod: newMethod
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testRunExample [

	self assert: self example01 equals: 1.
	self assert: self example02 equals: 1
]
