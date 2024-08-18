Class {
	#name : 'RBStaticMessageNode',
	#superclass : 'RBMessageNode',
	#category : 'StaticCallExp',
	#package : 'StaticCallExp'
}

{ #category : 'accessing' }
RBStaticMessageNode >> acceptVisitor: aProgramNodeVisitor [

	^ aProgramNodeVisitor visitStaticMessageNode: self
]

{ #category : 'accessing' }
RBStaticMessageNode >> selector: aSelector [
	keywordsPositions := nil.
	selector := aSelector isString
		ifTrue: [ RBSelectorNode value: aSelector allButFirst ]
		ifFalse: [ aSelector value: aSelector value allButFirst ].
	selector parent: self
]
