Class {
	#name : 'StaticCallSiteTransformer',
	#superclass : 'Object',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
StaticCallSiteTransformer class >> transform: aCandidate [

	1 halt.
]

{ #category : 'refactoring' }
StaticCallSiteTransformer >> transformMethod: aMethod forCandidate: aStaticCallCandidate [

	| visitor newNode |
	"visitor:= ASTNodeReplacer new .
visitor replace: aStaticCallCandidate callSite  with: ((RBStaticMessageNode fromMessageNode:
			    aStaticCallCandidate callSite) staticClass:
			   aStaticCallCandidate receiverType).
aMethod ast acceptVisitor: visitor. "" ^ aStaticCallCandidate callSite replaceWith:
		  ((RBStaticMessageNode fromMessageNode:
			    aStaticCallCandidate callSite) staticClass:
			   aStaticCallCandidate receiverType)"
	aStaticCallCandidate callSite isBinary not ifTrue: [
		1 halt.
		newNode := (RBStaticMessageNode fromMessageNode:
				            aStaticCallCandidate callSite)
			           staticClass: aStaticCallCandidate receiverType;
			           selector:
				           '_' , aStaticCallCandidate receiverType asString , '_'
				           , aStaticCallCandidate callSite selector.
		aStaticCallCandidate callSite replaceWith: newNode ]
]
