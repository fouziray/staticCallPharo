Class {
	#name : 'CallSitesFrequencyVisitor',
	#superclass : 'ScpExecutionRecordVisitor',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
CallSitesFrequencyVisitor class >> callNatureOf: anAssociation [

	(anAssociation value size = 1 and: [
		 anAssociation value values size = 1 ])
		ifTrue: [
			^ 'mono'
			  -> anAssociation value values first valuesAndCounts values sum ]
		ifFalse: [
			| somme |
			somme := (anAssociation value values collect: [ :e |
				(e isKindOf: IdentitySet)  ifTrue: [ e size ] ifFalse: [ e valuesAndCounts values sum ].
				           ]) sum.

			anAssociation value values size > 7
				ifTrue: [ 

					^ 'mega' -> somme ]
				ifFalse: [ ^ 'poly' -> somme ] ]
]

{ #category : 'as yet unclassified' }
CallSitesFrequencyVisitor class >> collectNatureOfEachMessage: associations [
		
	| tmp |
	tmp :=  associations collect: [ : each |
		(each isKindOf: IdentityDictionary) ifTrue: [self callNatureOf: each value ]
		ifFalse:[ self callNatureOf: each key ].
		  ].
	^ tmp 
]

{ #category : 'tests' }
CallSitesFrequencyVisitor class >> countFrequencyOfMessage: associations [

	| frequencyPerCallNature typeOfMessageAndCount |
	frequencyPerCallNature := Dictionary new.
	
	(self collectNatureOfEachMessage: associations)  do: [ :each |

		frequencyPerCallNature at: each key update: [ :v | v + each value ] initial: 0 ].
	^ frequencyPerCallNature
]

{ #category : 'tests' }
CallSitesFrequencyVisitor class >> doPieChart: aDictionary [

	| frequencyPerCallNature typeOfMessageAndCount |
	frequencyPerCallNature := Dictionary new.
	aDictionary associations do: [ :each |
		typeOfMessageAndCount := self callNatureOf: each key.
		frequencyPerCallNature
			at: typeOfMessageAndCount key
			put: typeOfMessageAndCount value ].
	^ frequencyPerCallNature
]

{ #category : 'accessing' }
CallSitesFrequencyVisitor class >> filter: aListOfMessageReceiversAssociations [

	^ self getCallFrequencyForMessages:
		  aListOfMessageReceiversAssociations
]

{ #category : 'tests' }
CallSitesFrequencyVisitor class >> getCallFrequencyForMessages: targetMethodsDict [

	| dict |
	dict := Dictionary new.

	targetMethodsDict do: [ :messageTargetAndReceiver |
	dict at: messageTargetAndReceiver  put: (messageTargetAndReceiver value values inject:0 into:[:sum :each | 
		 (each isKindOf: Bag) ifTrue: [ sum + each  asDictionary values sum ] ifFalse: [ sum + 1 ] ]).
	].

	^ dict
]
