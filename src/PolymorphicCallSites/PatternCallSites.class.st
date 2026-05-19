Class {
	#name : 'PatternCallSites',
	#superclass : 'DevirtualizableCallSites',
	#instVars : [
		'typePatterns'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'initialization' }
PatternCallSites >> initialize [
	super initialize.
	typePatterns := Dictionary new. 
]

{ #category : 'private - execution' }
PatternCallSites >> message: aNode method: aMethod receiver: aReceiver arguments: aArguments [

	<noInstrumentation>
   | arguments |
	arguments := aArguments.
	(aMethod selector = #doesNotUnderstand:) ifTrue: [ 
			arguments := { (MessageSend
						receiver: aReceiver
                 selector: aMethod selector 
                 arguments: aArguments) }
   	].

	(aNode isNotNil and: [ aNode methodNode isNil ]) 
		ifTrue: [ ^ aReceiver withArgs: arguments executeMethod: aMethod ].
	aNode ifNotNil: [ 
		(inlinedMethods includes: aNode selector) 
			ifTrue: [ ^ aReceiver withArgs: arguments executeMethod: aMethod
    ].

	typePatterns at: aNode 
		ifPresent: [ :m |  m add: aReceiver class ]
		ifAbsentPut: [ "Dictionary new
			at: aMethod put: (Bag new
				add: aReceiver class;
				yourself);
			yourself"
			OrderedCollection newFrom: { aReceiver }
		].
	callsites at: aNode 
		ifPresent: [ :m | m at: aMethod 
			ifPresent: [ :r | r add: aReceiver class ]
			ifAbsentPut: [ Bag new
				add: aReceiver class;
				yourself ]
		]
		ifAbsentPut: [ Dictionary new
			at: aMethod put: (Bag new
				add: aReceiver class;
				yourself);
			yourself
		].
	
	
	].
	^ aReceiver withArgs: arguments executeMethod: aMethod
   
]

{ #category : 'accessing' }
PatternCallSites >> typePatterns [

	^ typePatterns
]
