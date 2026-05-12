Class {
	#name : 'RBStaticMessageNode',
	#superclass : 'RBMessageNode',
	#instVars : [
		'staticClass'
	],
	#classInstVars : [
		'staticClass'
	],
	#category : 'StaticCallExp-Node',
	#package : 'StaticCallExp',
	#tag : 'Node'
}

{ #category : 'instance creation' }
RBStaticMessageNode class >> fromMessageNode: aMessageNode [

	| newStaticMessageNode |
	newStaticMessageNode := self new.

	"Copy all instance variables from superclass"
	RBMessageNode allInstVarNames do: [ :varName |
		newStaticMessageNode
			instVarNamed: varName
			put: (aMessageNode instVarNamed: varName) ].
	^ newStaticMessageNode
]

{ #category : 'accessing' }
RBStaticMessageNode >> acceptVisitor: aProgramNodeVisitor [

	^ aProgramNodeVisitor visitStaticMessageNode: self
]

{ #category : 'instance creation' }
RBStaticMessageNode >> fromSelfCreateMessageNode [

	|  newMessageNode |
	newMessageNode := RBMessageNode new.

	"Copy all instance variables from superclass"
	RBMessageNode allInstVarNames do: [ :varName |
		newMessageNode
			instVarNamed: varName
			put: (self instVarNamed: varName) ].
	^ newMessageNode
]

{ #category : 'testing' }
RBStaticMessageNode >> isStaticCall [

	^ true
]

{ #category : 'accessing' }
RBStaticMessageNode >> selector: aSelector [

	staticClass := nil.
	keywordsPositions := nil.
	selector := aSelector isString
		            ifTrue: [ RBSelectorNode value: aSelector allButFirst ]
		            ifFalse: [ aSelector value: aSelector value "allButFirst" ].
	selector parent: self
]

{ #category : 'accessing' }
RBStaticMessageNode >> staticClass [
	
	^ staticClass 
]

{ #category : 'accessing' }
RBStaticMessageNode >> staticClass: aStaticClass [

	aStaticClass isString 
		ifTrue: [ staticClass := Smalltalk globals classNamed: aStaticClass ] 
		ifFalse: [	staticClass := aStaticClass ]
]
