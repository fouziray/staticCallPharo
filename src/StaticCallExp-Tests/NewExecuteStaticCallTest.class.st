Class {
	#name : 'NewExecuteStaticCallTest',
	#superclass : 'TestCase',
	#category : 'StaticCallExp-Tests',
	#package : 'StaticCallExp-Tests'
}

{ #category : 'tests - second form' }
NewExecuteStaticCallTest >> testStaticCallOnVariableWithClassTag [

	| aVariable |
	aVariable := 4.
	self assert: aVariable _Integer_factorial equals: 4 factorial
]

{ #category : 'tests - second form' }
NewExecuteStaticCallTest >> testStaticCallWithClassTag [
	
	self assert: 
		((self class >> #withStaticCall) bytecodes at: 2)
		equals: 246.
	self 
		assert: self withStaticCall 
		equals: 4 factorial
]

{ #category : 'tests - second form' }
NewExecuteStaticCallTest >> withStaticCall [

	^ 4 _Integer_factorial 
		
]
