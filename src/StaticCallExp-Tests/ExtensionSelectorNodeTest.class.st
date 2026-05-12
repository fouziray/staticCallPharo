Class {
	#name : 'ExtensionSelectorNodeTest',
	#superclass : 'TestCase',
	#category : 'StaticCallExp-Tests',
	#package : 'StaticCallExp-Tests'
}

{ #category : 'tests' }
ExtensionSelectorNodeTest >> testBinaryStaticSelector [
	
	| sel |
	sel := RBSelectorNode value: '_Integer_+'.
	self 
		assert: sel extractStaticSelector
		equals: '+'
]

{ #category : 'tests' }
ExtensionSelectorNodeTest >> testKeywordStaticSelector [
	
	| sel |
	sel := RBSelectorNode value: '_SmallInteger_between:and:'.
	self 
		assert: sel extractStaticSelector
		equals: 'between:and:'
]

{ #category : 'tests' }
ExtensionSelectorNodeTest >> testKeywordStaticSelectorSingleKeyword [
	
	| sel |
	sel := RBSelectorNode value: '_SmallInteger_as:'.
	self 
		assert: sel extractStaticSelector
		equals: 'as:'
]

{ #category : 'tests' }
ExtensionSelectorNodeTest >> testSelectorNodeStaticClass [
	
	| sel |
	sel := RBSelectorNode value: '_SmallInteger_as:'.
	self 
		assert: sel extractStaticClass
		equals: 'SmallInteger'
]

{ #category : 'tests mutation' }
ExtensionSelectorNodeTest >> testSetPrimarySelector [
	
	| sel |
	sel := RBSelectorNode value: '_Integer_+'.
	sel setPrimarySelector.
	self 
		assert: sel value
		equals: '+'
]

{ #category : 'tests' }
ExtensionSelectorNodeTest >> testUnaryStaticSelector [
	
	| sel |
	sel := RBSelectorNode value: '_Integer_factorial'.
	self 
		assert: sel extractStaticSelector
		equals: 'factorial'
]
