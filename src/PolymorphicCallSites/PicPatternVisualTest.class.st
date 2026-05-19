Class {
	#name : 'PicPatternVisualTest',
	#superclass : 'TestCase',
	#instVars : [
		'visualizer',
		'callSite',
		'callSite2',
		'callSiteTypePatterns1',
		'callSiteTypePatterns2'
	],
	#category : 'PolymorphicCallSites-Tests',
	#package : 'PolymorphicCallSites',
	#tag : 'Tests'
}

{ #category : 'running' }
PicPatternVisualTest >> setUp [
	| methodActivated methodActivated2 |
	super setUp.

	visualizer:= PicPatternVisual  new.
	
	
	callSiteTypePatterns1 :=  OrderedCollection newFrom: { CpDChildOne .CpDChildOne.CpDChildOne. CpDChildThree. CpDChildOne.CpDChildOne.CpDChildOne }.

	callSiteTypePatterns2 := {  CpDChildOne .CpDChildOne.CpDChildOne. CpDChildThree. CpDChildThree.CpDChildTwo.CpDChildTwo. CpDChildOne.CpDChildOne.CpDChildOne }.
	
	methodActivated := MethodActivatedModel new.
	methodActivated compiledMethodName: 'CpDRoot>>#callSiteDefinedInRoot'.
	methodActivated receiverTypes: (callSiteTypePatterns1 asArray collect: #name).
	callSite:= CallSiteModel new.
	callSite methodsActivated: {  methodActivated }.
	callSite fillKey: (((CpDMiddle>>#containingCallSiteDefinedInRoot) ast allChildren select:#isMessage)  asArray first -> nil).
	callSite fetchSelector.
	callSite computeTypes.
	
"second callSite"


	methodActivated2 := MethodActivatedModel new.
	methodActivated2 compiledMethodName: 'CpDRoot>>#callSiteDefinedInRoot'.
	methodActivated2 receiverTypes: (callSiteTypePatterns2 collect: #name).
	callSite2:= CallSiteModel new.
	callSite2 methodsActivated: {  methodActivated2 }.
	callSite2 fillKey: (((CpDMiddle>>#containingCallSiteDefinedInRoot) ast allChildren select:#isMessage)  asArray first -> nil).
	callSite2 fetchSelector.
	callSite2 computeTypes.
	

]

{ #category : 'tests' }
PicPatternVisualTest >> testMulitplePicEntries [
	
	| vis |
	vis:= (visualizer visualizeAllSites: {callSite. callSite2} allPatterns: { callSiteTypePatterns1 . callSiteTypePatterns2 }) .
	
	"the point is to say wether type CpDChildOne has been disrupted by another".
	
	self assert:( vis isKindOf: RSCompositeChart ).
	vis inspect.
]

{ #category : 'tests' }
PicPatternVisualTest >> testPicEntry [
	
	| callSiteTypePatterns |
	callSiteTypePatterns :=  OrderedCollection newFrom: callSiteTypePatterns1 .
	"the point is to say wether type CpDChildOne has been disrupted by another".
	
	self assert: (visualizer getTransitionTriggerCounter: callSite  forPattern: callSiteTypePatterns1) asArray equals: {0. 0. 0. 1. 0. 0. 0}.
	(visualizer visualize: (callSite -> callSiteTypePatterns1) ) inspect.
	
]

{ #category : 'tests' }
PicPatternVisualTest >> testPicEntry2 [
	
	| callSiteTypePatterns |
	"the point is to say wether type CpDChildOne has been disrupted by another".
	
	self assert: (visualizer getTransitionTriggerCounter: callSite2  forPattern: callSiteTypePatterns2) asArray equals: {0. 0. 0. 1. 1. 2. 2. 0. 0. 0}.
	(visualizer visualize: (callSite2 -> callSiteTypePatterns2) ) inspect.
	
]
