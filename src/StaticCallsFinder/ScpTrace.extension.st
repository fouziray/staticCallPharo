Extension { #name : 'ScpTrace' }

{ #category : '*StaticCallsFinder' }
ScpTrace >> findCorrespondingScpMessageNode: aRBMessageNode with: aBoolean [

	| childrenSize nextChild index correspondingScpNode found|
	found:= aBoolean .
	index := 1.
	correspondingScpNode := nil.
	childrenSize := self children size.
	[ found or: [ index > childrenSize ] ] whileFalse: [
		(self children at: index) node = aRBMessageNode
			ifTrue: [
				correspondingScpNode := self children at: index.
				found := true ]
			ifFalse: [ index := index + 1 ] ].
	index := 1.
	[ found or: [ index > childrenSize ] ] whileFalse: [
		nextChild := self children at: index.
		correspondingScpNode := nextChild
			                        findCorrespondingScpMessageNode:
			                        aRBMessageNode
			                        with: found.
		index := index + 1 ].
	nextChild := index.
	^ correspondingScpNode
]
