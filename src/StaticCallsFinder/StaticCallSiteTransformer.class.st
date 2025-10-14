Class {
	#name : 'StaticCallSiteTransformer',
	#superclass : 'Object',
	#instVars : [
		'backupMethods'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'accessing' }
StaticCallSiteTransformer class >> transform: aCandidate [

	1 halt.
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> backupMethod: method [

	backupMethods at: method put: method sourceCode
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> getNewMethodOfDevirtualizing: candidate [

	| newAst newMethod |
	newAst := self
		          transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate.

	ASTCache default at: newAst compiledMethod put: newAst.

	newMethod := newAst generateMethod.
	ASTCache default at: newAst compiledMethod put: newAst.
	^ newMethod
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> initialize [ 
	backupMethods := Dictionary new
]

{ #category : 'running' }
StaticCallSiteTransformer >> rollbackBackedUpAst [

	backupMethods keysAndValuesDo: [ :method :originalSource |
		[
		method methodClass
			compile: originalSource
			classified: method protocol ] ]
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
	self backupMethod: aMethod.
	^ (aStaticCallCandidate callSite isBinary not and: [
		   aStaticCallCandidate receiverType ~= 'temp' ])
		  ifTrue: [
			  newNode := (RBStaticMessageNode fromMessageNode:
				              aStaticCallCandidate callSite) staticClass:
				             aStaticCallCandidate receiverType.
			  aStaticCallCandidate callSite replaceWith: newNode.
			  newNode methodNode ]
		  ifFalse: [ aStaticCallCandidate callSite methodNode ]
]
