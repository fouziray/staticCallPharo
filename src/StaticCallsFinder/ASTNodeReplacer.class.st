Class {
	#name : 'ASTNodeReplacer',
	#superclass : 'RBProgramNodeVisitor',
	#instVars : [
		'replacements'
	],
	#category : 'StaticCallsFinder-Benchmarks',
	#package : 'StaticCallsFinder',
	#tag : 'Benchmarks'
}

{ #category : 'initialization' }
ASTNodeReplacer >> initialize [

	super initialize.
	replacements := Dictionary new
]

{ #category : 'initialization' }
ASTNodeReplacer >> replace: oldAstNode with: newAstNode [

	replacements at: oldAstNode put: newAstNode.
	oldAstNode isBinary not ifTrue:[oldAstNode selector: '_',newAstNode staticClass className,'_',newAstNode selector. ].
	
]

{ #category : 'initialization' }
ASTNodeReplacer >> visitMessageNode: aNode [

	(replacements includesKey: aNode) ifTrue: [
		aNode isBinary not ifTrue: [
			1 halt.
			aNode selector:
				'_' , (replacements at: aNode) staticClass className , '_'
				, aNode selector ] ].
	super visitMessageNode: aNode
]
