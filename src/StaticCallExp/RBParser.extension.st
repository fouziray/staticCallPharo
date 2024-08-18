Extension { #name : 'RBParser' }

{ #category : '*StaticCallExp' }
RBParser >> parseBinaryMessageWith: aNode [

	| binaryNode |
	binaryNode := self selectorNodeClass
		              value: currentToken value
		              keywordPositions: { currentToken start }.
	self step.
	^ (binaryNode value beginsWith: '_')
		  ifTrue: [
			  self staticMessageNodeClass
				  receiver: aNode
				  selector: binaryNode
				  keywordsPositions: binaryNode keywordPositions
				  arguments: { self parseUnaryMessage } ]
		  ifFalse: [
			  self messageNodeClass
				  receiver: aNode
				  selector: binaryNode
				  keywordsPositions: binaryNode keywordPositions
				  arguments: { self parseUnaryMessage } ]
]

{ #category : '*StaticCallExp' }
RBParser >> parseKeywordMessageWith: node [

	| args isKeyword keywordsStartPositions selector |
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
	selector := self selectorNodeClass value: selector.
	selector keywordPositions: keywordsStartPositions.
	^ isKeyword
		  ifTrue: [
			  (selector value beginsWith: '_')
				  ifFalse: [
					  self messageNodeClass
						  receiver: node
						  selector: selector
						  keywordsPositions: keywordsStartPositions
						  arguments: args ]
				  ifTrue: [
					  self staticMessageNodeClass
						  receiver: node
						  selector: selector
						  keywordsPositions: keywordsStartPositions
						  arguments: args ] ]
		  ifFalse: [ node ]
]

{ #category : '*StaticCallExp' }
RBParser >> parseUnaryMessageWith: aNode [

	| selector |
	selector := self selectorNodeClass
		            value: currentToken value
		            keywordPositions: { currentToken start }.
	self step.
	^ (selector value beginsWith: '_')
		  ifFalse: [
			  self messageNodeClass
				  receiver: aNode
				  selector: selector
				  keywordsPositions: selector keywordPositions
				  arguments: #(  ) ]
		  ifTrue: [
			  self staticMessageNodeClass
				  receiver: aNode
				  selector: selector
				  keywordsPositions: selector keywordPositions
				  arguments: #(  ) ]
]

{ #category : '*StaticCallExp' }
RBParser >> staticMessageNodeClass [

	^ RBStaticMessageNode
]
