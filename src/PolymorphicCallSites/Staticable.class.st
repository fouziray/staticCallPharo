Class {
	#name : 'Staticable',
	#superclass : 'Object',
	#category : 'PolymorphicCallSites',
	#package : 'PolymorphicCallSites'
}

{ #category : 'as yet unclassified' }
Staticable class >> traceFromHoneyGinger [
<script>
| files filesStoned |
files:= (FileSystem disk workingDirectory /'pharo-local' / 'iceberg' / 'fouziray' / 'staticCAllPharo' / '33VeritasHoneyGinger new run.ston' ).

filesStoned :=  STON fromString: files  contents.
1 halt.
]

{ #category : 'as yet unclassified' }
Staticable class >> traceFromRewriter [

	<script>
	| veritasHg filesStoned trace callSites method callsite candidates |
	filesStoned := STON fromString:
		               (FileSystem disk workingDirectory / 'tracing'
		                / '33VeritasHoneyGinger new run.ston') contents.
	1 halt.
	"trace extraction"
	trace := ScpExecutionRecorder
		         recordBlock: [
			         | simulator |
			         simulator := VeritasHoneyGinger new run.
			         5 timesRepeat: [ World doOneCycle ].
			         simulator ]
		         as: ScpExecutionRecordTree.
	1 halt.

	callSites := filesStoned callSites select: [ :cs |
		             (cs methodsActivated size = 1 and: [
			              cs bytecodeStart isNotNil ]) and: [
			             cs methodSelector ~= #DoIt ] ].
	candidates := callSites collect: [ :cs |
		              method := cs methodClass >> cs methodSelector.
		              callsite := method ast sourceNodeForPC:
			                          cs bytecodeStart.
		              StaticCallCandidate
			              method: method
			              callSite: callsite
			              selector: callsite selector
			              receiver: callsite receiver
			              receiverType:
			              (cs dominantType asClassInEnvironment:
				               self class environment) ].
	1 halt.

	StaticCallSiteTransformer new
		transformCallStack: candidates
		withinPath: trace
]
