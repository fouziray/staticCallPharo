Class {
	#name : 'PathRewritingTest',
	#superclass : 'TestCase',
	#instVars : [
		'transformer',
		'candidate',
		'assocToModify',
		'executionPath',
		'candidate2',
		'executionPathMixedCalls1',
		'assocToModifyEmbeddedFirst',
		'assocToModifyEmbeddedSecond',
		'candidate1',
		'assocToModifyCallToEmbed',
		'candidateSecondLevel'
	],
	#category : 'StaticCallsFinder-rewriting',
	#package : 'StaticCallsFinder',
	#tag : 'rewriting'
}

{ #category : 'method examples' }
PathRewritingTest >> hasFloatStatic [

	2 _SmallInteger_factorial
]

{ #category : 'method examples' }
PathRewritingTest >> iCallMethodSecondLevel [

" We await a change to bubble up from the first level up to this call site, and it should be prefixedWith the new compiled method prefix too (to distinguish from other executions we also want to add a distinct id) "
	self iCallMethodToBeRewritten  
]

{ #category : 'method examples' }
PathRewritingTest >> iCallMethodSecondLevelToEmbedded [


	self iCallMethodToBeRewritten2Embedded  
]

{ #category : 'method examples' }
PathRewritingTest >> iCallMethodSecondLevelToSequencedCalls [


	self iCallMethodToBeRewritten2Sequence 
]

{ #category : 'method examples' }
PathRewritingTest >> iCallMethodSecondLevelTwice [


	self iCallMethodToBeRewritten2Sequence.
	self iCallMethodToBeRewritten2Embedded.
]

{ #category : 'method examples' }
PathRewritingTest >> iCallMethodToBeRewritten [

	self methodToBeRewritten
]

{ #category : 'method examples' }
PathRewritingTest >> iCallMethodToBeRewritten2Embedded [

		self methodToBeRewritten2 methodToBeRewritten .
 
]

{ #category : 'method examples' }
PathRewritingTest >> iCallMethodToBeRewritten2Sequence [

	self methodToBeRewritten.
	self methodToBeRewritten2 
]

{ #category : 'method examples' }
PathRewritingTest >> methodToBeRewritten [
	"Has no specific operation, everything inside is irrelevant to the rewriting"
	
	1 + 2 
]

{ #category : 'method examples' }
PathRewritingTest >> methodToBeRewritten2 [
	"Has no specific operation, everything inside is irrelevant to the rewriting"
	
	1 + 2  + 3
]

{ #category : 'remove' }
PathRewritingTest >> rollbackRewrittenMethods [

	( self class methodDictionary keys select:[ :e | e beginsWith: #rwST] ) do: [:e | self class removeSelector:e ].
	
]

{ #category : 'running' }
PathRewritingTest >> setUp [

	| receiverObject methodInTrace upperMethodInTrace methodInTraceNested1 upperMethodInTraceEmbedded |
	transformer := StaticCallSiteTransformer new.


	"Initializing Example with 1 level"
	self setUpCandidates.


	methodInTrace := ScpMethodTrace new
		                 result: (receiverObject := PathRewritingTest new);
		                 object: receiverObject;
		                 yourself.
	methodInTrace
		addChild: (ScpMessageTrace new
				 parent: methodInTrace;
				 receiver: receiverObject;
				 object: receiverObject;
				 node:
					 (PathRewritingTest >> #iCallMethodToBeRewritten) ast sendNodes
						 first);
		node: (PathRewritingTest >> #iCallMethodToBeRewritten) ast.

	upperMethodInTrace := ScpMethodTrace new
		                      result:
			                      (receiverObject := PathRewritingTest new);
		                      object: receiverObject;
		                      yourself.
	upperMethodInTrace
		addChild: (ScpMessageTrace new
				 receiver: methodInTrace;
				 object: methodInTrace;
				 node:
					 (PathRewritingTest >> #iCallMethodSecondLevel) ast sendNodes
						 first;
				 addChild: methodInTrace);
		node: (PathRewritingTest >> #iCallMethodSecondLevel) ast.
	methodInTrace parent: upperMethodInTrace.
	methodInTrace callSite:
		(PathRewritingTest >> #iCallMethodSecondLevel) ast sendNodes first.

	executionPath := ScpExecutionRecordTree new method:
		                 upperMethodInTrace.
	executionPath methods: { upperMethodInTrace } asOrderedCollection.




	methodInTraceNested1 := ScpMethodTrace new
		                        result:
			                        (receiverObject := PathRewritingTest new);
		                        object: receiverObject;
		                        yourself.
	methodInTraceNested1
		addChild: (ScpMessageTrace new
				 parent: methodInTraceNested1;
				 receiver: receiverObject;
				 object: receiverObject;
				 node:
					 (PathRewritingTest >> #iCallMethodToBeRewritten2Embedded) ast
						 sendNodes first);
		addChild: (ScpMessageTrace new
				 parent: methodInTraceNested1;
				 receiver: receiverObject;
				 object: receiverObject;
				 node:
					 (PathRewritingTest >> #iCallMethodToBeRewritten2Embedded) ast
						 sendNodes second);
		node: (PathRewritingTest >> #iCallMethodToBeRewritten2Embedded) ast.



	upperMethodInTraceEmbedded := ScpMethodTrace new
		                              result:
			                              (receiverObject := PathRewritingTest
				                                                 new);
		                              object: receiverObject;
		                              yourself.
	upperMethodInTraceEmbedded
		addChild: (ScpMessageTrace new
				 receiver: methodInTraceNested1;
				 object: methodInTraceNested1;
				 node:
					 (PathRewritingTest >> #iCallMethodSecondLevelToEmbedded) ast
						 sendNodes first;
				 addChild: methodInTraceNested1);
		node: (PathRewritingTest >> #iCallMethodSecondLevelToEmbedded) ast.
	methodInTraceNested1 parent: upperMethodInTraceEmbedded.

	methodInTraceNested1 callSite:
		(PathRewritingTest >> #iCallMethodSecondLevelToEmbedded) ast
			sendNodes first.


	executionPathMixedCalls1 := ScpExecutionRecordTree new method:
		                            upperMethodInTraceEmbedded.
	executionPathMixedCalls1 methods:
		{ upperMethodInTraceEmbedded } asOrderedCollection
]

{ #category : 'running' }
PathRewritingTest >> setUpCandidates [

	assocToModify := (PathRewritingTest >> #iCallMethodToBeRewritten) ast
		                 allChildren third
	                 ->
		                 (Dictionary newFrom:
			                  { (PathRewritingTest >> #methodToBeRewritten
			                   -> (Bag newFrom: { PathRewritingTest })) }).


	transformer receiver:
		assocToModify value values first asOrderedCollection first.


	assocToModifyEmbeddedFirst := (PathRewritingTest >> #iCallMethodToBeRewritten2Embedded ) ast
		                 allChildren fourth
	                 ->
		                 (Dictionary newFrom:
			                  { (PathRewritingTest >> #methodToBeRewritten2
			                   -> (Bag newFrom: { PathRewritingTest })). }).

	assocToModifyEmbeddedSecond := (PathRewritingTest >> #iCallMethodToBeRewritten2Embedded ) ast
		                 allChildren third
	                 ->
		                 (Dictionary newFrom:
			                  { (PathRewritingTest >> #methodToBeRewritten2
			                   -> (Bag newFrom: { PathRewritingTest })). }).

	candidate := StaticCallCandidate
		             method: assocToModify value keys first
		             callSite: assocToModify key
		             selector: assocToModify key methodNode selector
		             receiver:
		             assocToModify value values first asOrderedCollection
			             first
		             receiverType:
		             (assocToModify key receiver acceptVisitor: transformer).
candidate1 := StaticCallCandidate
		             method: assocToModifyEmbeddedSecond value keys first
		             callSite: assocToModifyEmbeddedSecond key
		             selector: assocToModifyEmbeddedSecond key methodNode selector
		             receiver:
		             assocToModifyEmbeddedSecond value values first asOrderedCollection
			             first
		             receiverType:
		             (PathRewritingTest).


	candidate2 := StaticCallCandidate
		              method: assocToModifyEmbeddedFirst value keys first
		              callSite: assocToModifyEmbeddedFirst key
		              selector: assocToModifyEmbeddedFirst key methodNode selector
		              receiver:
		              assocToModifyEmbeddedFirst value values first asOrderedCollection
			              first
		              receiverType:
		              (assocToModifyEmbeddedFirst key receiver acceptVisitor:
			               transformer).
			
	"This candidate has to be taken in consideration when rewriting its method selector a second time when bubbling up"
		"Two scenarios may happen"	
		assocToModifyCallToEmbed := (PathRewritingTest >> #iCallMethodSecondLevelToEmbedded ) ast
		                 allChildren third
	                 ->
		                 (Dictionary newFrom:
			                  { (PathRewritingTest >> #iCallMethodToBeRewritten2Embedded
			                   -> (Bag newFrom: { PathRewritingTest })). }).

		candidateSecondLevel := StaticCallCandidate
		              method: assocToModifyCallToEmbed value keys first
		              callSite: assocToModifyCallToEmbed key
		              selector: assocToModifyCallToEmbed key methodNode selector
		              receiver:
		              assocToModifyCallToEmbed value values first asOrderedCollection
			              first
		              receiverType:
		              (assocToModifyCallToEmbed key receiver acceptVisitor:
			               transformer).
]

{ #category : 'running' }
PathRewritingTest >> tearDown [ 

	RollbackImageStaticBytecodes default replaceSMsgWithNormal.
	self rollbackRewrittenMethods.
	
]

{ #category : 'tests' }
PathRewritingTest >> testAddingRewrittenDuplicatedMethodDoesNotModifyOriginalMethod [

	| newAst originalMethod originalAST |
	originalMethod := candidate callSite methodNode compiledMethod.
	originalAST := originalMethod ast.
	
	newAst := transformer transformCandidate: candidate.
	transformer compileAstWithStaticNodesAndDuplicateMethod: newAst.

	self assert: originalMethod ast == originalAST.
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingCallsiteChangesSendToStatic [

	| newAst |
	newAst := transformer transformCandidate: candidate.

	self assert:
		(newAst sendNodes anySatisfy: [ :each | each isStaticCall ])
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingCallsiteInstallsNewAST [

	| newAst methodBefore |
	methodBefore := candidate callSite methodNode compiledMethod.

	newAst := transformer transformCandidate: candidate.
	transformer compileAstWithStaticNodes: newAst.

	self assert: methodBefore ast == newAst
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingCallsiteWithoutInstallsDoesNotSetNewAST [

	| newAst methodBefore |
	methodBefore := candidate callSite methodNode compiledMethod.

	newAst := transformer transformCandidate: candidate.

	self assert: methodBefore ast ~~ newAst.
	self assert:
		(methodBefore ast sendNodes noneSatisfy: [ :each |
			 each isStaticCall ])
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath1LevelsRenamesCallerAndDuplicatedIt [

	| newAst methodBefore |
	methodBefore := candidate callSite methodNode compiledMethod.

	newAst := transformer transformCandidate: candidate.
	transformer compileAstWithStaticNodesAndDuplicateMethod: newAst.

	self
		assert: (methodBefore methodClass lookupSelector: ('rwST' , methodBefore selector) asSymbol)
		equals: methodBefore methodClass >> #rwSTiCallMethodToBeRewritten
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath2LevelsRenamesCallerCallSite [

	| newAst astCachePerModifiedMethod methodBefore |
	astCachePerModifiedMethod := Dictionary new.

	methodBefore := candidate callSite methodNode compiledMethod.

	transformer transformCallStack: {candidate } withinPath: executionPath .
	
	self
		assert: (methodBefore methodClass lookupSelector:
				 ('rwST' , methodBefore selector) asSymbol)
		equals: methodBefore methodClass >> #rwSTiCallMethodToBeRewritten.
	self
		assert:
			(methodBefore methodClass >> #rwSTiCallMethodSecondLevel) ast
				sendNodes first selector
		equals: #rwSTiCallMethodToBeRewritten
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath2LevelsTwoNestedCandidates [

	| newAst astCachePerModifiedMethod methodBefore |
	astCachePerModifiedMethod := Dictionary new.

		methodBefore := candidate1 callSite methodNode compiledMethod.
		newAst := astCachePerModifiedMethod
			          at: methodBefore
			          ifAbsentPut: [ candidate1 callSite methodNode ].
			
		transformer transformCallStack: {candidate1. candidate2 } withinPath: executionPathMixedCalls1 .
		
		self
			assert: (methodBefore methodClass lookupSelector:
					 ('rwST' , methodBefore selector) asSymbol)
			equals: PathRewritingTest >> #rwSTiCallMethodToBeRewritten2Embedded.
		self
			assert: executionPathMixedCalls1 methods first node selector
			equals: #rwSTiCallMethodSecondLevelToEmbedded.
		self
			assert:
			executionPathMixedCalls1 methods first node sendNodes first
				selector
			equals: #rwSTiCallMethodToBeRewritten2Embedded.

]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath2LevelsTwoNestedCandidatesAndOneInParent [

	| newAst astCachePerModifiedMethod methodBefore |
	astCachePerModifiedMethod := Dictionary new.

		methodBefore := candidate1 callSite methodNode compiledMethod.
		newAst := astCachePerModifiedMethod
			          at: methodBefore
			          ifAbsentPut: [ candidate1 callSite methodNode ].
			
		transformer transformCallStack: {candidate1. candidate2 . candidateSecondLevel} withinPath: executionPathMixedCalls1 .
		
		self
			assert: (methodBefore methodClass lookupSelector:
					 ('rwST' , methodBefore selector) asSymbol)
			equals: PathRewritingTest >> #rwSTiCallMethodToBeRewritten2Embedded.
		self
			assert: executionPathMixedCalls1 methods first node selector
			equals: #rwSTiCallMethodSecondLevelToEmbedded.
		self
			assert:
			executionPathMixedCalls1 methods first node sendNodes first
				selector
			equals: #rwSTiCallMethodToBeRewritten2Embedded.


]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath2LevelsTwoNestedCandidatesCompact [
|candidates|
candidates := { candidate1 . candidate2 }.
	((transformer transformCandidates: candidates ) do: [ :newAst | 
	transformer compileAstWithStaticNodesAndDuplicateMethod: newAst
	 ]) withIndexDo: [  :newAst :index| 		transformer
			bubbleUpChangesInExecutionPath: executionPathMixedCalls1
			startingFrom: ((candidates at: index ) oldNode).
			
			self
			assert: (newAst compiledMethod classBinding value lookupSelector:
					 ('rwST' , newAst selector) asSymbol)
			equals: PathRewritingTest >> #rwSTiCallMethodToBeRewritten2Embedded.
			  ] .
	
		self
			assert: executionPathMixedCalls1 methods first node selector
			equals: #rwSTiCallMethodSecondLevelToEmbedded.
		self
			assert:
			executionPathMixedCalls1 methods first node sendNodes first
				selector
			equals: #rwSTiCallMethodToBeRewritten2Embedded .
		self halt.
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath2LevelsTwoNestedCandidatesSecondLevelHasCandidate [

	| newAst astCachePerModifiedMethod methodBefore |
	astCachePerModifiedMethod := Dictionary new.

	candidate1 receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
		methodBefore := candidate1 callSite methodNode compiledMethod.
		newAst := astCachePerModifiedMethod
			          at: methodBefore
			          ifAbsentPut: [ candidate1 callSite methodNode ].
		newAst := transformer transformCandidate: candidate1.

		astCachePerModifiedMethod at: methodBefore put: newAst ].
	candidate2 receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
		methodBefore := candidate2 callSite methodNode compiledMethod."
			newAst := astCachePerModifiedMethod
				                     at:
				                     methodBefore
				                     ifAbsentPut: [ candidate2 callSite methodNode ]."
		newAst := transformer transformCandidate: candidate2.

		astCachePerModifiedMethod at: methodBefore put: newAst ].

	candidateSecondLevel receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
		methodBefore := candidateSecondLevel callSite methodNode
			                compiledMethod."
			newAst := astCachePerModifiedMethod
				                     at:
				                     methodBefore
				                     ifAbsentPut: [ candidate2 callSite methodNode ]."
		newAst := transformer transformCandidate: candidateSecondLevel.

		astCachePerModifiedMethod at: methodBefore put: newAst ].

	"Treatement of every candidate must be done before compiling ast, to cumulate all changes and avoid duplicating or overriding modifications"

	astCachePerModifiedMethod associationsDo: [ :a |
		transformer compileAstWithStaticNodesAndDuplicateMethod: a value.
		transformer
			bubbleUpChangesInExecutionPath: executionPathMixedCalls1
			startingFrom: (a value sendNodes first propertyAt: #oldNode).
		self
			assert: (a key compiledMethod classBinding value lookupSelector:
					 ('rwST' , a key selector) asSymbol)
			equals: PathRewritingTest >> #rwSTiCallMethodToBeRewritten2Embedded.
		self
			assert: executionPathMixedCalls1 methods first node selector
			equals: #rwSTiCallMethodSecondLevelToEmbedded.
		self
			assert:
			executionPathMixedCalls1 methods first node sendNodes first
				selector
			equals: #rwSTiCallMethodToBeRewritten2Embedded ]
]

{ #category : 'tests' }
PathRewritingTest >> testRollbackPath1Level [

	| newAst methodBefore |
	methodBefore := candidate callSite methodNode compiledMethod.

	newAst := transformer transformCandidate: candidate.
	transformer compileAstWithStaticNodes: newAst.

	RollbackImageStaticBytecodes default replaceSMsgWithNormal.

	self deny:
		(methodBefore ast sendNodes anySatisfy: [ :each | each isStaticCall ])
]
