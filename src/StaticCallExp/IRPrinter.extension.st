Extension { #name : 'IRPrinter' }

{ #category : '*StaticCallExp' }
IRPrinter >> visitStaticSend: send [

	stream nextPutAll: 'staticSend: '.
	send calledMethod selector printOn: stream
]
