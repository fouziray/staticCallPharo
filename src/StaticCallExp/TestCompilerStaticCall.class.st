Class {
	#name : 'TestCompilerStaticCall',
	#superclass : 'TestCase',
	#category : 'StaticCallExp',
	#package : 'StaticCallExp'
}

{ #category : 'tests - parsing' }
TestCompilerStaticCall >> testMethodContainsStaticCall [

	| ast |
	
	ast := RBParser parseMethod: 'foo ^ 13 _factorial'.
	self assert: ast children first statements first value class equals: RBStaticMessageNode 
	
]

{ #category : 'tests' }
TestCompilerStaticCall >> testStaticCallOnVariableWithClassTag [

	| aVariable |
	aVariable := 4.
	self assert: aVariable _Integer_factorial equals: 4 factorial
]

{ #category : 'tests' }
TestCompilerStaticCall >> testStaticCallRunOnNewVM [

	self assert: 13 _asFloat equals: 13 asFloat
]

{ #category : 'tests' }
TestCompilerStaticCall >> testStaticCallWithClassTag [

	self assert: (4 _Integer_factorial) equals: (4 factorial)
]

{ #category : 'tests' }
TestCompilerStaticCall >> testStaticInvokeMethodWithArgs [

	self assert: (( Integer>>#factorial )  invokeWithReceiver:  6 withArgs: {} ) equals: ( 6 factorial)
]

{ #category : 'tests - compiler' }
TestCompilerStaticCall >> testStaticMessageCompilerEmitCorrectBytecode [

	| compiledMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ 13 _myFactorial'.
	compiledMethod ast.
	self assert: (compiledMethod bytecodes at: 2) equals: 246
]

{ #category : 'tests - compiler' }
TestCompilerStaticCall >> testStaticMessageFalseReceiver [

self deny: true _SmallInteger_asFloat

]

{ #category : 'tests - parsing' }
TestCompilerStaticCall >> testStaticMessageNodeCreation [

	| ast |
	
	ast := RBParser parseExpression: '13 _factorial'.
	self assert: ast class equals: RBStaticMessageNode
	
]
