Class {
	#name : 'CpDMiddle',
	#superclass : 'CpDRoot',
	#category : 'PolymorphicCallSites-CopyDownerDataForTest',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDownerDataForTest'
}

{ #category : 'basic' }
CpDMiddle >> containingCallSiteDefinedInRoot [

	self callSiteDefinedInRoot
]

{ #category : 'basic' }
CpDMiddle >> containingCallSiteDefinedInRoot2 [
	"I'm the method that should be copied down"
	
	self callSiteDefinedInRoot2
]
