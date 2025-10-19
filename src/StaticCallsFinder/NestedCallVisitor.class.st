Class {
	#name : 'NestedCallVisitor',
	#superclass : 'RBProgramNodeVisitor',
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'visiting' }
NestedCallVisitor >> visitMessageNode: aMessageNode [

	
	self visitNode: aMessageNode receiver.
]
