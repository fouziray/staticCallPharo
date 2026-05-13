Extension { #name : 'RBSelectorNode' }

{ #category : '*StaticCallExp' }
RBSelectorNode >> extractStaticClass [

	^ (value substrings: '_') first
]

{ #category : '*StaticCallExp' }
RBSelectorNode >> extractStaticSelector [
	^ (self value substrings: '_') second
]

{ #category : '*StaticCallExp' }
RBSelectorNode >> setPrimarySelector [
	
	value := self extractStaticSelector 
]
