Extension { #name : 'SmallInteger' }

{ #category : '*StaticCallExp' }
SmallInteger >> myFactorial [

	self > 0 ifTrue: [ ^ self * (self - 1) myFactorial ].
	self = 0 ifTrue: [ ^ 1 ].
	self error: 'Not valid for negative integers'
]
