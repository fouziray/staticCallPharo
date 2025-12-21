Class {
	#name : 'MessageRedefStats',
	#superclass : 'Object',
	#instVars : [
		'devirtualizables'
	],
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

{ #category : 'accessing' }
MessageRedefStats >> devirtualizables [

	^ devirtualizables
]

{ #category : 'accessing' }
MessageRedefStats >> devirtualizables: anObject [

	devirtualizables := anObject
]
