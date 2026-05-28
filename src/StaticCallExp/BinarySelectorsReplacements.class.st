Class {
	#name : 'BinarySelectorsReplacements',
	#superclass : 'Object',
	#instVars : [
		'renaming'
	],
	#category : 'StaticCallExp-Node',
	#package : 'StaticCallExp',
	#tag : 'Node'
}

{ #category : 'accessing' }
BinarySelectorsReplacements class >> at: aMessageNode [
	^ self new at: aMessageNode 
]

{ #category : 'accessing' }
BinarySelectorsReplacements >> at: aMessageNode [
	^ (renaming at: aMessageNode)  
]

{ #category : 'initialization' }
BinarySelectorsReplacements >> initialize [ 

 renaming := 	Dictionary newFrom: { #= -> #equalityy: .
	#+ -> #pluss:
	}
]
