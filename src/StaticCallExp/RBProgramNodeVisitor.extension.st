Extension { #name : 'RBProgramNodeVisitor' }

{ #category : '*StaticCallExp' }
RBProgramNodeVisitor >> visitStaticMessageNode: aStaticMessageNode [
	
	(aStaticMessageNode isCascaded not or: [ aStaticMessageNode isFirstCascaded ])
		ifTrue: [ self visitNode: aStaticMessageNode receiver ].
	self visitNode: aStaticMessageNode selectorNode.
	aStaticMessageNode arguments do: [ :each | self visitNode: each ]
]
