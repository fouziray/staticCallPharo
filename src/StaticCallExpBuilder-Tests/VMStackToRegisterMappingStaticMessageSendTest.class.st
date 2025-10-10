Class {
	#name : 'VMStackToRegisterMappingStaticMessageSendTest',
	#superclass : 'VMStackToRegisterMappingCogitTest',
	#category : 'StaticCallExpBuilder-Tests',
	#package : 'StaticCallExpBuilder-Tests'
}

{ #category : 'patching' }
VMStackToRegisterMappingStaticMessageSendTest >> getInstrunctionsStartingFrom: start to: end [

	^ machineSimulator disassembler
		  printImmediatesInHexa;
		  useAlternatePrinterVariant;
		  disassembleNext: 150
		  instructionsIn:
			  (cogit objectMemory memoryManager copyFrom: start to: end)
		  startAddress: start
		  pc: machineSimulator instructionPointerRegisterValue
]

{ #category : 'helpers' }
VMStackToRegisterMappingStaticMessageSendTest >> initStack [

	self createBaseFrame.
	
	"Initialize Stack to the correct pointers in the selected page"
	machineSimulator smalltalkStackPointerRegisterValue: interpreter stackPointer.
	machineSimulator framePointerRegisterValue: interpreter framePointer.
	machineSimulator baseRegisterValue: cogit varBaseAddress.

	cogit setCStackPointer: interpreter rumpCStackAddress.
	cogit setCFramePointer: interpreter rumpCStackAddress.

]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> interpreterClass [

	^ CogVMSimulatorLSBCountingStaticLinks
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> myYourself [

	| x |
	x := self.
	^ x
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> setUp [ 

	super setUp.

	self setUpTrampolines.
	cogit generateEnilopmarts.
	
	cogit methodZoneBase: cogit methodZone freeStart.

	cogit computeEntryOffsets.

	self initStack.	

]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> setUpTrampolines [

	super setUpTrampolines.

	cogit methodAbortTrampolines at: 0 put: cogit ceMethodAbortTrampoline.
	cogit methodAbortTrampolines at: 1 put: cogit ceMethodAbortTrampoline.
	cogit methodAbortTrampolines at: 2 put: cogit ceMethodAbortTrampoline.
	cogit methodAbortTrampolines at: 3 put: cogit ceMethodAbortTrampoline.

	cogit picMissTrampolines at: 0 put: cogit ceCPICMissTrampoline.
	cogit picMissTrampolines at: 1 put: cogit ceCPICMissTrampoline.
	cogit picMissTrampolines at: 2 put: cogit ceCPICMissTrampoline.
	cogit picMissTrampolines at: 3 put: cogit ceCPICMissTrampoline.

	cogit picAbortTrampolines at: 0 put: cogit cePICAbortTrampoline.
	cogit picAbortTrampolines at: 1 put: cogit cePICAbortTrampoline.
	cogit picAbortTrampolines at: 2 put: cogit cePICAbortTrampoline.
	cogit picAbortTrampolines at: 3 put: cogit cePICAbortTrampoline.

	cogit ceStoreCheckTrampoline: (self
			 compileTrampoline: [ cogit RetN: 0 ]
			 named: #ceStoreCheckTrampoline).
	cogit objectRepresentation setAllStoreTrampolinesWith:
		(self compileTrampoline: [ cogit RetN: 0 ] named: #ceStoreTrampoline)
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendExecutesLinkedCall [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod builder staticCallTargetCogMethod |
	calledCompiledMethod := self createMethodOopFromHostMethod:
		                        self class >> #myYourself.

	selector := self newOldSpaceObjectWithSlots: 0.

	staticCallerCompiledMethod := methodBuilder newMethod
		                              literalAt: 0
		                              put: (memory integerObjectOf: 13);
		                              literalAt: 1
		                              put: calledCompiledMethod;
		                              literalAt: 2 put: selector;
		                              literalAt: 3 put: memory nilObject;
		                              bytecodes: #[ 32 246 1 92 ];
		                              buildMethod. "PushLiteral 1" "Static Send literal at 2" "Return top"

	cogit generateSendTrampolines.
	staticCallerCogMethod := cogit
		                         cog: staticCallerCompiledMethod
		                         selector: memory nilObject.
	staticCallTargetCogMethod := cogit
		                             cog: calledCompiledMethod
		                             selector: memory nilObject.


	builder := self machineCodeFrameBuilder.
	builder returnAddress: callerAddress.
	builder receiver: memory falseObject.
	builder method: staticCallerCogMethod.
	builder buildFrame.

	interpreter stackPointer:
		machineSimulator smalltalkStackPointerRegisterValue.
	interpreter framePointer: machineSimulator framePointerRegisterValue.

	"Push receiver, arg, then send"
	"interpreter push: (memory integerObjectOf: 13)."
	"	interpreter push: 16r320000460."

	"machineSimulator smalltalkStackPointerRegisterValue:
		interpreter stackPointer."



	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	"self openMachineDebuggerAt: staticCallerCogMethod address + cogit noCheckEntryOffset"

	self
		assert: machineSimulator instructionPointerRegisterValue
		equals: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
	self assert: interpreter staticCallLinkCounter equals: 1
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendExecutesLinkedCall2 [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod builder staticCallTargetCogMethod |
	calledCompiledMethod := self createMethodOopFromHostMethod:
		                        self class >> #myYourself.

	selector := self newOldSpaceObjectWithSlots: 0.

	staticCallerCompiledMethod := methodBuilder newMethod
		                              literalAt: 0
		                              put: (memory integerObjectOf: 13);
		                              literalAt: 1
		                              put: calledCompiledMethod;
		                              literalAt: 2 put: selector;
		                              literalAt: 3 put: memory nilObject;
		                              bytecodes: #[ 32 246 1 92 ];
		                              buildMethod. "PushLiteral 1" "Static Send literal at 2" "Return top"

	cogit generateSendTrampolines.
	staticCallerCogMethod := cogit
		                         cog: staticCallerCompiledMethod
		                         selector: memory nilObject.
	staticCallTargetCogMethod := cogit
		                             cog: calledCompiledMethod
		                             selector: memory nilObject.


	builder := self machineCodeFrameBuilder.
	builder returnAddress: callerAddress.
	builder receiver: memory falseObject.
	builder method: staticCallerCogMethod.
	builder buildFrame.

	interpreter stackPointer:
		machineSimulator smalltalkStackPointerRegisterValue.
	interpreter framePointer: machineSimulator framePointerRegisterValue.

	"Push receiver, arg, then send"
	"interpreter push: (memory integerObjectOf: 13)."
	"	interpreter push: 16r320000460."

	"machineSimulator smalltalkStackPointerRegisterValue:
		interpreter stackPointer."



	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
	"self openMachineDebuggerAt: staticCallerCogMethod address + cogit noCheckEntryOffset"

	self
		assert: machineSimulator instructionPointerRegisterValue
		equals: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
	self assert: interpreter staticCallLinkCounter equals: 1
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendExecutesUnlinkedCall [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod builder staticCallTargetCogMethod |
	calledCompiledMethod := self createMethodOopFromHostMethod:
		                        self class >> #myYourself.

	selector := self newOldSpaceObjectWithSlots: 0.

	staticCallerCompiledMethod := methodBuilder newMethod
		                              literalAt: 0
		                              put: (memory integerObjectOf: 13);
		                              literalAt: 1
		                              put: calledCompiledMethod;
		                              literalAt: 2 put: selector;
		                              literalAt: 3 put: memory nilObject;
		                              bytecodes: #[ 32 246 1 92 ];
		                              buildMethod. "PushLiteral 1" "Static Send literal at 2" "Return top"

	cogit generateSendTrampolines.
	staticCallerCogMethod := cogit
		                         cog: staticCallerCompiledMethod
		                         selector: memory nilObject.
	staticCallTargetCogMethod := cogit
		                             cog: calledCompiledMethod
		                             selector: memory nilObject.


	builder := self machineCodeFrameBuilder.
	builder returnAddress: callerAddress.
	builder receiver: memory falseObject.
	builder method: staticCallerCogMethod.
	builder buildFrame.

	interpreter stackPointer:
		machineSimulator smalltalkStackPointerRegisterValue.
	interpreter framePointer: machineSimulator framePointerRegisterValue.

	"Push receiver, arg, then send"
	"interpreter push: (memory integerObjectOf: 13)."
	"	interpreter push: 16r320000460."

	"machineSimulator smalltalkStackPointerRegisterValue:
		interpreter stackPointer."



	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	"Here we remove the method from compiled code space and see if the call site is linked back to its original state"

	"self openMachineDebuggerAt: staticCallerCogMethod address.
	"
	self createBaseFrame. 
	interpreter commenceCogCompiledCodeCompaction.
	cogit freeMethod: staticCallerCogMethod address.
	
	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	"self openMachineDebuggerAt: staticCallerCogMethod address + cogit noCheckEntryOffset"

	self
		assert: machineSimulator instructionPointerRegisterValue
		equals: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
	self assert: interpreter staticCallLinkCounter equals: 2
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendExecutesUnlinkedCall2 [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod builder staticCallTargetCogMethod |
	calledCompiledMethod := self createMethodOopFromHostMethod:
		                        self class >> #myYourself.

	selector := self newOldSpaceObjectWithSlots: 0.

	staticCallerCompiledMethod := methodBuilder newMethod
		                              literalAt: 0
		                              put: (memory integerObjectOf: 13);
		                              literalAt: 1
		                              put: calledCompiledMethod;
		                              literalAt: 2 put: selector;
		                              literalAt: 3 put: memory nilObject;
		                              bytecodes: #[ 32 246 1 92 ];
		                              buildMethod. "PushLiteral 1" "Static Send literal at 2" "Return top"

	cogit generateSendTrampolines.
	staticCallerCogMethod := cogit
		                         cog: staticCallerCompiledMethod
		                         selector: memory nilObject.
	staticCallTargetCogMethod := cogit
		                             cog: calledCompiledMethod
		                             selector: memory nilObject.


	builder := self machineCodeFrameBuilder.
	builder returnAddress: callerAddress.
	builder receiver: memory falseObject.
	builder method: staticCallerCogMethod.
	builder buildFrame.

	interpreter stackPointer:
		machineSimulator smalltalkStackPointerRegisterValue.
	interpreter framePointer: machineSimulator framePointerRegisterValue.

	"Push receiver, arg, then send"
	"interpreter push: (memory integerObjectOf: 13)."
	"	interpreter push: 16r320000460."

	"machineSimulator smalltalkStackPointerRegisterValue:
		interpreter stackPointer."



	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	"Here we remove the method from compiled code space and see if the call site is linked back to its original state"


	cogit freeMethod: staticCallTargetCogMethod.
	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
	"self openMachineDebuggerAt: staticCallerCogMethod address + cogit noCheckEntryOffset"

	self
		assert: machineSimulator instructionPointerRegisterValue
		equals: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
	self assert: interpreter staticCallLinkCounter equals: 2
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendOfCeStaticMethodAmelioration [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod builder staticCallTargetCogMethod |
	calledCompiledMethod := self createMethodOopFromHostMethod:
		                        self class >> #myYourself.

	selector := self newOldSpaceObjectWithSlots: 0.

	staticCallerCompiledMethod := methodBuilder newMethod
		                              literalAt: 0
		                              put: (memory integerObjectOf: 13);
		                              literalAt: 1
		                              put: calledCompiledMethod;
		                              literalAt: 2 put: selector;
		                              literalAt: 3 put: memory nilObject;
		                              bytecodes: #[ 32 246 1 92 ];
		                              buildMethod. "PushLiteral 1" "Static Send literal at 2" "Return top"

	cogit generateSendTrampolines.
	staticCallerCogMethod := cogit
		                         cog: staticCallerCompiledMethod
		                         selector: memory nilObject.
	staticCallTargetCogMethod := cogit
		                             cog: calledCompiledMethod
		                             selector: memory nilObject.


	builder := self machineCodeFrameBuilder.
	builder returnAddress: callerAddress.
	builder receiver: memory falseObject.
	builder method: staticCallerCogMethod.
	builder buildFrame.

	interpreter stackPointer:
		machineSimulator smalltalkStackPointerRegisterValue.
	interpreter framePointer: machineSimulator framePointerRegisterValue.

	"Push receiver, arg, then send"
	"interpreter push: (memory integerObjectOf: 13)."
	"	interpreter push: 16r320000460."

	"machineSimulator smalltalkStackPointerRegisterValue:
		interpreter stackPointer."

	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	self
		assert: machineSimulator instructionPointerRegisterValue
		equals: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.
	"We are at the beginning of the called method"

	"self
		assert: (interpreter stackValue: 3)
		equals: (memory integerObjectOf: 13).
	self assert: (interpreter stackValue: 1) equals: 16r320000460.
	self
		assert: machineSimulator pc
		equals: cogit getEnterCogCodePopReceiverReg"
]

{ #category : 'tests' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendOfCeStaticMethodIntialVersion [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod builder |

	calledCompiledMethod := self createMethodOopFromHostMethod: (Object >> #yourself).
	
	selector := self newOldSpaceObjectWithSlots: 0.
	
	staticCallerCompiledMethod := methodBuilder newMethod
			 literalAt: 0 put: (memory integerObjectOf: 13);
			 literalAt: 1 put: calledCompiledMethod;
			 literalAt: 2 put: selector;
			 literalAt: 3 put: memory nilObject;
			 bytecodes: #[32 "PushLiteral 1" 
				246 1 "Static Send literal at 2"
				92 "Return top"];
			 buildMethod.

	staticCallerCogMethod := cogit cog: staticCallerCompiledMethod selector: memory nilObject.

	builder := self machineCodeFrameBuilder.
	builder returnAddress: callerAddress.
	builder receiver: memory falseObject.
	builder method: staticCallerCogMethod.
	builder buildFrame.
	
	interpreter stackPointer: machineSimulator smalltalkStackPointerRegisterValue.
	interpreter framePointer: machineSimulator framePointerRegisterValue.
	
	"Push receiver, arg, then send"
	interpreter push: (memory integerObjectOf: 13).
	interpreter push: 16r320000460 .
	
	"Sending the static message will come back to the machine code, we need to stop it and see if we are in the correct place"
	[interpreter ceStaticSendInterpreted: calledCompiledMethod] 
		on: ReenterMachineCode 
		do: [] .

	self assert: interpreter stackTop equals: (memory integerObjectOf: 13).
	self assert: (interpreter stackValue: 1) equals: 16r320000460.
	self assert: machineSimulator pc equals: cogit getEnterCogCodePopReceiverReg 

]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendOfCoggedMethodCallMethodDirectly [

	| selector calledCompiledMethod calledCogMethod staticCallerCompiledMethod staticCallerCogMethod |

	calledCompiledMethod := self createMethodOopFromHostMethod: (Object >> #yourself).
	calledCogMethod := cogit cog: calledCompiledMethod selector: memory nilObject.
	
	selector := self newOldSpaceObjectWithSlots: 0.
	
	staticCallerCompiledMethod := methodBuilder newMethod
			 literalAt: 0 put: (memory integerObjectOf: 13);
			 literalAt: 1 put: calledCompiledMethod;
			 literalAt: 2 put: selector;
			 literalAt: 3 put: memory nilObject;
			 bytecodes: #[32 "PushLiteral 1" 
				246 1 "Static Send literal at 2"
				92 "Return top"];
			 buildMethod.

	staticCallerCogMethod := cogit cog: staticCallerCompiledMethod selector: memory nilObject.

	self createFramefulCallFrom: callerAddress.
	
	"Push receiver, arg, then send"
	self pushAddress: memory falseObject.

	self 
		runFrom: (staticCallerCogMethod address + cogit noCheckEntryOffset) 
		until: calledCogMethod address + cogit noCheckEntryOffset. 

	self assert: machineSimulator pc equals: calledCogMethod address + cogit noCheckEntryOffset
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendOfNonCoggedMethodActivatesCorrectMethod [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod |

	calledCompiledMethod := self createMethodOopFromHostMethod: (Object >> #yourself).
	
	selector := self newOldSpaceObjectWithSlots: 0.
	
	staticCallerCompiledMethod := methodBuilder newMethod
			 literalAt: 0 put: (memory integerObjectOf: 13);
			 literalAt: 1 put: calledCompiledMethod;
			 literalAt: 2 put: selector;
			 literalAt: 3 put: memory nilObject;
			 bytecodes: #[32 "PushLiteral 1" 
				246 1 "Static Send literal at 2"
				92 "Return top"];
			 buildMethod.

	staticCallerCogMethod := cogit cog: staticCallerCompiledMethod selector: memory nilObject.


	self createFramefulCallFrom: callerAddress.
	
	"Push receiver, arg, then send"
	self pushAddress: memory falseObject.

	self 
		runFrom: (staticCallerCogMethod address + cogit noCheckEntryOffset)  
		until: callerAddress.  
		
	self assert: machineSimulator receiverRegisterValue equals: (memory integerObjectOf: 13)
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendOfNonCoggedMethodCallsTrampoline [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod |

	calledCompiledMethod := self createMethodOopFromHostMethod: (Object >> #yourself).
	
	selector := self newOldSpaceObjectWithSlots: 0.
	
	staticCallerCompiledMethod := methodBuilder newMethod
			 literalAt: 0 put: (memory integerObjectOf: 13);
			 literalAt: 1 put: calledCompiledMethod;
			 literalAt: 2 put: selector;
			 literalAt: 3 put: memory nilObject;
			 bytecodes: #[32 "PushLiteral 1" 
				246 1 "Static Send literal at 2"
				92 "Return top"];
			 buildMethod.

	staticCallerCogMethod := cogit cog: staticCallerCompiledMethod selector: memory nilObject.

	self createFramefulCallFrom: callerAddress.
	
	"Push receiver, arg, then send"
	self pushAddress: memory falseObject.
	
	self 
		runFrom: (staticCallerCogMethod address + cogit noCheckEntryOffset) 
		until: cogit staticSendTrampoline0. 
	self assert: machineSimulator pc equals: cogit staticSendTrampoline0.
	self assert: machineSimulator classRegisterValue equals: calledCompiledMethod 
]

{ #category : 'as yet unclassified' }
VMStackToRegisterMappingStaticMessageSendTest >> testStaticSendPatching [

	| selector calledCompiledMethod staticCallerCompiledMethod staticCallerCogMethod builder staticCallTargetCogMethod instructionsBefore instructionsAfter |
	calledCompiledMethod := self createMethodOopFromHostMethod:
		                        self class >> #myYourself.

	selector := self newOldSpaceObjectWithSlots: 0.

	staticCallerCompiledMethod := methodBuilder newMethod
		                              literalAt: 0
		                              put: (memory integerObjectOf: 13);
		                              literalAt: 1
		                              put: calledCompiledMethod;
		                              literalAt: 2 put: selector;
		                              literalAt: 3 put: memory nilObject;
		                              bytecodes: #[ 32 246 1 92 ];
		                              buildMethod. "PushLiteral 1" "Static Send literal at 2" "Return top"

	cogit generateSendTrampolines.
	staticCallerCogMethod := cogit
		                         cog: staticCallerCompiledMethod
		                         selector: memory nilObject.
	staticCallTargetCogMethod := cogit
		                             cog: calledCompiledMethod
		                             selector: memory nilObject.


	builder := self machineCodeFrameBuilder.
	builder returnAddress: callerAddress.
	builder receiver: memory falseObject.
	builder method: staticCallerCogMethod.
	builder buildFrame.

	interpreter stackPointer:
		machineSimulator smalltalkStackPointerRegisterValue.
	interpreter framePointer: machineSimulator framePointerRegisterValue.

	"Push receiver, arg, then send"
	"interpreter push: (memory integerObjectOf: 13)."
	"	interpreter push: 16r320000460."

	"machineSimulator smalltalkStackPointerRegisterValue:
		interpreter stackPointer."


	instructionsBefore := self
		                      getInstrunctionsStartingFrom:
		                      staticCallerCogMethod address
		                      + cogit noCheckEntryOffset
		                      to: staticCallTargetCogMethod address
			                      + staticCallTargetCogMethod stackCheckOffset.

	self
		runFrom: staticCallerCogMethod address + cogit noCheckEntryOffset
		until: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset.

	instructionsAfter := self
		                     getInstrunctionsStartingFrom:
		                     staticCallerCogMethod address
		                     + cogit noCheckEntryOffset
		                     to: staticCallTargetCogMethod address
			                     + staticCallTargetCogMethod stackCheckOffset.

	{
		instructionsBefore.
		instructionsAfter }.
	self
		deny: (instructionsBefore collect: #asString)
		equals: (instructionsAfter collect: #asString).
	self
		deny: ((instructionsBefore collect: #asString) at: 23)
		equals: ((instructionsAfter collect: #asString) at: 23). "
self openMachineDebuggerAt: staticCallerCogMethod address + cogit noCheckEntryOffset"
	self
		assert: machineSimulator instructionPointerRegisterValue
		equals: staticCallTargetCogMethod address
			+ staticCallTargetCogMethod stackCheckOffset
	"We are at the beginning of the called method"

	"self
		assert: (interpreter stackValue: 3)
		equals: (memory integerObjectOf: 13).
	self assert: (interpreter stackValue: 1) equals: 16r320000460.
	self
		assert: machineSimulator pc
		equals: cogit getEnterCogCodePopReceiverReg"
]
