Class {
	#name : 'FrozenFullPIC',
	#superclass : 'Object',
	#instVars : [
		'typesInCache'
	],
	#category : 'PolymorphicCallSites-comparing frozen Pic to Mega',
	#package : 'PolymorphicCallSites',
	#tag : 'comparing frozen Pic to Mega'
}

{ #category : 'as yet unclassified' }
FrozenFullPIC >> callOn: aType [

	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
	aType yourself.
]

{ #category : 'as yet unclassified' }
FrozenFullPIC >> hitAt10Percent [

	| listOfTypes |
	listOfTypes := typesInCache , {
		               1.2 . 2 . (3 / 5) } , { CpDChildOne new }. "one that doesn't exist"
	1000 timesRepeat: [ listOfTypes do: [ :t | t yourself ] ]
]

{ #category : 'initialization' }
FrozenFullPIC >> initialize [ 
	typesInCache := { 1 . 2.0 . LargePositiveInteger  new  . LargeNegativeInteger new . LargeInteger new . 1/4 } .
]
