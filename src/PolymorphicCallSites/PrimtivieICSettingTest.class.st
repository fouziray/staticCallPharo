Class {
	#name : 'PrimtivieICSettingTest',
	#superclass : 'TestCase',
	#category : 'PolymorphicCallSites-Synth-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Synth-Objects'
}

{ #category : 'tests' }
PrimtivieICSettingTest >> testSetPICSNoFail [

	Smalltalk vm voidCogVMState.
	SyntethicPrograms setPICBlock.

	SyntethicPrograms new mainBlock
]
