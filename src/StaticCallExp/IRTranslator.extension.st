Extension { #name : 'IRTranslator' }

{ #category : '*StaticCallExp' }
IRTranslator >> visitStaticSend: anIRStaticSend [

	gen sendStatic: anIRStaticSend calledMethod
]
