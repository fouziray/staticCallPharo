Class {
	#name : 'ApplyChangeOnCandidateTest',
	#superclass : 'TestCase',
	#instVars : [
		'transformer',
		'method'
	],
	#category : 'StaticCallsFinder-tests',
	#package : 'StaticCallsFinder',
	#tag : 'tests'
}

{ #category : 'as yet unclassified' }
ApplyChangeOnCandidateTest >> retrieveOldAstOf: aMethod [ 
	
	aMethod classBinding value addSelectorSilently: aMethod selector withMethod: ((RBParser parseMethod: aMethod sourceCode) generateMethod) 
]

{ #category : 'running' }
ApplyChangeOnCandidateTest >> setUp [ 
	transformer:= StaticCallSiteTransformer new.
]

{ #category : 'running' }
ApplyChangeOnCandidateTest >> tearDown [ 

	self retrieveOldAstOf: method.
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testApplyChangeOntodo [

	| newAst candidate newMethod |
	method := MicrodownParser >> #blockStarterClassFrom:.
	candidate := StaticCallCandidate
		             method: method
		             callSite: (method ast allChildren at: 21)
		             selector: method selector
		             receiver: (method ast allChildren at: 21) receiver
		             receiverType: Number.
	newAst := transformer transformMethod: method forCandidate: candidate.

	newMethod := newAst generateMethod.

	self assert: ((newMethod ast allChildren at:20) isKindOf: RBStaticMessageNode ).
	
	self class
		addSelectorSilently: newMethod selector
		withMethod: newMethod.
]
