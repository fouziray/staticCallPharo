Class {
	#name : 'NewCompilerStaticCallTest',
	#superclass : 'TestCase',
	#category : 'StaticCallExp-Tests',
	#package : 'StaticCallExp-Tests'
}

{ #category : 'accessing' }
NewCompilerStaticCallTest >> foo [ 

	^ self _Object_as: NewCompilerStaticCallTest

]

{ #category : 'accessing' }
NewCompilerStaticCallTest >> foo2 [ 

	^ 2 _SmallInteger_+ 2
]

{ #category : 'tests first form bytecode' }
NewCompilerStaticCallTest >> testFirstCompilerEmitCorrectBytecode [

	| compiledMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ 13 _asCharacter'.
	self assert: (compiledMethod bytecodes at: 2) equals: 246
]

{ #category : 'tests first form' }
NewCompilerStaticCallTest >> testFirstFormMethodContainsStaticCall [

	| ast |
	ast := RBParser parseMethod: 'foo ^ 13 _asCharacter'.
	self 
		assert: ast children first statements first value class 
		equals: RBStaticMessageNode 
	
]

{ #category : 'tests first form IR' }
NewCompilerStaticCallTest >> testKeywordStaticCallIrStaticNode [

	| compiledMethod irMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ Object new _Object_as: self class'.
	irMethod := compiledMethod ast generateIR.
	
	self 
		assert: irMethod allSequences first sequence fifth calledMethod 
		equals: Object >> #as:
	
]

{ #category : 'tests' }
NewCompilerStaticCallTest >> testParsingBinaryStaticMessage [

	| ast |
	ast := RBParser parseExpression: '2 _SmallInteger_+ 2'.
	self assert: (ast isKindOf: RBStaticMessageNode).
	self 
		assert: ast staticClass 
		equals: SmallInteger. 
	self assert: ast selector isBinary.
	
]

{ #category : 'tests' }
NewCompilerStaticCallTest >> testParsingKeywordStaticMessage [

	| ast |
	ast := RBParser parseExpression: '2 _Object_as: 2'.
	self assert: (ast isKindOf: RBStaticMessageNode).
	self 
		assert: ast staticClass 
		equals: Object. 
	self assert: ast selector isKeyword
	
]

{ #category : 'tests' }
NewCompilerStaticCallTest >> testParsingUnaryStaticMessage [

	| ast |
	ast := RBParser parseExpression: '2 _Integer_factorial'.
	"factorial is defined in Integer"
	
	self assert: (ast isKindOf: RBStaticMessageNode).
	self 
		assert: ast staticClass 
		equals: Integer. 
	self assert: ast selector isUnary
	
]

{ #category : 'tests' }
NewCompilerStaticCallTest >> testParsingUnknownStaticMessage [

	| ast |
	ast := RBParser parseExpression: '2 _TINTIN_as: 2'.
	self assert: (ast isKindOf: RBStaticMessageNode).
	self 
		assert: ast staticClass 
		equals: nil. 
	self assert: ast selector isKeyword
	
]

{ #category : 'tests first form' }
NewCompilerStaticCallTest >> testStaticClassIsDefined [  

	| ast |
	ast := RBParser parseExpression: 'true _SmallInteger_asFloat'.
	self 
		assert: ast staticClass 
		equals: SmallInteger
]

{ #category : 'tests first form' }
NewCompilerStaticCallTest >> testStaticMessageNodeCreation [

	| ast |
	ast := RBParser parseExpression: '13 _factorial'.
	self assert: ast class equals: RBStaticMessageNode
	
]

{ #category : 'tests first form IR' }
NewCompilerStaticCallTest >> testUnaryStaticCallIrStaticNode [

	| compiledMethod irMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ 13 _asCharacter'.
	irMethod := compiledMethod ast generateIR.
	
	self 
		assert: irMethod allSequences first sequence second calledMethod 
		equals: SmallInteger >> #asCharacter
	
]
