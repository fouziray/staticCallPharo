Extension { #name : 'ASTTypingVisitor' }

{ #category : '*StaticCallExp' }
ASTTypingVisitor >> visitStaticMessageNode: aNode [

	| recvType type |
	super visitStaticMessageNode: aNode.

	"Fast path for some special Kernel selectors (type of the receiver is not important)"
	shortcutKernelMessages ifTrue: [
		(#( = == ~= ~~ < > <= >= isNil isNotNil isEmpty ) includes:
			 aNode selector) ifTrue: [ ^ self typeNode: aNode with: Boolean ].

		(#( size ) includes: aNode selector) ifTrue: [
			^ self typeNode: aNode with: Integer ] ].

	recvType := aNode receiver propertyAt: #type ifAbsent: [ ^ self ].

	"Fast path for some special Kernel selectors (type of the receiver IS important)"
	shortcutKernelMessages ifTrue: [
		(recvType isMeta and: [
			 #( new new: basicNew basicNew: ) includes: aNode selector ])
			ifTrue: [ ^ self typeNode: aNode with: recvType instanceSide ].

		aNode selector == #yourself ifTrue: [
			^ self typeNode: aNode with: recvType ].
		aNode selector == #class ifTrue: [
			^ self typeNode: aNode with: recvType class ] ].


	type := self lookupMethod: aNode selector type: recvType.
	type ifNotNil: [ self typeNode: aNode with: type ]
]
