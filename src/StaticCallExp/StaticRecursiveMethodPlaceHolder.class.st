Class {
	#name : 'StaticRecursiveMethodPlaceHolder',
	#superclass : 'Object',
	#instVars : [
		'selector'
	],
	#category : 'StaticCallExp-IR',
	#package : 'StaticCallExp',
	#tag : 'IR'
}

{ #category : 'accessing' }
StaticRecursiveMethodPlaceHolder >> numArgs [

	^ selector numArgs
]

{ #category : 'accessing' }
StaticRecursiveMethodPlaceHolder >> selector: aString [

	selector := aString
]
