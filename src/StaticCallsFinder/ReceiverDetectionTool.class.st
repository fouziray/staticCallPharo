Class {
	#name : 'ReceiverDetectionTool',
	#superclass : 'Object',
	#instVars : [
		'receiverData',
		'activeLinks',
		'isMonitoring'
	],
	#classInstVars : [
		'GlobalInstance'
	],
	#category : 'StaticCallsFinder-metalink',
	#package : 'StaticCallsFinder',
	#tag : 'metalink'
}

{ #category : 'as yet unclassified' }
ReceiverDetectionTool class >> global [

    ^ GlobalInstance ifNil: [ GlobalInstance := self new ]
]

{ #category : 'initialization' }
ReceiverDetectionTool class >> reset [
    GlobalInstance ifNotNil: [ GlobalInstance stopAllMonitoring ].
    GlobalInstance := nil
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> analyzeClass: aClass [

    | analysis |
    analysis := Dictionary new.
    
    aClass methods do: [ :method |
        | types summary |
        types := self getReceiverTypesFor: method.
        summary := Dictionary new.
        summary at: #totalNodes put: types size.
        summary at: #uniqueReceiverTypes put: (types values 
            inject: Set new into: [ :acc :set | acc addAll: set; yourself ]) size.
        summary at: #receiverTypes put: types.
        analysis at: method put: summary
    ].
    
    ^ analysis


]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> createLinkFor: method [
    | link types |
    types := Dictionary new.
    
    link := MetaLink new.
    link metaObject: [ :receiver :node | 
        (types at: node ifAbsentPut: [ Set new ])
            add: receiver class.
    ].
    link selector: #value:value:.
    link arguments: #(receiver node).
    link control: #before.
    
    ^ { link. types }
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> getAllReceiverData [

    ^ receiverData copy
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> getReceiverTypesFor: method [


	^ receiverData at: method ifAbsent: [ Dictionary new ]
]

{ #category : 'initialization' }
ReceiverDetectionTool >> initialize [
    super initialize.
    receiverData := Dictionary new.
    activeLinks := Dictionary new.
    isMonitoring := false
]

{ #category : 'instance creation' }
ReceiverDetectionTool >> installOn: method [

    | linkAndTypes link types |
    linkAndTypes := self createLinkFor: method.
    link := linkAndTypes first.
    types := linkAndTypes second.
    
    method ast sendNodes reject: #isInlined thenDo: [ :node |
        node link: link.
    ].
    
    activeLinks at: method put: link.
    receiverData at: method put: types.
    ^ link
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> installOnClass: aClass [

    | installedMethods |
    installedMethods := OrderedCollection new.
    
    aClass methods do: [ :method |
        self installOn: method.
        installedMethods add: method
    ].
    
    ^ installedMethods
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> monitorSystemFor: duration [

    | endTime |
    isMonitoring := true.
    endTime := DateAndTime now + duration.
    
    Transcript show: 'Starting system-wide receiver monitoring for ', duration asString; cr.
    
    [ DateAndTime now < endTime and: [ isMonitoring ] ] whileTrue: [
        (Delay forMilliseconds: 100) wait
    ].
    
    self stopAllMonitoring.
    Transcript show: 'System monitoring completed'; cr


]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> printStatisticsFor: method [
    "Print statistics for a specific method"
    | types |
    types := self getReceiverTypesFor: method.
    Transcript show: 'Receiver types for ', method printString, ':'; cr.
    types keysAndValuesDo: [ :node :receiverClasses |
        Transcript show: '  Node: ', node selector asString, ' -> '; 
                   show: (receiverClasses collect: #name) asArray asString; cr
    ]
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> stopAllMonitoring [

    activeLinks valuesDo: [ :link | link uninstall ].
    activeLinks removeAll.
    isMonitoring := false
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> uninstallFrom: method [
  
    | link |
    link := activeLinks at: method ifAbsent: [ ^ self ].
    link uninstall.
    activeLinks removeKey: method.
]

{ #category : 'as yet unclassified' }
ReceiverDetectionTool >> uninstallFromClass: aClass [
    "Remove receiver detection from all methods of a class"
    aClass methods do: [ :method |
        self uninstallFrom: method
    ]


]
