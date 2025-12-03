Class {
	#name : 'PartialEvaluatorTest',
	#superclass : 'TestCase',
	#instVars : [
		'evaluator'
	],
	#category : 'StaticCallsFinder-tests',
	#package : 'StaticCallsFinder',
	#tag : 'tests'
}

{ #category : 'running' }
PartialEvaluatorTest >> setUp [
    super setUp.
    evaluator := PartialEvaluator new

]

{ #category : 'flow-insensitive' }
PartialEvaluatorTest >> testComplexArithmetic [
	"Test nested message expression (a + b) * c"

	| ast result |
	evaluator setKnownValue: #a to: 2.
	evaluator setKnownValue: #b to: 3.
	evaluator setKnownValue: #c to: 4.

	ast := RBMessageNode
		       receiver: (RBMessageNode
				        receiver: (RBVariableNode named: 'a')
				        selector: #+
				        arguments: { (RBVariableNode named: 'b') })
		       selector: #*
		       arguments: { (RBVariableNode named: 'c') }.

	result := evaluator evaluate: ast.
	self assert: result equals: 20
]

{ #category : 'flow-sensitive' }
PartialEvaluatorTest >> testIfWithKnownCondition [

    | ast result |
    evaluator setKnownValue: #bool to: true.
    
    ast := RBMessageNode
        receiver: (RBVariableNode named: 'bool')
        selector: #ifTrue:ifFalse: 
        arguments:{(RBBlockNode body: (RBSequenceNode statements: {(RBLiteralNode value: 1)}) ). (RBBlockNode body: (RBSequenceNode statements: {RBLiteralNode value: 0}) )}.
    
    result := evaluator evaluate: ast.
    self assert: result equals: 1
]

{ #category : 'flow-insensitive' }
PartialEvaluatorTest >> testLiteralEvaluation [

    | result |
    result := evaluator evaluate: (RBLiteralNode value: 42).
    self assert: result equals: 42.
    
    result := evaluator evaluate: (RBLiteralNode value: 'hello').
    self assert: result equals: 'hello'.
    
    result := evaluator evaluate: (RBLiteralNode value: true).
    self assert: result equals: true
]

{ #category : 'flow-insensitive' }
PartialEvaluatorTest >> testPartialAddition [

    | ast result |
    evaluator setKnownValue: #x to: 5.

    ast := RBMessageNode
        receiver: (RBVariableNode named: 'x')
        selector: #+
        arguments: { RBVariableNode named: 'y' }.
 
    result := evaluator evaluate: ast.
    self assert: (result isKindOf: RBMessageNode).
    self assert: (result arguments first isKindOf: RBVariableNode).
  	 self assert: (evaluator getKnownValue: result receiver value name) equals: 5.
  

]

{ #category : 'flow-insensitive' }
PartialEvaluatorTest >> testSimpleAddition [

    | ast result |
    evaluator setKnownValue: #x to: 5.
    evaluator setKnownValue: #y to: 3.
    
    ast := RBMessageNode
        receiver: (RBVariableNode named: 'x')
        selector: #+
        arguments: { RBVariableNode named: 'y' }.
    
    result := evaluator evaluate: ast.
    self assert: result equals: 8
]

{ #category : 'flow-insensitive' }
PartialEvaluatorTest >> testVariableWithoutKnownValue [

    | varNode result |
    varNode := RBVariableNode named: 'unknown'.
    result := evaluator evaluate: varNode.
    self assert: result equals: varNode.
    self assert: (result isKindOf: RBVariableNode)

]
