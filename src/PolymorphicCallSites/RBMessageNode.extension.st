Extension { #name : 'RBMessageNode' }

{ #category : '*PolymorphicCallSites' }
RBMessageNode >> callSiteName [

	^ self methodNode methodClass asString , '>>#'
	  , self methodNode selector , ' !'
	  , (self methodNode pcsForNode: self) first asString
]
