Class {
	#name : 'RollbackImageStaticBytecodes',
	#superclass : 'Object',
	#instVars : [
		'rollbackAction'
	],
	#classInstVars : [
		'defaultInstance'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'accessing' }
RollbackImageStaticBytecodes class >> action: aRollbackBlock [ 
	
	defaultInstance := self new rollbackAction: aRollbackBlock.
	

]

{ #category : 'accessing' }
RollbackImageStaticBytecodes class >> default [
	^ defaultInstance ifNil: [ self new ] ifNotNil: [ defaultInstance  ] 
]

{ #category : 'as yet unclassified' }
RollbackImageStaticBytecodes >> replaceMsgs: staticMessagesList [

	staticMessagesList do: [ :e |
		e becomeForward: e fromSelfCreateMessageNode ]
]

{ #category : 'as yet unclassified' }
RollbackImageStaticBytecodes >> replaceSMsgWithNormal [

	RBStaticMessageNode allInstancesDo: [ :e |
		e becomeForward: e fromSelfCreateMessageNode ]
]

{ #category : 'as yet unclassified' }
RollbackImageStaticBytecodes >> rollbackAction [
	rollbackAction value.
]

{ #category : 'as yet unclassified' }
RollbackImageStaticBytecodes >> rollbackAction: aRollbackAction [

	rollbackAction :=aRollbackAction.
]

{ #category : 'running' }
RollbackImageStaticBytecodes >> rollbackAst: methods [

	methods do: [ :methodNode  |
		[ |staticSites|
		staticSites := (methodNode allChildren select: #isMessage) select: #isStaticCall.
		
		staticSites  becomeForward: (staticSites collect:#fromSelfCreateMessageNode) .
		methodNode methodClass
			compile: methodNode sourceCode
			classified: methodNode compiledMethod protocol ] ]
]
