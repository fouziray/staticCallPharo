Extension { #name : 'VMTrampolineTest' }

{ #category : '*StaticCallExpBuilder-Tests' }
VMTrampolineTest >> testStaticSendTrampoline [
	"  replicated from testSendTrampolineShouldNotOverrideLinkRegisterWhenCallDereferenceSelectorRoutine
"

	| dereferenceRoutine previousLinkRegister trampoline |
	"This trampoline is only valid for ARMv8"
	cogit backend hasLinkRegister ifFalse: [ ^ self skip ].
	self wordSize = 8 ifFalse: [ ^ self skip ].

	dereferenceRoutine := self compile: [ cogit RetN: 0 ].
	cogit ceDereferenceSelectorIndex: dereferenceRoutine.

	trampoline := self
		              compileWithoutOutput: [
			              cogit
				              genStaticSendTrampolineFor:
				              #ceStaticSend:to:numArgs:
				              numArgs: 1
				              called: 'test'
				              arg: ClassReg ]
		              bytecodes: 1. "hint for IR allocation"

	machineSimulator baseRegisterValue: cogit varBaseAddress.
	machineSimulator linkRegisterValue: (previousLinkRegister := 42).

	"self runFrom: trampoline until: #ceStaticSend:to:numArgs:"
	1 halt.
	self
		runFrom: trampoline
		until: (cogit simulatedTrampolineFor: #ceStaticSend:to:numArgs:).

	"The generated code should push the correct link register in the stack.
	The link register should now reference the IP where the trampoline is suspended."
	self assert: self interpreter stackTop equals: previousLinkRegister
]
