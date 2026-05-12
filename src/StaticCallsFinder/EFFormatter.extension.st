Extension { #name : 'EFFormatter' }

{ #category : '*StaticCallsFinder' }
EFFormatter >> formatStaticSelectorAndArguments: aMessageNode [
	"We are formatting a message and here we are about to format the message selector and its arguments."
	
	| isMultilineMessage hasMultiLineArguments multilineArgumentBeforeAnotherArgument |
	multilineArgumentBeforeAnotherArgument := self messageHasMultilineArgumentBeforeAnotherArgument: aMessageNode.
	isMultilineMessage := (self isMultiLineMessage: aMessageNode) or:[multilineArgumentBeforeAnotherArgument].
	hasMultiLineArguments := self hasAMultiLineMessageArgument: aMessageNode arguments.
	self
		indent:
			(((isMultilineMessage or:[hasMultiLineArguments]) and:[aMessageNode isKeyword])
				ifTrue: [ self indentsForKeywords ]
				ifFalse: [ 0 ])
		around: [ self
				formatStaticSelectorAndArguments: aMessageNode
				firstSeparator:
					(((self firstSeparatorShouldNotPassLine: aMessageNode) and:[multilineArgumentBeforeAnotherArgument not])
						ifTrue: [ self space ]
						ifFalse: [ isMultilineMessage
								ifTrue: [ [ self newLine ] ]
								ifFalse: [ [ self space ] ] ])
				restSeparator:
					((isMultilineMessage)
						ifTrue: [ [ self newLine ] ]
						ifFalse: [ [ self space ] ]) ]
]

{ #category : '*StaticCallsFinder' }
EFFormatter >> formatStaticSelectorAndArguments: aMessageNode firstSeparator: firstBlock restSeparator: restBlock [
  | separatorBlock i |
  i := 0.
  separatorBlock := firstBlock.
  aMessageNode isUnary ifTrue: [ self indentAround: [ self handleLineForSelector: aMessageNode selector withSeparatorBlock: separatorBlock.
	codeStream nextPutAll: ({#_ . aMessageNode staticClass instanceSide name . #_} joinUsing: '') asSymbol.	              
codeStream nextPutAll: aMessageNode selector ] ] ifFalse: [ aMessageNode selectorParts with: aMessageNode arguments do: [:selector :argument |  i := i + 1.
              self handleLineForSelector: selector withSeparatorBlock: separatorBlock.
              separatorBlock := restBlock.
              self indent: ((((self willBeMultiline: argument) and: [ i < aMessageNode selectorParts size or: [ self newLineBefore ] ]) or: [ self isInCascadeNode ]) ifTrue: [ 1 ] ifFalse: [ 0 ]) around: [ 
	codeStream nextPutAll: ({#_ . aMessageNode staticClass instanceSide name . #_} joinUsing: '') asSymbol.
	codeStream nextPutAll: selector.
                    self handleLineForArgument: argument ].
              ((self willBeMultiline: argument) and: [ i < aMessageNode selectorParts size ]) ifTrue: [ separatorBlock := self newLine ] ] ]
]

{ #category : '*StaticCallsFinder' }
EFFormatter >> visitStaticMessageNode: aMessageNode [

	self visitNode: aMessageNode receiver.
	self formatStaticSelectorAndArguments: aMessageNode
]
