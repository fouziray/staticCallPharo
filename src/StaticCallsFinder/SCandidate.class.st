Class {
	#name : 'SCandidate',
	#superclass : 'StaticCallCandidate',
	#category : 'StaticCallsFinder-core',
	#package : 'StaticCallsFinder',
	#tag : 'core'
}

{ #category : 'accessing' }
SCandidate >> receiverType: amethod [

	receiverType  := amethod classBinding value.
]
