Extension { #name : 'RBProgramNodeVisitor' }

{ #category : '*StaticCallExp' }
RBProgramNodeVisitor >> visitStaticMessageNode: aStaticMessageNode [
	
	^ self visitMessageNode: aStaticMessageNode
]
