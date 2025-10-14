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
ApplyChangeOnCandidateTest >> retrieveOldAstOf: aMethod [ 
	
	aMethod classBinding value addSelectorSilently: aMethod selector withMethod: ((RBParser parseMethod: aMethod sourceCode) generateMethod) 
]

{ #category : 'running' }
ApplyChangeOnCandidateTest >> rollbackBackedUpAst [

	backupMethods keysAndValuesDo: [ :method :originalSource |
		[
		method methodClass
			compile: originalSource
			classified: method protocol ] ]
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
	self rollbackBackedUpAst.
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testApplyChangeOntodo [

	| newAst candidate newMethod originalSource |
	method := ApplyChangeOnCandidateTest >> #example01.
	originalSource := method sourceCode.
	method ast hasBlock ifFalse: [
		1 halt.
			backupMethods at: method put: originalSource.
	candidate := StaticCallCandidate
		             method: method
		             callSite: (method ast allChildren at: 21)
		             selector: method selector
		             receiver: (method ast allChildren at: 21) receiver
		             receiverType: Number.
	newAst := transformer transformMethod: method forCandidate: candidate.
	
	ASTCache default at: newAst compiledMethod put: newAst.
	
	newMethod := newAst generateMethod.

	ASTCache default at: newAst compiledMethod put: newAst.

	self assert: ((newMethod ast allChildren at:20) isKindOf: RBStaticMessageNode ).
	
	self class
		addSelectorSilently: newMethod selector
		withMethod: newMethod.
		] ifTrue: [  1 halt ]
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testDevirtualizationRefactoring [

	| newAst candidate newMethod originalSource |
	method := ApplyChangeOnCandidateTest >> #example01.
	originalSource := method sourceCode.
	method ast hasBlock ifFalse: [
			backupMethods at: method put: originalSource.
	candidate := StaticCallCandidate
		             method: method
		             callSite: (method ast sendNodes first)
		             selector: method selector
		             receiver: (method ast sendNodes first) receiver
		             receiverType: Number.
	newAst := transformer transformMethod: method forCandidate: candidate.
	
	ASTCache default at: newAst compiledMethod put: newAst.
	
	newMethod := newAst generateMethod.

	ASTCache default at: newAst compiledMethod put: newAst.

	self assert: ((newMethod ast sendNodes first) isKindOf: RBStaticMessageNode ).
	
	self class
		addSelector:  newMethod selector
		withMethod: newMethod.
		] ifTrue: [  1 halt ]
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testRunExample [

	self assert: self example01 equals: 1
]
