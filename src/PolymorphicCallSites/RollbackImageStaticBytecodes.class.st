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
RollbackImageStaticBytecodes >> rollbackAction [
	rollbackAction value.
]

{ #category : 'as yet unclassified' }
RollbackImageStaticBytecodes >> rollbackAction: aRollbackAction [

	rollbackAction :=aRollbackAction.
]
