Class {
	#name : 'PolymorphicCallSitesVisitor',
	#superclass : 'ScpExecutionRecordVisitor',
	#instVars : [
		'messageExecutionsDictionary'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'initialization' }
PolymorphicCallSitesVisitor >> initialize [

	"message send node -> IdentityDictionary(executed compiled method -> Collection( method call receiver))"
	messageExecutionsDictionary := IdentityDictionary new
]

{ #category : 'accessing' }
PolymorphicCallSitesVisitor >> messageExecutionsDictionary [

	^ messageExecutionsDictionary
]

{ #category : 'visiting' }
PolymorphicCallSitesVisitor >> visitMethodTrace: aScpMethodTrace [

	aScpMethodTrace parent ifNotNil: [ :message |
		messageExecutionsDictionary at: message node 
		 	ifPresent: [ :d | 
				d at: aScpMethodTrace node compiledMethod 
					ifPresent: [ :receivers | receivers add: aScpMethodTrace receiver ]
					ifAbsentPut: [ self error: 'Wrong initialization of identity set' ]
			]  
			ifAbsentPut: [ 
				IdentityDictionary new
					at: aScpMethodTrace node compiledMethod put: (IdentitySet new 
						add: aScpMethodTrace receiver; 
						yourself); 
					yourself
			]
	].

	aScpMethodTrace children do: [ :m |
		m accept: self
	]
]
