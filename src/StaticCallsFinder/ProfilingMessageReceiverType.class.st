Class {
	#name : 'ProfilingMessageReceiverType',
	#superclass : 'Object',
	#instVars : [
		'link',
		'types'
	],
	#category : 'StaticCallsFinder',
	#package : 'StaticCallsFinder'
}

{ #category : 'as yet unclassified' }
ProfilingMessageReceiverType >> addLinkToNodes: aCollectionOfMessageNodes [

	aCollectionOfMessageNodes do: [ :node | node link: link ]
]

{ #category : 'initialization' }
ProfilingMessageReceiverType >> initialize [

	link := MetaLink new.
	types := Dictionary new.
	link metaObject: [ :receiver :node |
		(types at: node ifAbsentPut: [ Set new ]) add: receiver class.

		self addLinkToNodes: (receiver class lookupSelector: node selector) ast sendNodes ].
	link selector: #value:value:.
	link arguments: #( receiver node ).
	link control: #before
]

{ #category : 'as yet unclassified' }
ProfilingMessageReceiverType >> receiverProfileTypesAt: aMessageNode [ 

	^ types at: aMessageNode 
]

{ #category : 'as yet unclassified' }
ProfilingMessageReceiverType >> uninstallLink [

	link uninstall
]
