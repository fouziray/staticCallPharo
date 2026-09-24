Class {
	#name : 'PicInitializer',
	#superclass : 'Object',
	#instVars : [
		'count',
		'xrayAfter'
	],
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'intialization' }
PicInitializer class >> pickify: aProgramModel [

	^ self new pickify: aProgramModel
]

{ #category : 'initialization' }
PicInitializer >> initialize [

	xrayAfter := OrderedCollection new
]

{ #category : 'as yet unclassified' }
PicInitializer >> linkMethod: sourceMethod atBcpc: bcpc targetSelector: aSelector tagetTypes: targetsTypes targetMethod: targetMethods [

	<primitive: 218 error: ec>
	^ self primitiveFailed: ec
]

{ #category : 'as yet unclassified' }
PicInitializer >> linkMethod: sourceMethod numCopiedVars: numCopied atBcpc: bcpc isSuper: isSuper targetSelector: aSelector tagetTypes: targetsTypes targetMethod: targetMethods [

	<primitive: 218 error: ec>
	^ self primitiveFailed: ec
]

{ #category : 'as yet unclassified' }
PicInitializer >> linkMethod: sourceMethod numCopiedVars: numCopied atBcpc: bcpc targetSelector: aSelector tagetTypes: targetsTypes targetMethod: targetMethods [

	<primitive: 218 error: ec>
	^ self primitiveFailed: ec
]

{ #category : 'intialization' }
PicInitializer >> pickify: aProgramModel [
	| filteredSites |
	self setCounter: 0.
	filteredSites := (aProgramModel callSites allButFirst reject:[ :c| (#( #new. #basicNew . #new: . #DoIt . #initialize . #timesRepeat:  .#collect:) includes: c  selector )or:[ c flattenedTypes asSet size=1] ]).
	( filteredSites ) do: [ :callsite |
		self sortAndApplyPicInto: callsite ].
]

{ #category : 'intialization' }
PicInitializer >> pickify: aProgramModel numberOfCasses: numberOfCasses [
	self setCounter: 0.
	1 halt.
	(((aProgramModel callSites allButFirst reject:[ :c| ((#( #new. #basicNew . #new: . #DoIt . #initialize . #timesRepeat:  .#collect:) includes: c  selector )or:[ c flattenedTypes asSet size=1])  and:[ (c bytecodeStart isNil) and: [ c isSelfSend  ] ] ]) ) first: numberOfCasses) do: [ :callsite |
		self sortAndApplyPicInto: callsite ].
]

{ #category : 'seraching' }
PicInitializer >> recollectBlockNodeOf: aRBMethodNode from: aCallSiteModel [
	|messageNode|
	
	aRBMethodNode blockNodes detect:[:blockNode | messageNode := (blockNode sourceNodeForPC: aCallSiteModel bytecodeStart ).
		messageNode isMessage and:[ messageNode start = aCallSiteModel sourceStart ]
		 ].
]

{ #category : 'seraching' }
PicInitializer >> recollectBlockNodeOf: aRBMethodNode from: aCallSiteModel on: aConditionBlock [

	| messageNode block |
	block := aRBMethodNode blockNodes detect: [ :blockNode |
		         messageNode := blockNode sourceNodeForPC:
			                        aCallSiteModel bytecodeStart.
		         aConditionBlock value: messageNode value: aCallSiteModel ].
	^ (aCallSiteModel method literals select: #isCompiledBlock) detect: [
		  :blockCode | blockCode ast = block ]
]

{ #category : 'initialization' }
PicInitializer >> setCounter: anInteger [

	count := anInteger
]

{ #category : 'sorting' }
PicInitializer >> sortAndApplyPicInto: aCallSiteModel [

	| sendNode sourceMethod bcpc targetTypesSortes sel bytecode bytecodeSize messageValidator targetMethods |
	
	"self haltIf: [ aCallSiteModel flattenedTypes includes: 'FullBlockClosure' ]."
"	self haltIf: [ aCallSiteModel stripSelectorFromQuotes = 'value:' ].

"
	  ({#DoIt. #createReceiverPatternOf: } includes: aCallSiteModel methodSelector) ifTrue: [
		
		^ nil ].
		 ({ 'Rectangle class' . 'Point class' } includes: aCallSiteModel methodClassName ) ifTrue: [^ nil].
	sourceMethod := aCallSiteModel method.
	sendNode := sourceMethod ast sourceNodeForPC:
		            aCallSiteModel bytecodeStart.
		
	messageValidator := 	[ :sendNode :aCallSiteModel | sendNode isMessage and:[ sendNode start = aCallSiteModel sourceStart ] ].
	(messageValidator value: sendNode value: aCallSiteModel) ifFalse: [
					sourceMethod := self recollectBlockNodeOf: sendNode from: aCallSiteModel on: messageValidator . 
					sendNode := sourceMethod ast sourceNodeForPC: aCallSiteModel bytecodeStart.
					 ].
	
	"Encodersista est la classe reelement appelee lors de compilation. elle donne le map correct dans le cas d'uun message avec plusieurs bytecodes"
	bcpc := sourceMethod ast bcToASTCache firstBcOffsetForNode: sendNode.
	bytecode := sourceMethod byteAt: bcpc.
	bytecodeSize := EncoderForSistaV1 bytecodeSize: bytecode.
	bcpc := bcpc + bytecodeSize - 1.

	targetTypesSortes := (aCallSiteModel flattenedTypes asSet collect: [
		                      :t |
		                      | components theClass |
		                      components := t substrings.
		                      theClass := components first
			                                  asClassInEnvironment:
			                                  self class environment.
		                      components size = 2 ifTrue: [
			                      self assert: components second = 'class'.
			                      theClass := theClass class ].
		                      theClass ]) asArray.
	"xrayBefore := sourceMethod xray.
	"

sel := aCallSiteModel stripSelectorFromQuotes asSymbol.	
	
"On n'enovie jamais un block avec son bcpcp - fixed"
 targetMethods := (sendNode isSuperSend 
			ifTrue:[ targetTypesSortes  collect:#superclass  ] 
			ifFalse: [ targetTypesSortes ]) 
			collect: [ :type |
				 type lookupSelector: sel asSymbol ].
			 
	targetTypesSortes size > 6 ifTrue: [ 
		"We do not do mega stuff"
	
		targetTypesSortes := targetTypesSortes first:6.
		targetMethods := targetMethods first: 6 ].

	
	
	"self halt.
	self haltIf: ((sourceMethod = (HGSimulator>>#extent:) ) and:[(sel = #extent:) and:[ bcpc = 109 ]] )."
	self
		linkMethod: sourceMethod
		numCopiedVars: (sourceMethod isBlock ifTrue: [ sourceMethod ast scope copiedVars size ] ifFalse:[ -1 ])
		atBcpc: bcpc
		isSuper: sendNode isSuperSend 
		targetSelector: sel
		tagetTypes: targetTypesSortes
		targetMethod: targetMethods.
	count := count + 1.

"
	xrayAfter add: sourceMethod xray"
]
