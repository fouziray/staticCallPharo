Extension { #name : 'CoInterpreter' }

{ #category : '*StaticCallExpBuilder' }
CoInterpreter >> ceStaticSendInterpreted: aCompiledMethodOop [

	<api>
	| primitiveIndex |
	instructionPointer := self popStack.
	newMethod := aCompiledMethodOop.

	primitiveIndex := self primitiveIndexOf: newMethod.
	primitiveFunctionPointer := self functionPointerFor: primitiveIndex inClass: nil.

	self executeNewMethod: false.
	self returnToExecutive: false	
]
