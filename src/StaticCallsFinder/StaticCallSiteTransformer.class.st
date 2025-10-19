Class {
	#name : 'StaticCallSiteTransformer',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'backupMethods',
		'recordedTypes',
		'receiver',
		'message',
		'nestedCallsVisitor',
		'filteredRecordedTypes'
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

	backupMethods at: method ifAbsentPut: method sourceCode
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> compileAstWithStaticNodes: newAst [

	| newMethod |
	ASTCache default at: newAst compiledMethod put: newAst.

	newMethod := newAst generateMethod.
	ASTCache default at: newAst compiledMethod put: newAst.
	newMethod classBinding value
		addSelector: newMethod selector
		withMethod: newMethod.
		

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
	newMethod classBinding addSelector: newMethod selector withMethod: newMethod.
	^ newMethod
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> getNewMethodOfDevirtualizingAll [

	| newAst newMethod candidate astCachePerModifiedMethod|
	astCachePerModifiedMethod:= Dictionary new.
	filteredRecordedTypes:= PolymorphicCallSitesVisitor filterFakePoly: recordedTypes.
	( filteredRecordedTypes) do:[: each |  
		| currentAssociation |
		currentAssociation := each.

	"	(each key parent isMessage or:[ each key isStaticCall ]) ifTrue:[ 1 halt. ]".
		self receiver: each value values first asOrderedCollection first.
		candidate := StaticCallCandidate
			             method: each value keys first
			             callSite: each key
			             selector: each key methodNode selector
			             receiver:
			             each value values first asOrderedCollection first
			             receiverType:
			             (each key receiver acceptVisitor: self).
	self backupMethod: candidate callSite methodNode compiledMethod.
	newAst := astCachePerModifiedMethod at: candidate callSite methodNode compiledMethod ifAbsentPut:[ candidate callSite methodNode ]. 
	newAst := self transformMethodNode: newAst forCandidate: candidate.
	astCachePerModifiedMethod at: candidate callSite methodNode compiledMethod put:  newAst.  
		" transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."

].

astCachePerModifiedMethod associationsDo: [ :a | 
	
	self compileAstWithStaticNodes: a value ].
	
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> initialize [ 
	backupMethods := Dictionary new.
	nestedCallsVisitor:= NestedCallVisitor new
]

{ #category : 'accessing' }
StaticCallSiteTransformer >> message [
	message
]

{ #category : 'accessing' }
StaticCallSiteTransformer >> message: aRBMessageNode [

	message := aRBMessageNode.

	self receiver: (self recordedTypes  at: message ) values first asArray first class. 
]

{ #category : 'accessing' }
StaticCallSiteTransformer >> receiver [
	receiver
]

{ #category : 'accessing' }
StaticCallSiteTransformer >> receiver: aClass [
	receiver:= aClass
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> recordedTypes [

	^ recordedTypes
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> recordedTypes: aTable [

	recordedTypes := aTable
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

	| visitor newNode result |
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
			  result := newNode methodNode ]
		  ifFalse: [ aStaticCallCandidate callSite methodNode ]
]

{ #category : 'refactoring' }
StaticCallSiteTransformer >> transformMethodNode: aMethodNode forCandidate: aStaticCallCandidate [

	| visitor newNode result |
	"visitor:= ASTNodeReplacer new .
visitor replace: aStaticCallCandidate callSite  with: ((RBStaticMessageNode fromMessageNode:
			    aStaticCallCandidate callSite) staticClass:
			   aStaticCallCandidate receiverType).
aMethod ast acceptVisitor: visitor. "" ^ aStaticCallCandidate callSite replaceWith:
		  ((RBStaticMessageNode fromMessageNode:
			    aStaticCallCandidate callSite) staticClass:
			   aStaticCallCandidate receiverType)"

	^ (aStaticCallCandidate callSite isBinary not and: [
		   aStaticCallCandidate receiverType ~= 'temp' ])
		  ifTrue: [
		self haltIf: aStaticCallCandidate receiverType isNil.
			  newNode := (RBStaticMessageNode fromMessageNode:
				              aStaticCallCandidate callSite) staticClass:
				             aStaticCallCandidate receiverType.
			  aStaticCallCandidate callSite replaceWith: newNode.
			  result := newNode methodNode ]
		  ifFalse: [ aMethodNode ]
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitClassVariableNode: aNode [
1 halt.
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitGlobalNode: aGlobalNode [

	|classSideMethods instSideMethods|
1 halt.			
				instSideMethods := self receiver lookupSelector:self receiver parent selector.
				classSideMethods := self receiver class lookupSelector:self message selector.
				(instSideMethods isNotNil or:[classSideMethods isNotNil ]) ifTrue: [1 halt.  ].
		^  self receiver lookupSelector: (recordedTypes at: self parent).
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitLiteralNode: aLiteralNode [
self halt.
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitMessageNode: aMessageNode [

	^ (recordedTypes at: aMessageNode) keys first classBinding value
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitSelfNode: aSelfNode [
 ^ receiver 
	
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitSuperNode: aSuperNode [

	^ receiver
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitVariableNode: aVariableNode [

	^ receiver
]
