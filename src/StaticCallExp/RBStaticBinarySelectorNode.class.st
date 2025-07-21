Class {
	#name : 'RBStaticBinarySelectorNode',
	#superclass : 'RBSelectorNode',
	#classInstVars : [
		'isBinary'
	],
	#category : 'StaticCallExp',
	#package : 'StaticCallExp'
}

{ #category : 'instance creation' }
RBStaticBinarySelectorNode class >> createFrom: aRBSelectorNode [
	|selector|
	selector:= aRBSelectorNode as: self.
	selector value: '_',((selector value substrings: '_') last).
	^ selector
]

{ #category : 'accessing' }
RBStaticBinarySelectorNode >> numArgs [

	^ 1
]
