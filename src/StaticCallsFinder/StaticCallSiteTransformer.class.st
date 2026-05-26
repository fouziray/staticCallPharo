Class {
	#name : 'StaticCallSiteTransformer',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'recordedTypes',
		'receiver',
		'message',
		'nestedCallsVisitor',
		'filteredRecordedTypes',
		'messageToRecord',
		'changes'
	],
	#category : 'StaticCallsFinder-rewriting',
	#package : 'StaticCallsFinder',
	#tag : 'rewriting'
}

{ #category : 'accessing' }
StaticCallSiteTransformer class >> transform: aCandidate [

	1 halt.
]

{ #category : 'accessing' }
StaticCallSiteTransformer >> assignReceiverArgsToParent: newNode [

	{  newNode receiver.
		newNode arguments } flattened collect: [ :e | e parent: newNode ]
]

{ #category : 'bubbleUp' }
StaticCallSiteTransformer >> bubbleUpChangesInExecutionPath: aScpExecutionRecordTree startingFrom: firstNodeToBeTransformed [

	| found index scpNodeOrNil |
	found := false.
	index := 1.
	scpNodeOrNil := nil.
	scpNodeOrNil := aScpExecutionRecordTree methods
		                collect: [ :methodScp |
			                methodScp
				                findCorrespondingScpMessageNode:
				                firstNodeToBeTransformed
				                with: found ]
		                thenSelect: #isNotNil.

	scpNodeOrNil ifNotEmpty: [
		self rewriteAndDuplicateParentNode: scpNodeOrNil ].





]

{ #category : 'compiling' }
StaticCallSiteTransformer >> compileAstWithStaticNodes: newAst [

	| newMethod |

	ASTCache default at: newAst compiledMethod put: newAst.
newAst doSemanticAnalysis .
	newMethod := newAst generateMethod.
	ASTCache default at: newAst compiledMethod put: newAst.

	newMethod classBinding value
		addSelector: newMethod selector
		withMethod: newMethod.
		

]

{ #category : 'compiling' }
StaticCallSiteTransformer >> compileAstWithStaticNodesAndDuplicateMethod: newAst [

	| newMethod oldMethod |
	oldMethod := newAst compiledMethod.
	(newAst selector beginsWith: 'rwST') ifFalse: [
		newAst
			renameSelector: ('rwST' , newAst selector) asSymbol
			andArguments: newAst arguments ].

	newAst doSemanticAnalysis.
	newMethod := newAst generateMethod.
	newMethod propertyAt: #source put: newAst formattedCode.
	
	newMethod methodClass compile: newMethod sourceCode.

]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> eee [
[ ^ self foo ]
]

{ #category : 'check' }
StaticCallSiteTransformer >> existsDuplicateFor: aScpMethodTrace [

	^ (aScpMethodTrace node methodClass lookupSelector:
		 ('rwST' , aScpMethodTrace node selector) asSymbol) 
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> find: aRBMessageNode replaceWith: aRBStaticMessageNode in: aRBReturnNode [ 
	| e |
	(e:= (aRBReturnNode allChildren select: [ :e | e = aRBMessageNode ]) ) ifNotEmpty:[:e | e first replaceWith: aRBStaticMessageNode ].
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

	| newAst newMethod candidate astCachePerModifiedMethod |
	astCachePerModifiedMethod := Dictionary new.
	filteredRecordedTypes := PolymorphicCallSitesVisitor filterFakePoly:
		                         recordedTypes.
	filteredRecordedTypes do: [ :each |
		| currentAssociation |
		currentAssociation := each.

		"	(each key parent isMessage or:[ each key isStaticCall ]) ifTrue:[ 1 halt. ]"
		self receiver: each value values first asOrderedCollection first.
		candidate := StaticCallCandidate
			             method: each value keys first
			             callSite: each key
			             selector: each key methodNode selector
			             receiver:
			             each value values first asOrderedCollection first
			             receiverType: (each key receiver acceptVisitor: self).
		candidate receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
			self backupMethod: candidate callSite methodNode compiledMethod.
			newAst := astCachePerModifiedMethod
				          at: candidate callSite methodNode compiledMethod
				          ifAbsentPut: [ candidate callSite methodNode ].
			newAst := self transformCandidate: candidate.
			astCachePerModifiedMethod
				at: candidate callSite methodNode compiledMethod
				put: newAst ] ].

	astCachePerModifiedMethod associationsDo: [ :a |
		self compileAstWithStaticNodes: a value.
		[ self runBenchProgram ]
			on: Error
			do: [
				RollbackImageStaticBytecodes replaceMsgs:
					(newAst sendNodes select: #isStaticCall).
				self compileAstWithStaticNodes: a value ] ]
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> getNewMethodOfDevirtualizingAll2 [

	           | newAst newMethod candidate astCachePerModifiedMethod |
	     
	  astCachePerModifiedMethod := Dictionary new.
	           filteredRecordedTypes := PolymorphicCallSitesVisitor
		                                    filterFakePoly: recordedTypes.
	           filteredRecordedTypes do: [ :each |
		           | currentAssociation |
		           currentAssociation := each.
1 halt.    
		           "	(each key parent isMessage or:[ each key isStaticCall ]) ifTrue:[ 1 halt. ]"
		           self receiver:
			           each value values first asOrderedCollection first.
		           candidate := StaticCallCandidate
			                        method: each value keys first
			                        callSite: each key
			                        selector: each key methodNode selector
			                        receiver:
			                        each value values first asOrderedCollection
				                        first
			                        receiverType:
			                        (each key receiver acceptVisitor: self).
	candidate receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
			self backupMethod:
			candidate callSite methodNode compiledMethod.
			newAst := astCachePerModifiedMethod
				                     at:
				                     candidate callSite methodNode compiledMethod
				                     ifAbsentPut: [ candidate callSite methodNode ].
			newAst := self
				                     transformUpMethodNode: newAst forCandidate: candidate.
			astCachePerModifiedMethod
				           at: candidate callSite methodNode compiledMethod
				           put: newAst ] 
	].

	           astCachePerModifiedMethod associationsDo: [ :a |
		           self compileAstWithStaticNodes: a value.
			[ self runBenchProgram ] on: Error do:[
			RollbackImageStaticBytecodes replaceMsgs:( newAst sendNodes select: #isStaticCall).
			self compileAstWithStaticNodes: a value
			] .
		 ]
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> graduallyDevirtualize [

	           | newAst newMethod candidate astCachePerModifiedMethod |
	           astCachePerModifiedMethod := Dictionary new.
	           filteredRecordedTypes := PolymorphicCallSitesVisitor
		                                    boilDownToMonos: recordedTypes.
	           filteredRecordedTypes do: [ :each |
		           | currentAssociation |
		           currentAssociation := each.

		           "	(each key parent isMessage or:[ each key isStaticCall ]) ifTrue:[ 1 halt. ]"
		           self receiver:
			           each value values first asOrderedCollection first.
		           candidate := StaticCallCandidate
			                        method: each value keys first
			                        callSite: each key
			                        selector: each key methodNode selector
			                        receiver:
			                        each value values first asOrderedCollection
				                        first
			                        receiverType: MockObject any.
	candidate receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
			self backupMethod:
			candidate callSite methodNode compiledMethod.
			newAst := astCachePerModifiedMethod
				                     at:
				                     candidate callSite methodNode compiledMethod
				                     ifAbsentPut: [ candidate callSite methodNode ].
			newAst := self transformFirstWrappingStatementOfMessage:newAst forCandidate: candidate.
				                     
			astCachePerModifiedMethod
				           at: candidate callSite methodNode compiledMethod
				           put: newAst ] 
	].

	           astCachePerModifiedMethod associationsDo: [ :a |
		           self compileAstWithStaticNodes: a value .
			[ self runBenchProgram ] on: Error do:[
			RollbackImageStaticBytecodes replaceMsgs:( newAst sendNodes select: #isStaticCall)
				] 
		]
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> initialize [ 

	super initialize.
	changes:= OrderedCollection new.
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
	^ receiver
]

{ #category : 'accessing' }
StaticCallSiteTransformer >> receiver: aClass [
	receiver:= aClass
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> recordTrace: aCollection [ 
	messageToRecord:= aCollection.
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> recordedTypes [

	^ recordedTypes
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> recordedTypes: aTable [

	recordedTypes := aTable
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> replaceNodeRenameCallers: aRBStaticMessageNode as: aRBStaticMessageNode2 [ 
| record parallelMethodNode |
record:=messageToRecord at: aRBStaticMessageNode .
aRBStaticMessageNode replaceWith: aRBStaticMessageNode2. 
parallelMethodNode:= aRBStaticMessageNode methodNode copy.
parallelMethodNode selector: 'devirt_',parallelMethodNode selector.

self compileAstWithStaticNodes: parallelMethodNode .
1 halt .
record parent isMessage ifTrue: [ self replaceNodeRenameCallers: record parent node as: (record parent node copy selector: parallelMethodNode selector )  . ] ifFalse: [ record parent isMethod ifTrue: [   self replaceNodeRenameCallers: record parent parent node as: (record parent node copy selector: parallelMethodNode selector ) ] ]
.
1 halt.
]

{ #category : 'accessing' }
StaticCallSiteTransformer >> rewriteAndDuplicateParentNode: aCollection [

	| parent |
	parent := aCollection first parent.
	[ parent ] whileNotNil: [ "		self haltIf: (parent callSite selector beginsWith: 'rwST')."
		parent callSite
			propertyAt: #oldSelector
			ifAbsentPut: parent callSite selector.
		(self existsDuplicateFor: parent parent) ifNotNil: [
			:existingDuplicateMethod |
			| correspondingNode |
	
			correspondingNode := existingDuplicateMethod ast methodNode
				                     childAtPath: parent callSite pathInParent.
			(correspondingNode selector beginsWith: 'rwST')
				ifFalse: [
					correspondingNode selector:
						('rwST' , correspondingNode selector) asSymbol.
					^ self compileAstWithStaticNodesAndDuplicateMethod:
						  correspondingNode methodNode ]
				ifTrue: [ ^ nil ] ].
		parent callSite selector:
			('rwST' , (parent callSite propertyAt: #oldSelector)) asSymbol.
		self compileAstWithStaticNodesAndDuplicateMethod:
			parent callSite methodNode.

		parent parent isMessage
			ifTrue: [ parent := parent parent parent ]
			ifFalse: [ parent := parent parent ] ]
]

{ #category : 'running' }
StaticCallSiteTransformer >> rollbackBackedUpAst [
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> runBenchProgram [
	HGSimulator capuccinoPower .
]

{ #category : 'as yet unclassified' }
StaticCallSiteTransformer >> transformCallStack: aColOfCandidates withinPath: executionPath [
| newAst |
aColOfCandidates do:[:candidate | 
	newAst := self transformCandidate: candidate.

	"Treatement of every candidate must be done before compiling ast, to cumulate all changes and avoid duplicating or overriding modifications"

	self compileAstWithStaticNodesAndDuplicateMethod: newAst.

	self
		bubbleUpChangesInExecutionPath: executionPath
		startingFrom: (candidate callSite "propertyAt: #oldNode").
]
]

{ #category : 'refactoring' }
StaticCallSiteTransformer >> transformCandidate: aStaticCallCandidate [

	| newNode methodCopy nodeToRewriteInCopy methodNode writtenMethod |
	methodNode:= aStaticCallCandidate callSite methodNode .
	writtenMethod := methodNode methodClass lookupSelector: ('rwST', methodNode selector) asSymbol.
	writtenMethod ifNotNil:[
		methodCopy := writtenMethod methodNode copy.
		]ifNil: [
			methodCopy := aStaticCallCandidate callSite methodNode copy.
		].
		nodeToRewriteInCopy := methodCopy childAtPath:
		                       aStaticCallCandidate callSite pathInParent.

	newNode := (RBStaticMessageNode fromMessageNode: nodeToRewriteInCopy)
		           staticClass: aStaticCallCandidate receiverType.
	newNode propertyAt: #oldNode put: aStaticCallCandidate callSite.
	nodeToRewriteInCopy replaceWith: newNode.
	self assignReceiverArgsToParent: newNode.
	aStaticCallCandidate modifiedNode: (newNode propertyAt: #oldNode). 
	
	^ newNode methodNode
]

{ #category : 'transform' }
StaticCallSiteTransformer >> transformCandidates: candidateCollection [

	^ candidateCollection collect: [ :candidate |
		  self transformCandidate: candidate ]
]

{ #category : 'refactoring' }
StaticCallSiteTransformer >> transformFirstWrappingStatementOfMessage: aMethodNode forCandidate: aStaticCallCandidate [

	| visitor newNode result conservativeRefactor statementLink parentLink statementTochange lookFor |
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
				statementLink := newNode statementNode.
				parentLink := newNode statementNode parent.
				lookFor:=aStaticCallCandidate callSite copy.
	
			
			"conservativeRefactor :=" aStaticCallCandidate callSite replaceWith:(	RBMessageNode receiver: (RBMessageNode receiver: aStaticCallCandidate callSite receiver selector: #isKindOf: arguments:{  RBVariableNode named: (aStaticCallCandidate method classBinding value name) })  selector: #ifTrue:ifFalse: arguments: { "RBBlockNode body:" RBBlockNode body:( RBSequenceNode statements: {statementTochange := aStaticCallCandidate callSite statementNode copy }) . RBBlockNode body:( RBSequenceNode statements: {  aStaticCallCandidate callSite statementNode copy} )}) .
				self find: lookFor replaceWith: newNode in: statementTochange.
		
			  "aStaticCallCandidate callSite replaceWith: newNode.
				""aStaticCallCandidate callSite statementNode replaceWith: conservativeRefactor."
				"conservativeRefactor parent: parentLink." 
			  "statementLink replaceWith: conservativeRefactor."
			  result := newNode methodNode ]
		  ifFalse: [ aMethodNode ]
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
StaticCallSiteTransformer >> transformUpMethodNode: aMethodNode forCandidate: aStaticCallCandidate [

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
		1 halt.
			  newNode := (RBStaticMessageNode fromMessageNode:
				              aStaticCallCandidate callSite) staticClass:
				             aStaticCallCandidate receiverType.
				
			  self replaceNodeRenameCallers: aStaticCallCandidate callSite as:  newNode.
			   ]
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

	^ [(recordedTypes at: aMessageNode) keys first classBinding value] onErrorDo: [ nil ]
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitSelfNode: aSelfNode [
 ^ receiver class 
	
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitSuperNode: aSuperNode [

	^ receiver
]

{ #category : 'visiting' }
StaticCallSiteTransformer >> visitVariableNode: aVariableNode [

	^ receiver
]
