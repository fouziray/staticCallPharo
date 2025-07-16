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
CompilerStaticCallTest >> testStaticCallIrStaticNode [

	| compiledMethod irMethod |
	compiledMethod := OpalCompiler new compile: 'foo ^ 13 _myFactorial'.
	
	irMethod := compiledMethod ast generateIR.
	
	self assert: irMethod allSequences first sequence second calledMethod equals: SmallInteger >>#myFactorial
	
]

{ #category : 'tests - compiler' }
CompilerStaticCallTest >> testStaticCallIrStaticNodeKeyword [

	| compiledMethod irMethod |
	compiledMethod := CompilerStaticCallTest compile: 'foo 
	|aCol|
	aCol := OrderedCollection new.
	^ self _Object_as: CompilerStaticCallTest'.
	
	irMethod := (CompilerStaticCallTest>>#foo) ast generateIR.
	self assert: (irMethod allSequences first sequence at: 7)  calledMethod equals: (Object >>#as:)
	
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

self deny: true _SmallInteger_asFloat

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
