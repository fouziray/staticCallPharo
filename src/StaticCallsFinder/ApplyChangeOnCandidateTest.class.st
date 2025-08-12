Class {
	#name : 'ApplyChangeOnCandidateTest',
	#superclass : 'TestCase',
	#instVars : [
		'transformer'
	],
	#category : 'StaticCallsFinder-tests',
	#package : 'StaticCallsFinder',
	#tag : 'tests'
}

{ #category : 'running' }
ApplyChangeOnCandidateTest >> setUp [ 
	transformer:= StaticCallSiteTransformer new.
]

{ #category : 'tests' }
ApplyChangeOnCandidateTest >> testApplyChangeOntodo [
	
| newAst method candidate newMethod |
method:= MicrodownParser>>#blockStarterClassFrom: .
candidate:= StaticCallCandidate method: method callSite: (method ast allChildren at: 22) selector: method selector  receiver: (method ast allChildren at: 22) receiver receiverType: Number.
newAst := transformer
			          transformMethod: method
			          forCandidate: candidate.
		newMethod := newAst generateMethod.

		self class
			addSelectorSilently: newMethod selector
			withMethod: newMethod.
]
