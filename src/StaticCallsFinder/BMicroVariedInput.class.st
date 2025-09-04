Class {
	#name : 'BMicroVariedInput',
	#superclass : 'StaticStats',
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'as yet unclassified' }
BMicroVariedInput >> runProgram: aCompiledMethod withArgs: anArray receiver: aReceiver for: iterationNumber [

	iterationNumber timesRepeat: [
		aReceiver withArgs: anArray executeMethod: aCompiledMethod ]
]
