Class {
	#name : 'CpDChildOne',
	#superclass : 'CpDMiddle',
	#category : 'PolymorphicCallSites-CopyDownerDataForTest',
	#package : 'PolymorphicCallSites',
	#tag : 'CopyDownerDataForTest'
}

{ #category : 'basic' }
CpDChildOne >> containingCallSiteDefinedInRoot2 [
	"I'm the method that should be copied down"
	
	self callSiteDefinedInRoot2
]
