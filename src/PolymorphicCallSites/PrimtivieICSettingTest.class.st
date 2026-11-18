Class {
	#name : 'PrimtivieICSettingTest',
	#superclass : 'TestCase',
	#category : 'PolymorphicCallSites-Synth-Objects',
	#package : 'PolymorphicCallSites',
	#tag : 'Synth-Objects'
}

{ #category : 'tests' }
PrimtivieICSettingTest >> testFrozenSiteFromMorphicGetsFlushed [

	| types program beforeFlushing xrayAfterrun |
	program := SyntethicPrograms new.
 	"This is a synthetic example, it needs warming up"
	
	(types := {
		1.
		1.0.
		LargePositiveInteger new. LargeNegativeInteger new.
		Bag new. OrderedCollection new. Array new .  [ 1 ]  }).
	beforeFlushing := (SyntethicPrograms >> #callYourself:) xray.

	PicInitializer new 
			linkMethod: (SyntethicPrograms >> #callYourself:)
			numCopiedVars: -1
			atBcpc: 34
			isSuper: false
			targetSelector: 'yourself' asSymbol 
			tagetTypes: ((types first: 6) collect:[:e | e class])
			targetMethod: ((types first: 6) collect:[:e | Object>>#yourself ]). 
	
	beforeFlushing := (SyntethicPrograms >> #callYourself:) xray.

	self assert:  beforeFlushing first size equals: 13. "it shouldn't go mega (size = 3 means it's mega) but stay at maximum size 6 entries"

	
	types do: [ :e | program callYourself: e ].
	xrayAfterrun := (SyntethicPrograms >> #callYourself:) xray.
	self assert:  xrayAfterrun first size equals: 13.

	Smalltalk vm voidCogVMState.
	xrayAfterrun := (SyntethicPrograms >> #callYourself:) xray.
	self assert: xrayAfterrun equals: { }
]

{ #category : 'tests' }
PrimtivieICSettingTest >> testGlobalFreezeGetsFlushed [

	| beforeFlushing afterFlushing |
	
	"The new method is constanylbeing used by Calypo text editor and KM commands, therefore no need to warm it up"
	
	beforeFlushing :=  (Behavior>>#new) xray.
	
	Smalltalk vm voidCogVMState.
	
	afterFlushing := (Behavior>>#new) xray.
	
	self deny: beforeFlushing equals: afterFlushing
]

{ #category : 'tests' }
PrimtivieICSettingTest >> testSetPICSNoFail [

	Smalltalk vm voidCogVMState.
	SyntethicPrograms setPICBlock.

	SyntethicPrograms new mainBlock
]

{ #category : 'tests' }
PrimtivieICSettingTest >> testSpecializedFrozenSiteGetsFlushed [

	| program beforeFlushing xrayAfterrun |
	program := SyntethicPrograms new.
 	"This is a synthetic example, it needs warming up"
	
	{
		1.
		1.0.
		LargePositiveInteger new. LargeNegativeInteger new.
		Bag new. OrderedCollection new. Array new . } do: [ :e | program callYourself: e ].
	(SyntethicPrograms >> #callYourself:) xray.

	beforeFlushing := (SyntethicPrograms >> #callYourself:) xray.
	self assert:  beforeFlushing first size equals: 13. "it shouldn't go mega but stay at maximum size 6 entries"
	Smalltalk vm voidCogVMState.
	xrayAfterrun := (SyntethicPrograms >> #callYourself:) xray.

	self assert: xrayAfterrun equals: { }
]
