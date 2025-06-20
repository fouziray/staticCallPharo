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

  aCollectionOfMessageNodes do: [ :node | node link: link ].
]

{ #category : 'initialization' }
ProfilingMessageReceiverType >> initialize [

	link := MetaLink new.
	types:= Dictionary new.
	link metaObject: [ :receiver :node |
		
		(types at: node ifAbsentPut: [ Set new ]) add: receiver class ].
	link selector: #value:value:.
	link arguments: #( receiver node ).
	link control: #before
]

{ #category : 'as yet unclassified' }
ProfilingMessageReceiverType >> selectMicrodownPackages [

	^ (((PackageOrganizer default packages select: [ :e |
		    (e name beginsWith: 'Microdown') and: [
			    e name ~= 'Microdown-Tests' ] ]) collect: [ :package |
		   package definedClasses ]) flattened collect:
		  [ :c |
		  c methods collect: [ :m | m ast sendNodes reject: #isInlined ] ])
			  flattened
]

{ #category : 'as yet unclassified' }
ProfilingMessageReceiverType >> types [

	^ types
]

{ #category : 'as yet unclassified' }
ProfilingMessageReceiverType >> uninstallLink [

	link uninstall
]
