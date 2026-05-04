Class {
	#name : 'StaticRecursiveMethodPlaceHolder',
	#superclass : 'Object',
	#instVars : [
		'selector'
	],
	#category : 'StaticCallExp',
	#package : 'StaticCallExp'
}

{ #category : 'as yet unclassified' }
StaticRecursiveMethodPlaceHolder >> factooo [

	self _StaticRecursiveMethodPlaceHolder_factooo
]

{ #category : 'accessing' }
StaticRecursiveMethodPlaceHolder >> numArgs [

	^ selector numArgs
]

{ #category : 'accessing' }
StaticRecursiveMethodPlaceHolder >> selector: aString [

	selector := aString
]
