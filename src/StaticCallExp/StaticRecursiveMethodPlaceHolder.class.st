Class {
	#name : 'StaticRecursiveMethodPlaceHolder',
	#superclass : 'Object',
	#instVars : [
		'selector'
	],
	#category : 'StaticCallExp',
	#package : 'StaticCallExp'
}

{ #category : 'accessing' }
StaticRecursiveMethodPlaceHolder >> numArgs [

	^ selector numArgs
]

{ #category : 'accessing' }
StaticRecursiveMethodPlaceHolder >> selector: aString [

	selector := aString
]
