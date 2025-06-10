Class {
	#name : 'ASTNodeReconstruct',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'replacements'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'as yet unclassified' }
ASTNodeReconstruct class >> reconstruct: aNode with: transformationBlock [


	^ self new reconstructNode: aNode with: transformationBlock
]

{ #category : 'as yet unclassified' }
ASTNodeReconstruct >> reconstructNode: aNode with: transformationBlock [
    | newNode |
    
    "Apply transformation"
    newNode := transformationBlock value: aNode.
    
    "Reconstruct children"
    aNode isMethod ifTrue: [
        newNode body: (self reconstructNode: aNode body with: transformationBlock).
        newNode arguments: (aNode arguments collect: [:arg |
            self reconstructNode: arg with: transformationBlock
        ])
    ].
    
    aNode isMessage ifTrue: [
        aNode receiver ifNotNil: [
            newNode receiver: (self reconstructNode: aNode receiver with: transformationBlock)
        ].
        newNode arguments: (aNode arguments collect: [:arg |
            self reconstructNode: arg with: transformationBlock
        ])
    ].
    
    aNode isSequence ifTrue: [
        newNode statements: (aNode statements collect: [:stmt |
            self reconstructNode: stmt with: transformationBlock
        ]).
        newNode temporaries: (aNode temporaries collect: [:temp |
            self reconstructNode: temp with: transformationBlock
        ])
    ].
    
    aNode isReturn ifTrue: [
        newNode value: (self reconstructNode: aNode value with: transformationBlock)
    ].
    
    aNode isAssignment ifTrue: [
        newNode variable: (self reconstructNode: aNode variable with: transformationBlock).
        newNode value: (self reconstructNode: aNode value with: transformationBlock)
    ].
    
    ^ newNode
]
