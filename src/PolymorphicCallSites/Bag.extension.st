Extension { #name : 'Bag' }

{ #category : '*PolymorphicCallSites' }
Bag >> keys [
    "Returns the bag distinct element kinds."

    ^ contents keys
]

{ #category : '*PolymorphicCallSites' }
Bag >> numberOfKeys [
    "Returns the number distinct elements."

    ^ contents keys size
]
