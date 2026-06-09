Class {
	#name : 'DevirtualizerInstrumenter',
	#superclass : 'ScpMethodInstrumenter',
	#category : 'PolymorphicCallSites-Model',
	#package : 'PolymorphicCallSites',
	#tag : 'Model'
}

{ #category : 'visiting' }
DevirtualizerInstrumenter >> visitBlockNode: aBlockNode [

	"Do not instrument the block, just instrument its body"
	^ RBBlockNode 
		arguments: (self visitArgumentNodes: aBlockNode arguments)
		body: (self visitNode: aBlockNode body) 
]
