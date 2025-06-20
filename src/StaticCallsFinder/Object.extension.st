Extension { #name : 'Object' }

{ #category : '*StaticCallsFinder' }
Object >> adetectReceiverTypes [

	^ ReceiverDetectionTool global installOnClass: self class
]

{ #category : '*StaticCallsFinder' }
Object class >> analyzeReceiverPatterns [
 
        ^ ReceiverDetectionTool global analyzeClass: self
]

{ #category : '*StaticCallsFinder' }
Object class >> detectReceiverTypes [

	^ ReceiverDetectionTool global installOnClass: self
]

{ #category : '*StaticCallsFinder' }
Object >> detectReceiverTypes [

	^ ReceiverDetectionTool global installOnClass: self class
]

{ #category : '*StaticCallsFinder' }
Object class >> detectReceiverTypesFor: selector [

	| method |
	method := self >> selector.
	^ ReceiverDetectionTool global installOn: method
]

{ #category : '*StaticCallsFinder' }
Object >> detectReceiverTypesFor: selector [

        | method |
        method := self class >> selector.
        ^ ReceiverDetectionTool global installOn: method
]

{ #category : '*StaticCallsFinder' }
Object >> printReceiverStatistics [

        self class methods do: [ :method |
            ReceiverDetectionTool global printStatisticsFor: method
        ]
]

{ #category : '*StaticCallsFinder' }
Object >> printReceiverStatisticsFor: selector [

        | method |
        method := self class >> selector.
        ReceiverDetectionTool global printStatisticsFor: method
]

{ #category : '*StaticCallsFinder' }
Object class >> receiverTypesFor: selector [
       
        | method |
        method := self >> selector.
        ^ ReceiverDetectionTool global getReceiverTypesFor: method

    
]

{ #category : '*StaticCallsFinder' }
Object >> receiverTypesFor: selector [

        | method |
        method := self class >> selector.
        ^ ReceiverDetectionTool global getReceiverTypesFor: method
]

{ #category : '*StaticCallsFinder' }
Object class >> stopReceiverDetection [

        ReceiverDetectionTool global uninstallFromClass: self

    
]

{ #category : '*StaticCallsFinder' }
Object >> stopReceiverDetection [

        ReceiverDetectionTool global uninstallFromClass: self class
]

{ #category : '*StaticCallsFinder' }
Object >> stopReceiverDetectionFor: selector [

        | method |
        method := self class >> selector.
        ReceiverDetectionTool global uninstallFrom: method
]
