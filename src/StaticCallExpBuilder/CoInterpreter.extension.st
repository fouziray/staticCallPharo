Extension { #name : 'CoInterpreter' }

{ #category : '*StaticCallExpBuilder' }
CoInterpreter >> ceStaticSend: methodToGoTo to: rcvr numArgs: numArgs [
	"Entry-point for an unlinked static send in a CogMethod.  Smalltalk stack looks like
					receiver
					args
		head sp ->	sender return pc
		
	If an MNU then defer to handleMNUInMachineCodeTo:... which will dispatch the MNU and
	may choose to allocate a closed PIC with a fast MNU dispatch for this send.  Otherwise
	attempt to link the send site as efficiently as possible.  All link attempts may fail; e.g.
	because we're out of code memory.

	Continue execution via either executeMethod or interpretMethodFromMachineCode:
	depending on whether the target method is cogged or not."

	<api>
	<inline: false>
	<var: #cogMethod type: #'CogMethod *'>
	<var: #newCogMethod type: #'CogMethod *'>
	| cogMethod primitiveIndex |
	cogit assertCStackWellAligned.
	self assert: (objectMemory addressCouldBeOop: rcvr).

	newMethod := methodToGoTo.
	"Maybe we need to put the selector as argument?"
	messageSelector := objectMemory nilObject.
	argumentCount := numArgs.
	primitiveIndex := self primitiveIndexOf: newMethod.
	primitiveFunctionPointer := self
		                            functionPointerFor: primitiveIndex
		                            inClass: nil.

	
	cogMethod := self
		             ensureMethodIsCogged: newMethod
		             maybeClosure: objectMemory nilObject.
	"Method found and has a cog method.  Attempt to link to it.  The receiver's class may be young.
	 If the Cogit can't store young classes in inline caches we can link to an open PIC instead."
	(self maybeMethodHasCogMethod: newMethod) ifTrue: [
		cogMethod := self cogMethodOf: newMethod.

		cogit
			linkSendAt: (stackPages longAt: stackPointer)
			in: (self mframeHomeMethod: framePointer)
			to: cogMethod
			offset: cogit noCheckEntryOffset
			receiver: rcvr.

		instructionPointer := self popStack.
		self executeNewMethod.
		self unreachable ].
	instructionPointer := self popStack.
	self interpretMethodFromMachineCode.
	self unreachable
]

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
