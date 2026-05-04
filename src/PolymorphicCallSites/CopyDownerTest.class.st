Class {
	#name : 'CopyDownerTest',
	#superclass : 'TestCase',
	#instVars : [
		'methodActivated',
		'callSite',
		'methodActivated2',
		'callSite2'
	],
	#category : 'PolymorphicCallSites-CopyDowner',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDowner'
}

{ #category : 'tests' }
CopyDownerTest >> setUp [

	methodActivated := MethodActivatedModel new.
	methodActivated compiledMethodName: 'CpDRoot>>#callSiteDefinedInRoot'.
	methodActivated receiverTypes: ({ CpDChildOne. CpDChildTwo . CpDChildOne} collect: #name).
	callSite:= CallSiteModel new.
	callSite methodsActivated: {  methodActivated }.
	callSite fillKey: (((CpDMiddle>>#containingCallSiteDefinedInRoot) ast allChildren select:#isMessage)  asArray first -> nil).
	callSite fetchSelector.
	callSite computeTypes.
	
	"method2 is redefined locally in the dominant class so it should Not be reinstalled"
	methodActivated2 := MethodActivatedModel new.
	methodActivated2 compiledMethodName: 'CpDRoot>>#callSiteDefinedInRoot2'.
	methodActivated2 receiverTypes: ({ CpDChildOne. CpDChildTwo . CpDChildOne} collect: #name).
	callSite2 := CallSiteModel new.
	callSite2 methodsActivated: {  methodActivated2 }.
	callSite2 fillKey: (((CpDMiddle>>#containingCallSiteDefinedInRoot2) ast allChildren select:#isMessage)  asArray first -> nil).
	callSite2 fetchSelector.
	callSite2 computeTypes
]

{ #category : 'tests' }
CopyDownerTest >> testCopiedDownMethodCanBeDefinedInDominant [
	"when we do the lookup to find where to define the copied down method (containing the call site)
	we take the dominant class only if it is not the class defining the method to be copied down"
	
	| cp |
	cp := CopyDowner new.
	cp sites: { callSite }.
	
	self assert: (cp is: CpDChildOne possibleTargetFor: callSite).
	self assert: (cp is: CpDChildTwo possibleTargetFor: callSite).
	
]

{ #category : 'tests' }
CopyDownerTest >> testCopiedDownMethodCannotBeDefinedInDominantClassBecauseOfExisitingMethod [	
	
	| cp |
	cp := CopyDowner new.
	cp sites: { callSite2 }.
	"ce n'est pas le bon test par ce que si la methode existe deja en sous classe, elle ne passera pas par la classe mere et donc on aura pas ce cas"
	self deny: (cp is: CpDChildOne possibleTargetFor: callSite2).
	
	
]

{ #category : 'tests' }
CopyDownerTest >> testCopiedDownMethodShouldNotRedefineExistingMethod [
		
	| cp |
	cp := CopyDowner new.
	cp sites: { callSite }.
	
	self deny: (cp is: CpDMiddle possibleTargetFor: callSite).
	
]

{ #category : 'tests' }
CopyDownerTest >> testLookupMethodContainingTheSiteBasedOnDominantInformation [
	
	| cp |
	cp := CopyDowner new.
	"Here the dominant is ChildOne and it does not define a method so we found it in the superclass."
	cp sites: { callSite }.
	self 
		assert: (cp lookupMethodContainingTheSite: callSite) methodClass
		equals: CpDMiddle
]

{ #category : 'tests' }
CopyDownerTest >> testValidateManualSetUp [
	
	self assert: callSite selector equals: 'callSiteDefinedInRoot'.
	self assert: callSite methodClass equals: CpDMiddle.
	self assert: callSite dominantType equals: CpDChildOne name
]
