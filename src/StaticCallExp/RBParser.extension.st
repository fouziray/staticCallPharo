Extension { #name : 'RBParser' }

{ #category : '*StaticCallExp' }
RBParser >> parseBinaryMessageWith: aNode [

	| selectorNode |
	selectorNode := self selectorNodeClass
		              value: currentToken value
		              keywordPositions: { currentToken start }.
	self step.
	^ (selectorNode value beginsWith: '_')
		  ifTrue: [
				| staticClassName |

				"Should extract first the class before mutating the selectorNode"
				staticClassName := selectorNode extractStaticClass.
				selectorNode setPrimarySelector.
				(self staticMessageNodeClass
					receiver: aNode
					selector: selectorNode copy
					keywordsPositions: selectorNode keywordPositions
					arguments: { self parseUnaryMessage } )
					staticClass: staticClassName; 
					yourself ]
		  ifFalse: [
			  self messageNodeClass
				  receiver: aNode
				  selector: selectorNode
				  keywordsPositions: selectorNode keywordPositions
				  arguments: { self parseUnaryMessage } ]
]

{ #category : '*StaticCallExp' }
RBParser >> parseKeywordMessageWith: node [

	| args isKeyword keywordsStartPositions selector selectorNode |
	args := OrderedCollection new: 3.
	keywordsStartPositions := OrderedCollection new: 3.
	selector := ''.

	isKeyword := false.
	[ currentToken isKeyword ] whileTrue: [
		keywordsStartPositions add: currentToken start.
		selector := selector , currentToken value.
		self step.
		args add: self parseBinaryMessage.
		isKeyword := true ].
	
	selectorNode := self selectorNodeClass value: selector.
	selectorNode keywordPositions: keywordsStartPositions.
	^ isKeyword
		  ifTrue: [
			  (selectorNode value beginsWith: '_')
				  ifFalse: [
					self messageNodeClass
						  receiver: node
						  selector: selectorNode
						  keywordsPositions: keywordsStartPositions
						  arguments: args ]
				  ifTrue: [
					| staticClassName |
					"Should extract first the class before mutating the selectorNode"
					staticClassName := selectorNode extractStaticClass.
					selectorNode setPrimarySelector.
					(self staticMessageNodeClass
						  receiver: node
						  selector: selectorNode copy
						  keywordsPositions: keywordsStartPositions
						  arguments: args)
						staticClass: staticClassName; yourself  ] ]
		  ifFalse: [ node ]
]

{ #category : '*StaticCallExp' }
RBParser >> parseUnaryMessageWith: aNode [

	| selectorNode |
	selectorNode := self selectorNodeClass
		            value: currentToken value
		            keywordPositions: { currentToken start }.
	self step.
	^ (selectorNode value beginsWith: '_')
		  ifFalse: [
			  self messageNodeClass
				  receiver: aNode
				  selector: selectorNode
				  keywordsPositions: selectorNode keywordPositions
				  arguments: #(  ) ]
		  ifTrue: [
			| staticClassName |
			"Should extract first the class before mutating the selectorNode"
			staticClassName := selectorNode extractStaticClass.
			selectorNode setPrimarySelector.
			(self staticMessageNodeClass
				receiver: aNode
				selector: selectorNode copy
				keywordsPositions: selectorNode keywordPositions
				arguments: #(  )) staticClass: staticClassName ]
]

{ #category : '*StaticCallExp' }
RBParser >> staticMessageNodeClass [

	^ RBStaticMessageNode
]
