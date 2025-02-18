Extension { #name : 'StackInterpreter' }

{ #category : '*StaticCallExp' }
StackInterpreter class >> initializeBytecodeTableForSistaV1 [
	"See e.g. the cass comment for EncoderForSistaV1"
	"StackInterpreter initializeBytecodeTableForSistaV1"
	"Note: This table will be used to generate a C switch statement."

	InitializationOptions at: #SistaV1BytecodeSet put: (SistaV1BytecodeSet := true).

	BytecodeTable := Array new: 256.
	BytecodeEncoderClassName := #EncoderForSistaV1.
	BytecodeSetHasDirectedSuperSend := true.
	BytecodeSetHasExtensions := true.
	LongStoreBytecode := 245.
	self table: BytecodeTable from:
	#(	"1 byte bytecodes"
		(   0  15 pushReceiverVariableBytecode)
		( 16  31 pushLiteralVariable16CasesBytecode)
		( 32  63 pushLiteralConstantBytecode)
		( 64  75 pushTemporaryVariableBytecode)
		( 76	 pushReceiverBytecode)
		( 77	 pushConstantTrueBytecode)
		( 78	 pushConstantFalseBytecode)
		( 79	 pushConstantNilBytecode)
		( 80	 pushConstantZeroBytecode)
		( 81	 pushConstantOneBytecode)
		( 82	 extPushPseudoVariable)
		( 83	 duplicateTopBytecode)
	
		( 84 87	unknownBytecode)
		( 88	returnReceiver)
		( 89	returnTrue)
		( 90	returnFalse)
		( 91	returnNil)
		( 92	returnTopFromMethod)
		( 93	returnNilFromBlock)
		( 94	returnTopFromBlock)
		( 95	extNopBytecode)

		( 96	 bytecodePrimAdd)
		( 97	 bytecodePrimSubtract)
		( 98	 bytecodePrimLessThanSistaV1) 		"for booleanCheatSistaV1:"
		( 99	 bytecodePrimGreaterThanSistaV1) 	"for booleanCheatSistaV1:"
		(100	 bytecodePrimLessOrEqualSistaV1) 	"for booleanCheatSistaV1:"
		(101	 bytecodePrimGreaterOrEqualSistaV1) 	"for booleanCheatSistaV1:"
		(102	 bytecodePrimEqualSistaV1) 			"for booleanCheatSistaV1:"
		(103	 bytecodePrimNotEqualSistaV1) 		"for booleanCheatSistaV1:"
		(104	 bytecodePrimMultiply)
		(105	 bytecodePrimDivide)
		(106	 bytecodePrimMod)
		(107	 bytecodePrimMakePoint)
		(108	 bytecodePrimBitShift)
		(109	 bytecodePrimDiv)
		(110	 bytecodePrimBitAnd)
		(111	 bytecodePrimBitOr)

		(112	 bytecodePrimAt)
		(113	 bytecodePrimAtPut)
		(114	 bytecodePrimSize)
		(115	 bytecodePrimNext)		 "i.e. a 0 arg special selector"
		(116	 bytecodePrimNextPut)		 "i.e. a 1 arg special selector"
		(117	 bytecodePrimAtEnd)
		(118	 bytecodePrimIdenticalSistaV1) "for booleanCheatSistaV1:"
		(119	 bytecodePrimClass)
		(120	 bytecodePrimNotIdenticalSistaV1) "was blockCopy:"
		(121	 bytecodePrimValue)
		(122	 bytecodePrimValueWithArg)
		(123	 bytecodePrimDo)			"i.e. a 1 arg special selector"
		(124	 bytecodePrimNew)			"i.e. a 0 arg special selector"
		(125	 bytecodePrimNewWithArg)	"i.e. a 1 arg special selector"
		(126	 bytecodePrimPointX)		"i.e. a 0 arg special selector"
		(127	 bytecodePrimPointY)		"i.e. a 0 arg special selector"

		(128 143	sendLiteralSelector0ArgsBytecode)
		(144 159	sendLiteralSelector1ArgBytecode)
		(160 175	sendLiteralSelector2ArgsBytecode)

		(176 183	shortUnconditionalJump)
		(184 191	shortConditionalJumpTrue)
		(192 199	shortConditionalJumpFalse)
	
		(200 207	storeAndPopReceiverVariableBytecode)
		(208 215	storeAndPopTemporaryVariableBytecode)
		(216		popStackBytecode)
		(217		unconditionnalTrapBytecode)

		(218 223	unknownBytecode)

		"2 byte bytecodes"
		(224		extABytecode)
		(225		extBBytecode)

		(226		extPushReceiverVariableBytecode)
		(227		extPushLiteralVariableBytecode)
		(228		extPushLiteralBytecode)
		(229		longPushTemporaryVariableBytecode)
		(230		unknownBytecode)
		(231		pushNewArrayBytecode)
		(232		extPushIntegerBytecode)
		(233		extPushCharacterBytecode)

		(234		extSendBytecode)
		(235		extSendSuperBytecode)

		(236		callMappedInlinedPrimitive)

		(237		extUnconditionalJump)
		(238		extJumpIfTrue)
		(239		extJumpIfFalse)

		(240		extStoreAndPopReceiverVariableBytecode)
		(241		extStoreAndPopLiteralVariableBytecode)
		(242		longStoreAndPopTemporaryVariableBytecode)

		(243		extStoreReceiverVariableBytecode)
		(244		extStoreLiteralVariableBytecode)
		(245		longStoreTemporaryVariableBytecode)

		(246 sendStaticLiteralMethodBytecode)
		(247	unknownBytecode)

		"3 byte bytecodes"
		(248		callPrimitiveBytecode)
		(249		extPushFullClosureBytecode)

		(250		unknownBytecode) "was extPushClosureBytecode"
		(251		pushRemoteTempLongBytecode)
		(252		storeRemoteTempLongBytecode)
		(253		storeAndPopRemoteTempLongBytecode)
				
		(254 255	unknownBytecode)
	)
]

{ #category : '*StaticCallExp' }
StackInterpreter >> sendStaticLiteralMethodBytecode [
	"2 Byte Bytecode
 		1st Byte: opcode
 		2nd Byte: literal offset of the method"

 	| methodLiteralOffset primitiveIndex |
 	methodLiteralOffset := self fetchByte.
 	newMethod := self literal: methodLiteralOffset.

 	"argumentCount is used by primitives to
 	   - check how to access the stack and
 	   - know how many elements to pop,
 	and generally to check that the stack gets balanced after execution"
 	argumentCount := self argumentCountOf: newMethod.

 	"primitiveFunctionPointer needs to be loaded for each method interpreted.
 	executeNewMethod: assumes that this is set during lookup
 	Thus, if we don't set it, the value will be the one of the last method/primitive called"
 	primitiveIndex := self primitiveIndexOf: newMethod.
 	primitiveFunctionPointer := self functionPointerFor: primitiveIndex inClass: nil.

 	self executeNewMethod: true.
 	self fetchNextBytecode
 
]
