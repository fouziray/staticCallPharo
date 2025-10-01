Extension { #name : 'StackToRegisterMappingCogit' }

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> genSend: selectorIndex numArgs: numArgs [
1 halt.
	self marshallSendArguments: numArgs.
	^ self
		  genMarshalledSend: selectorIndex
		  numArgs: numArgs
		  sendTable: ordinarySendTrampolines
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> genSendStaticMessage [

	| methodLiteralIndex argumentCount methodToGoTo jumpInterpret mergeJump staticSendTrampoline |
	" i need to read literal of the stack frame, found at byte1 index, after that load it to temp, we check the method is cogged or not to jump to it via trampoline"
	methodLiteralIndex := byte1.

	"Fetch the method from the stack"
	methodToGoTo := self getLiteral: methodLiteralIndex.
	self
		genStaticSend: methodToGoTo
		numArgs: (coInterpreter argumentCountOf: methodToGoTo).
	^ 0
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> genSpecialSelectorComparison [

	<var: #primDescriptor type: #'BytecodeDescriptor *'>
	<var: #branchDescriptor type: #'BytecodeDescriptor *'>
	<var: #jumpNotSmallInts type: #'AbstractInstruction *'>
	| nextPC postBranchPC targetPC primDescriptor branchDescriptor rcvrIsInt rcvrIsConst argIsIntConst argInt jumpNotSmallInts inlineCAB index |
	self ssFlushStackExceptTop: 2.
	primDescriptor := self generatorAt: byte0.
	argIsIntConst := self ssTop type = SSConstant and: [
		                 objectMemory isIntegerObject:
			                 (argInt := self ssTop constant) ].
	rcvrIsInt := ((rcvrIsConst := (self ssValue: 1) type = SSConstant)
		              and: [
		              objectMemory isIntegerObject:
			              (self ssValue: 1) constant ]) or: [
		             self mclassIsSmallInteger and: [
			             (self ssValue: 1) isSameEntryAs: self simSelf ] ].

	"If both operands are constant, fold the value"
	(argIsIntConst and: [ rcvrIsInt and: [ rcvrIsConst ] ]) ifTrue: [
		^ self genStaticallyResolvedSpecialSelectorComparison ].

	"From this moment on: at least one of the operands is not constant"
	
	self extractMaybeBranchDescriptorInto: [ :descr :next :postBranch :target |
		branchDescriptor := descr.
		nextPC := next.
		postBranchPC := postBranch.
		targetPC := target ].

	"Only interested in inlining if followed by a conditional branch."
	inlineCAB := branchDescriptor isBranchTrue or: [
		             branchDescriptor isBranchFalse ].
	"Further, only interested in inlining = and ~= if there's a SmallInteger constant involved.
	 The relational operators successfully statically predict SmallIntegers; the equality operators do not."
	(inlineCAB and: [
		 primDescriptor opcode = JumpZero or: [
			 primDescriptor opcode = JumpNonZero ] ]) ifTrue: [
		inlineCAB := argIsIntConst or: [ rcvrIsInt ] ].
	inlineCAB ifFalse: [ ^ self genSpecialSelectorSend ].

	argIsIntConst ifTrue: [
		"If the argument is constant, we already extracted the value and we have it in argInt"
		"Pop the argument from the stack, then the receiver"
		self ssPop: 1.
		self ssPopTopToReg: ReceiverResultReg ]
	ifFalse: [ 
		"Otherwise, marshall normally to prepare for a message send"
		self marshallSendArguments: 1 ].
	
	"Generate an optional jump checking if the operands are ints.
	It will be generated only in case we need to check it at runtime
	I.e., it will not be generated if we know the values at compile time"
	jumpNotSmallInts := nil.
	(rcvrIsInt and: [ argIsIntConst ]) ifFalse: [
		jumpNotSmallInts := argIsIntConst
			                    ifTrue: [
			                    objectRepresentation genJumpNotSmallInteger:
				                    ReceiverResultReg ]
			                    ifFalse: [
				                    rcvrIsInt
					                    ifTrue: [
					                    objectRepresentation genJumpNotSmallInteger:
						                    Arg0Reg ]
					                    ifFalse: [
						                    objectRepresentation
							                    genJumpNotSmallIntegersIn:
							                    ReceiverResultReg
							                    and: Arg0Reg
							                    scratch: TempReg ] ] ].
	
	argIsIntConst
		ifTrue: [ self CmpCq: argInt R: ReceiverResultReg ]
		ifFalse: [ self CmpR: Arg0Reg R: ReceiverResultReg ].

	"Cmp is weird/backwards so invert the comparison.  Further since there is a following conditional
	 jump bytecode define non-merge fixups and leave the cond bytecode to set the mergeness."
	self
		genConditionalBranch: (branchDescriptor isBranchTrue
				 ifTrue: [ primDescriptor opcode ]
				 ifFalse: [ self inverseBranchFor: primDescriptor opcode ])
		operand: (self ensureNonMergeFixupAt: targetPC) asUnsignedInteger.
	self Jump: (self ensureNonMergeFixupAt: postBranchPC).

	jumpNotSmallInts ifNil: [
		self annotateInstructionForBytecode.
		self ensureFixupAt: postBranchPC.
		self ensureFixupAt: targetPC.
		deadCode := true.
		^ 0 ].

	jumpNotSmallInts jmpTarget: self Label.

	"Calling convention: Finish putting the argument in the register Arg0Reg for the send below"
	argIsIntConst ifTrue: [ self MoveCq: argInt R: Arg0Reg ].

	index := byte0 - self firstSpecialSelectorBytecodeOffset.
	^ self
		  genMarshalledSend: index negated - 1
		  numArgs: 1
		  sendTable: ordinarySendTrampolines
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> genStaticSend: method numArgs: numArgs [

	<inline: false>
	<var: #sendTable type: #'sqInt *'>
	| annotation sendTable |
	self assert: needsFrame.

	sendTable := staticSendTrampolines.
	"annotation := self annotationForSendTable: sendTable."

	self marshallSendArguments: numArgs.

	"Will jump to no check entry point, so put forwarder resolution here in the callsite."
	objectRepresentation
		genEnsureOopInRegNotForwarded: ReceiverResultReg
		scratchReg: TempReg.
	"0 through (NumSendTrampolines - 2) numArgs sends have the arg count implciti in the trampoline.
	 The last send trampoline (NumSendTrampolines - 1) passes numArgs in SendNumArgsReg."
	numArgs >= (NumSendTrampolines - 1) ifTrue: [
		self MoveCq: numArgs R: SendNumArgsReg ].

	self genMoveConstant: method R: TempReg.
	(self Call: (sendTable at: (numArgs min: NumSendTrampolines - 1)))
		"annotation: annotation".

	self voidReceiverOptStatus.
	^ self ssPushRegister: ReceiverResultReg
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> genStaticSendTrampolineFor: aRoutine numArgs: numArgs called: aString arg: regOrConst0 [
	"Generate a trampoline with four arguments.
	 Hack: a negative value indicates an abstract register, a non-negative value indicates a constant."
	<var: #aRoutine type: #'void *'>
	<var: #aString type: #'char *'>
	| startAddress |
	<inline: false>
	startAddress := methodZoneBase.
	self zeroOpcodeIndex.
	backEnd genPushRegisterArgsForNumArgs: numArgs scratchReg: SendNumArgsReg.

	self genTrampolineFor: aRoutine
		called: aString
		numArgs: 1
		arg: regOrConst0
		arg: nil
		arg: nil
		arg: nil
		regsToSave: self emptyRegisterMask
		pushLinkReg: true
		resultReg: NoReg
		appendOpcodes: true.
	^startAddress
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> genStaticallyResolvedSpecialSelectorComparison [
	"Assumes both operands are ints"
	<var: #primDescriptor type: #'BytecodeDescriptor *'>
	| rcvrInt argInt primDescriptor result |
	primDescriptor := self generatorAt: byte0.
	argInt := self ssTop constant.
	rcvrInt := (self ssValue: 1) constant.
	self cCode: '' inSmalltalk: "In Simulator ints are unsigned..."
		[rcvrInt := objectMemory integerValueOf: rcvrInt.
		argInt := objectMemory integerValueOf: argInt].
	 primDescriptor opcode caseOf: {
		[JumpLess]				-> [result := rcvrInt < argInt].
		[JumpLessOrEqual]		-> [result := rcvrInt <= argInt].
		[JumpGreater]			-> [result := rcvrInt > argInt].
		[JumpGreaterOrEqual]	-> [result := rcvrInt >= argInt].
		[JumpZero]				-> [result := rcvrInt = argInt].
		[JumpNonZero]			-> [result := rcvrInt ~= argInt] }.
	 "Must annotate the bytecode for correct pc mapping."
	 self ssPop: 2.
	 ^self ssPushAnnotatedConstant: (result
			ifTrue: [objectMemory trueObject]
			ifFalse: [objectMemory falseObject])
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> generateSendTrampolines [
	"Override to generate code to push the register arg(s) for <= numRegArg arity sends."

	0 to: NumSendTrampolines - 1 do: [ :numArgs |
		ordinarySendTrampolines at: numArgs put: (self
				 genSendTrampolineFor: #ceSend:super:to:numArgs:
				 numArgs: numArgs
				 called: (self trampolineName: 'ceSend' numArgs: numArgs)
				 arg: ClassReg
				 arg: (self trampolineArgConstant: false)
				 arg: ReceiverResultReg
				 arg: (self numArgsOrSendNumArgsReg: numArgs)) ].
	0 to: NumSendTrampolines - 1 do: [ :numArgs |
		staticSendTrampolines at: numArgs put: (self
				 genTrampolineFor: #ceStaticSend:to:numArgs:
				 called: (self trampolineName: 'ceStaticSend' numArgs: numArgs)
				 arg: TempReg
				 arg: ReceiverResultReg
				 arg: (self numArgsOrSendNumArgsReg: numArgs)) "method to go to" ].

	"Generate these in the middle so they are within [firstSend, lastSend]."
	BytecodeSetHasDirectedSuperSend ifTrue: [
		0 to: NumSendTrampolines - 1 do: [ :numArgs |
			self
				generateSuperSendTrampolineTo: #ceSend:above:to:numArgs:
				named: 'ceDirectedSuperSend'
				numArgs: numArgs
				in: directedSuperSendTrampolines.
			self
				generateSuperSendTrampolineTo:
				#ceSend:aboveClassBinding:to:numArgs:
				named: 'ceDirectedSuperBindingSend'
				numArgs: numArgs
				in: directedSuperBindingSendTrampolines ] ].

	0 to: NumSendTrampolines - 1 do: [ :numArgs |
		superSendTrampolines at: numArgs put: (self
				 genSendTrampolineFor: #ceSend:super:to:numArgs:
				 numArgs: numArgs
				 called: (self trampolineName: 'ceSuperSend' numArgs: numArgs)
				 arg: ClassReg
				 arg: (self trampolineArgConstant: true)
				 arg: ReceiverResultReg
				 arg: (self numArgsOrSendNumArgsReg: numArgs)) ].
	firstSend := ordinarySendTrampolines at: 0.
	lastSend := superSendTrampolines at: NumSendTrampolines - 1
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit class >> initializeBytecodeTableForSistaV1 [
	"StackToRegisterMappingCogit initializeBytecodeTableForSistaV1"

	numPushNilsFunction := #sistaV1:Num:Push:Nils:.
	pushNilSizeFunction := #sistaV1PushNilSize:numInitialNils:.
	BytecodeSetHasDirectedSuperSend := true.
	BytecodeSetHasExtensions := true.
	FirstSpecialSelector := 96.
	NumSpecialSelectors := 32.
	self flag:
'Special selector send class must be inlined to agree with the interpreter, which
 inlines class.  If class is sent to e.g. a general instance of ProtoObject then unless
 class is inlined there will be an MNU.  It must be that the Cointerpreter and Cogit
 have identical semantics.  We get away with not hardwiring the other special
 selectors either because in the Cointerpreter they are not inlined or because they
 are inlined only to instances of classes for which there will always be a method.'.
	self generatorTableFrom: #(
		"1 byte bytecodes"
		"pushes"
		(1    0   15 genPushReceiverVariableBytecode isInstVarRef		needsFrameNever: 1)
		(1  16   31 genPushLiteralVariable16CasesBytecode			needsFrameNever: 1)
		(1  32   63 genPushLiteralConstantBytecode					needsFrameNever: 1)
		(1  64   75 genPushTemporaryVariableBytecode				needsFrameIfMod16GENumArgs: 1)
		(1  76   76 genPushReceiverBytecode							needsFrameNever: 1)
		(1  77   77 genPushConstantTrueBytecode						needsFrameNever: 1)
		(1  78   78 genPushConstantFalseBytecode					needsFrameNever: 1)
		(1  79   79 genPushConstantNilBytecode						needsFrameNever: 1)
		(1  80   80 genPushConstantZeroBytecode						needsFrameNever: 1)
		(1  81   81 genPushConstantOneBytecode						needsFrameNever: 1)
		(1  82   82 genExtPushPseudoVariable)
		(1  83   83 duplicateTopBytecode								needsFrameNever: 1)

		(1  84   87 unknownBytecode)

		"returns"
		(1  88   88 genReturnReceiver				return needsFrameIfInBlock: isMappedInBlock 0)
		(1  89   89 genReturnTrue					return needsFrameIfInBlock: isMappedInBlock 0)
		(1  90   90 genReturnFalse					return needsFrameIfInBlock: isMappedInBlock 0)
		(1  91   91 genReturnNil					return needsFrameIfInBlock: isMappedInBlock 0)
		(1  92   92 genReturnTopFromMethod		return needsFrameIfInBlock: isMappedInBlock -1)
		(1  93   93 genReturnNilFromBlock			return needsFrameNever: -1)
		(1  94   94 genReturnTopFromBlock		return needsFrameNever: -1)
		(1  95   95 genExtNopBytecode			needsFrameNever: 0)

		"sends"
		(1  96   96 genSpecialSelectorArithmetic isMapped AddRR)
		(1  97   97 genSpecialSelectorArithmetic isMapped SubRR)
		(1  98   98 genSpecialSelectorComparison isMapped JumpLess)
		(1  99   99 genSpecialSelectorComparison isMapped JumpGreater)
		(1 100 100 genSpecialSelectorComparison isMapped JumpLessOrEqual)
		(1 101 101 genSpecialSelectorComparison isMapped JumpGreaterOrEqual)
		(1 102 102 genSpecialSelectorComparison isMapped JumpZero)
		(1 103 103 genSpecialSelectorComparison isMapped JumpNonZero)
		(1 104 109 genSpecialSelectorSend isMapped)	 " #* #/ #\\ #@ #bitShift: //"
		(1 110 110 genSpecialSelectorArithmetic isMapped AndRR)
		(1 111 111 genSpecialSelectorArithmetic isMapped OrRR)
		(1 112 117 genSpecialSelectorSend isMapped) "#at: #at:put: #size #next #nextPut: #atEnd"
		(1 118 118 genSpecialSelectorEqualsEquals needsFrameNever: notMapped -1) "not mapped because it is directly inlined (for now)"
		(1 119 119 genSpecialSelectorClass needsFrameIfStackGreaterThanOne: notMapped 0) "not mapped because it is directly inlined (for now)"
		(1 120 120 genSpecialSelectorNotEqualsEquals needsFrameNever: notMapped -1) "not mapped because it is directly inlined (for now)"
		(1 121 127 genSpecialSelectorSend isMapped) "#value #value: #do: #new #new: #x #y"

		(1 128 143 genSendLiteralSelector0ArgsBytecode isMapped)
		(1 144 159 genSendLiteralSelector1ArgBytecode isMapped)
		(1 160 175 genSendLiteralSelector2ArgsBytecode isMapped)

		"jumps"
		(1 176 183 genShortUnconditionalJump	branch v3:ShortForward:Branch:Distance:)
		(1 184 191 genShortJumpIfTrue			branch isBranchTrue isMapped "because of mustBeBoolean"
													v3:ShortForward:Branch:Distance:)
		(1 192 199 genShortJumpIfFalse			branch isBranchFalse isMapped "because of mustBeBoolean"
													v3:ShortForward:Branch:Distance:)
		(1 200 207 genStoreAndPopReceiverVariableBytecode isInstVarRef is1ByteInstVarStore isMappedIfImmutability needsFrameIfImmutability: -1)
		
		(1 208 215 genStoreAndPopTemporaryVariableBytecode)

		(1 216 216 genPopStackBytecode needsFrameNever: -1)

		(1 217 217 genUnconditionalTrapBytecode isMapped)

		(1 218 223 unknownBytecode)

		"2 byte bytecodes"
		(2 224 224 extABytecode extension)
		(2 225 225 extBBytecode extension)

		"pushes"
		(2 226 226 genExtPushReceiverVariableBytecode isInstVarRef)		"Needs a frame for context inst var access"
		(2 227 227 genExtPushLiteralVariableBytecode			needsFrameNever: 1)
		(2 228 228 genExtPushLiteralBytecode					needsFrameNever: 1)
		(2 229 229 genLongPushTemporaryVariableBytecode)
		(2 230 230 unknownBytecode)
		(2 231 231 genPushNewArrayBytecode)
		(2 232 232 genExtPushIntegerBytecode				needsFrameNever: 1)
		(2 233 233 genExtPushCharacterBytecode				needsFrameNever: 1)

		"returns"
		"sends"
		(2 234 234 genExtSendBytecode isMapped)
		(2 235 235 genExtSendSuperBytecode isMapped)

		"sista bytecodes"
		(2 236 236 genCallMappedInlinedPrimitive isMapped)

		"jumps"
		(2 237 237 genExtUnconditionalJump	branch isMapped "because of interrupt check" v4:Long:Branch:Distance:)
		(2 238 238 genExtJumpIfTrue			branch isBranchTrue isMapped "because of mustBeBoolean" v4:Long:Branch:Distance:)
		(2 239 239 genExtJumpIfFalse			branch isBranchFalse isMapped "because of mustBeBoolean" v4:Long:Branch:Distance:)

		"stores"
		(2 240 240 genExtStoreAndPopReceiverVariableBytecode isInstVarRef isMappedIfImmutability)
		(2 241 241 genExtStoreAndPopLiteralVariableBytecode isMappedIfImmutability)
		(2 242 242 genLongStoreAndPopTemporaryVariableBytecode)
		(2 243 243 genExtStoreReceiverVariableBytecode isInstVarRef isMappedIfImmutability)
		(2 244 244 genExtStoreLiteralVariableBytecode isMappedIfImmutability)
		(2 245 245 genLongStoreTemporaryVariableBytecode)

		(2 246 246	genSendStaticMessage)
		(2 247 247	unknownBytecode)

		"3 byte bytecodes"
		(3 248 248 genCallPrimitiveBytecode hasUnsafeJump)
		(3 249 249 genExtPushFullClosureBytecode)
		(3 250 250 unknownBytecode) "was genExtPushClosureBytecode"
		(3 251 251 genPushRemoteTempLongBytecode)
		(3 252 252 genStoreRemoteTempLongBytecode)
		(3 253 253 genStoreAndPopRemoteTempLongBytecode)
		
		(3 254 255	unknownBytecode))
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> linkStaticMethod: methodToGoTo [ 
	| argumentCount jumpInterpret mergeJump staticSendTrampoline |
	
	argumentCount := coInterpreter argumentCountOf: methodToGoTo.  
	
	"Allocate registers"
	self marshallSendArguments: argumentCount.

	self ssAllocateRequiredReg: ClassReg.
	self genMoveConstant: methodToGoTo R: ClassReg.
	objectRepresentation genEnsureObjInRegNotForwarded: ClassReg scratchReg: TempReg.
	
	"If the method is compiled, we jump to it, if not we jump to the interpret."
	objectRepresentation genLoadSlot: HeaderIndex sourceReg: ClassReg destReg: TempReg.
	jumpInterpret := objectRepresentation genJumpImmediate: TempReg.

	"Jump to the method's unchecked entry-point."
	self AddCq: cmNoCheckEntryOffset R: TempReg.
	self CallR: TempReg. "Receiver and Args travel in registers"
	mergeJump := self Jump: 0.
	
	"Call the trampoline to continue execution in the interpreter"
	jumpInterpret jmpTarget: self Label.
	
	"If the arguments are in registers, push them to the stack before going to the interpreter"
	argumentCount = 0 ifTrue: [ 
		staticSendTrampoline := staticSendTrampoline0 ].
	argumentCount = 1 ifTrue: [ 
		staticSendTrampoline := staticSendTrampoline1 ].
	argumentCount = 2 ifTrue: [ 
		staticSendTrampoline := staticSendTrampoline2 ].
	argumentCount > 2 ifTrue: [ 
		staticSendTrampoline := staticSendTrampoline3 ].
	self CallRT: staticSendTrampoline. "Receiver and Args travel in the stack"

	mergeJump jmpTarget: self Label.
	self annotateBytecode: self Label.

	self voidReceiverOptStatus.
	self ssPushRegister: ReceiverResultReg.

	^0
]

{ #category : '*StaticCallExpBuilder' }
StackToRegisterMappingCogit >> staticSendTrampoline0 [

	<doNotGenerate>

	^ staticSendTrampoline0
]
