Extension { #name : 'EncoderForSistaV1' }

{ #category : '*StaticCallExp' }
EncoderForSistaV1 >> genSendStatic: methodLiteralOffset [

	stream
		nextPut: 246;
		nextPut: methodLiteralOffset
]
