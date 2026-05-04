Class {
	#name : 'CompilerStaticCallTest',
	#superclass : 'TestCase',
	#category : 'StaticCallExp-Tests',
	#package : 'StaticCallExp-Tests'
}

{ #category : 'tests - parsing' }
CompilerStaticCallTest >> testMethodContainsStaticCall [

	| ast |
	
	ast := RBParser parseMethod: 'foo ^ 13 _factorial'.
	self assert: ast children first statements first value class equals: RBStaticMessageNode 
	
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testParsingBinaryStaticMessage [

	| compiledMethod irMethod |

	compiledMethod := RBParser parseExpression: ' 
	|aCol|
	aCol := OrderedCollection new.
	^ 2 _SmallInteger_+ 2'.

	self assert: (compiledMethod statements second children first isKindOf: RBStaticMessageNode) .
	self assert: compiledMethod statements second children first isBinary.
	
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testParsingKeywordStaticMessage [

	| compiledMethod irMethod |

	compiledMethod := RBParser parseExpression: ' 
	|aCol|
	aCol := OrderedCollection new.
	^ 2 _Object_as: 2'.

	self assert: (compiledMethod statements second children first isKindOf: RBStaticMessageNode) .

	
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticCallIrStaticNode [

	| compiledMethod irMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ 13 _myFactorial'.
	
	irMethod := compiledMethod ast generateIR.
	
	self assert: irMethod allSequences first sequence second calledMethod equals: SmallInteger >>#myFactorial
	
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticCallIrStaticNodeBinary [

	| compiledMethod irMethod |

	compiledMethod := CompilerStaticCallTest compile: 'foo2 
	|aCol|
	aCol := OrderedCollection new.
	^ 2 _SmallInteger_+ 2'.
	irMethod :=  (CompilerStaticCallTest>>#foo2) ast generateIR.
	self assert: irMethod allSequences first sequence seventh calledMethod equals: SmallInteger>>#+
	
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticCallIrStaticNodeKeyword [

	| compiledMethod irMethod |

	compiledMethod := CompilerStaticCallTest compile: 'foo 
	|aCol|
	aCol := OrderedCollection new.
	^ self _Object_as: CompilerStaticCallTest'.
	
	irMethod :=  (CompilerStaticCallTest>>#foo) ast generateIR.
	self assert: irMethod allSequences first sequence seventh calledMethod equals: Object >>#as:
	
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticCallIsInLiteralFrame [

	| compiledMethod irMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ 13 _myFactorial'.

compiledMethod literal.
	self
		assert: irMethod allSequences first sequence second calledMethod
		equals: SmallInteger >> #myFactorial
]

{ #category : 'tests' }
CompilerStaticCallTest >> testStaticCallOnVariableWithClassTag [

	| aVariable |
	aVariable := 4.
	self assert: aVariable _Integer_factorial equals: 4 factorial
]

{ #category : 'tests' }
CompilerStaticCallTest >> testStaticCallRunOnNewVM [

	self assert: 13 _asFloat equals: 13 asFloat
]

{ #category : 'tests' }
CompilerStaticCallTest >> testStaticCallWithClassTag [

	self assert: (4 _Integer_factorial) equals: (4 factorial)
]

{ #category : 'tests' }
CompilerStaticCallTest >> testStaticInvokeMethodWithArgs [

	self assert: (( Integer>>#factorial )  invokeWithReceiver:  6 withArgs: {} ) equals: ( 6 factorial)
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticMessageCompilerEmitCorrectBytecode [

	| compiledMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ 13 _myFactorial'.

	self assert: (compiledMethod bytecodes at: 2) equals: 246
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticMessageFalseReceiver [

self should:  [true _SmallInteger_asFloat] raise:  Exception . 

]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticMessageKeyword [

	| compiledMethod |
	compiledMethod := OpalCompiler new compile: 'foo 
	|aCol|
	
	aCol := OrderedCollection new.
	^ self _Object_appendTo: aCol'.

	self assert: (compiledMethod bytecodes at: 6) equals: 246
]

{ #category : 'tests - parsing' }
CompilerStaticCallTest >> testStaticMessageNodeCreation [

	| ast |
	
	ast := RBParser parseExpression: '13 _factorial'.
	self assert: ast class equals: RBStaticMessageNode
	
]
