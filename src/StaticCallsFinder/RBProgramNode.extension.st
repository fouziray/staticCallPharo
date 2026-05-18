Extension { #name : 'RBProgramNode' }

{ #category : '*StaticCallsFinder' }
RBProgramNode >> childAtPath: aPath [

	aPath ifEmpty: [ ^ self ].
	
	^ (self children at: aPath first) childAtPath: aPath allButFirst
]

{ #category : '*StaticCallsFinder' }
RBProgramNode >> pathInParent [

	self parent ifNil: [ ^ #[] ].
	^ self parent pathInParent , { self parent children indexOf: self }
]
