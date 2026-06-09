Class {
	#name : 'DevirtualizationInstrumentation',
	#superclass : 'ScpMethodInstrumentation',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'accessing' }
DevirtualizationInstrumentation >> instrumenter: aDevirtualizerInstrumenter [ 
	instrumenter := aDevirtualizerInstrumenter
]
