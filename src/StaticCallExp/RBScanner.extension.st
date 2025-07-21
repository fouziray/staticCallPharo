Extension { #name : 'RBScanner' }

{ #category : '*StaticCallExp' }
RBScanner >> continueScanningKeywordOrIdentifier [

	| name |
	(currentCharacter = $: and: [ stream peek ~= $= ]) ifTrue: [
		buffer nextPut: currentCharacter.
		self step.
		name := buffer contents.
		^ RBKeywordToken value: name start: tokenStart ].
	name := buffer contents.
	(self scanNamedLiteral: name) ifNotNil: [ :token | ^ token ].
	^ RBIdentifierToken value: name start: tokenStart
]

{ #category : '*StaticCallExp' }
RBScanner >> scanIdentifierOrKeyword [
	"!! Attention !! There are 3 case of Literal Tokens : true, false and nil."

	"This scan accepts keywords only containing a colon."

	"The presence of a colon will mark the creation of a keyword, except when followed with =.
	 Otherwise an Identifier is created."

	"To ensure the pertinence of this scanner, it must be called only if the current character is 	, 	 	 alphabetic."

	currentCharacter = $_
		ifTrue: [ ^ self scanStaticKeyword ]
		ifFalse: [ self scanName ].
	^ self continueScanningKeywordOrIdentifier
]

{ #category : '*StaticCallExp' }
RBScanner >> scanStaticKeyword [

	| binarySelector name |
	[ characterType = #alphabetic or: [ characterType = #digit ] ]
		whileTrue: [
			buffer nextPut: currentCharacter.
			self step ].

	name := buffer contents.
	characterType = #binary ifFalse: [ ^ self continueScanningKeywordOrIdentifier ].
	^ binarySelector := self scanBinarySelector
]
