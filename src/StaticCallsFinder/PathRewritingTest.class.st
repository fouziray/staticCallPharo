Class {
	#name : 'PathRewritingTest',
	#superclass : 'TestCase',
	#instVars : [
		'transformer',
		'candidate',
		'assocToModify'
	],
	#category : 'StaticCallsFinder-rewriting',
	#package : 'StaticCallsFinder',
	#tag : 'rewriting'
}

{ #category : 'as yet unclassified' }
PathRewritingTest >> iCallMethodToBeRewritten [

	self methodToBeRewritten 
]

{ #category : 'as yet unclassified' }
PathRewritingTest >> methodToBeRewritten [
	"Has no specific operation, everything inside is irrelevant to the rewriting"
	
	1 + 2
]

{ #category : 'as yet unclassified' }
PathRewritingTest >> rwSTiCallMethodToBeRewritten [

	self _PathRewritingTest_methodToBeRewritten
]

{ #category : 'as yet unclassified' }
PathRewritingTest >> rwSTiCallMethodToBeRewritten1 [

	self _PathRewritingTest_methodToBeRewritten
]

{ #category : 'as yet unclassified' }
PathRewritingTest >> rwSTiCallMethodToBeRewritten2 [

	self _PathRewritingTest_methodToBeRewritten
	"to update hte changes just use compiledmethod propertyAt: #source put: compiledmethod ast reformatSource"
]

{ #category : 'running' }
PathRewritingTest >> setUp [ 

	transformer:= StaticCallSiteTransformer new.
	

"Initializing Example with 1 level"		
		
	assocToModify := (PathRewritingTest >>#iCallMethodToBeRewritten ) ast allChildren  third -> (Dictionary newFrom: {  (PathRewritingTest >>#methodToBeRewritten ) -> (Bag newFrom: { PathRewritingTest })  }) .

	transformer receiver: assocToModify value values first asOrderedCollection first.
	
	candidate := StaticCallCandidate
			                        method: assocToModify value keys first
			                        callSite: assocToModify key
			                        selector: assocToModify key methodNode selector
			                        receiver:
			                        assocToModify value values first asOrderedCollection
				                        first
			                        receiverType:
			                        (assocToModify key receiver acceptVisitor: transformer).

]

{ #category : 'running' }
PathRewritingTest >> tearDown [ 

	RollbackImageStaticBytecodes default replaceSMsgWithNormal
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath1Level [
	
	 |assocToModify candidate newAst astCachePerModifiedMethod methodBefore |
	
	astCachePerModifiedMethod := Dictionary new.
	
	assocToModify:= (PathRewritingTest >>#iCallMethodToBeRewritten ) ast allChildren  third -> (Dictionary newFrom: {  (PathRewritingTest >>#methodToBeRewritten ) -> (Bag newFrom: { PathRewritingTest })  }) .

	transformer receiver: assocToModify value values first asOrderedCollection first.
	
	candidate := StaticCallCandidate
			                        method: assocToModify value keys first
			                        callSite: assocToModify key
			                        selector: assocToModify key methodNode selector
			                        receiver:
			                        assocToModify value values first asOrderedCollection
				                        first
			                        receiverType:
			                        (assocToModify key receiver acceptVisitor: transformer).

	candidate receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
			methodBefore := candidate callSite methodNode compiledMethod.
			transformer backupMethod: methodBefore.
			newAst := astCachePerModifiedMethod
				                     at:
				                     methodBefore
				                     ifAbsentPut: [ candidate callSite methodNode ].
			newAst := transformer 
				                     transformMethodNode: newAst
				                     forCandidate: candidate.
			astCachePerModifiedMethod
				           at: methodBefore
				           put: newAst ].
			  
	           astCachePerModifiedMethod associationsDo: [ :a |
		           transformer compileAstWithStaticNodes: a value.
		
		self assert: (a key ast sendNodes anySatisfy:[:each | each isStaticCall]) . 
			"[ self runBenchProgram ] on: Error do:[
			RollbackImageStaticBytecodes replaceMsgs:( newAst sendNodes select: #isStaticCall).
			self compileAstWithStaticNodes: a value
			]" .
		RollbackImageStaticBytecodes default replaceSMsgWithNormal .
		
		self deny: (a key ast sendNodes anySatisfy:[:each | each isStaticCall])
		
		].
	
	
]

{ #category : 'tests' }
PathRewritingTest >> testRewritingPath1LevelsRenamesCallerAndDuplicatedIt [
	
	 | newAst astCachePerModifiedMethod methodBefore |
	
	astCachePerModifiedMethod := Dictionary new.

	candidate receiverType ifNotNil: [ " transformMethod:
		          candidate callSite methodNode compiledMethod
		          forCandidate: candidate."
			methodBefore := candidate callSite methodNode compiledMethod.
			transformer backupMethod: methodBefore.
			newAst := astCachePerModifiedMethod
				                     at:
				                     methodBefore
				                     ifAbsentPut: [ candidate callSite methodNode ].
			newAst := transformer 
				                     transformMethodNode: newAst
				                     forCandidate: candidate.
			astCachePerModifiedMethod
				           at: methodBefore
				           put: newAst ].
			  
	           astCachePerModifiedMethod associationsDo: [ :a |
		           transformer compileAstWithStaticNodesAndDuplicateMethod: a value.
		RollbackImageStaticBytecodes default replaceMsgs: a key ast sendNodes first.
		
		self deny: (a key ast sendNodes anySatisfy:[:each | each isStaticCall]) . 
		self assert: (a key compiledMethod classBinding value lookupSelector: ('rwST',a key selector) asSymbol ) equals: PathRewritingTest>>#rwSTiCallMethodToBeRewritten.
		
			"[ self runBenchProgram ] on: Error do:[
			RollbackImageStaticBytecodes replaceMsgs:( newAst sendNodes select: #isStaticCall).
			self compileAstWithStaticNodes: a value
			]" .
		RollbackImageStaticBytecodes default replaceSMsgWithNormal .
		
		
		].
	
	
]
