Class {
	#name : 'BaselineOfStaticCallExp',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfStaticCallExp',
	#package : 'BaselineOfStaticCallExp'
}

{ #category : 'baselines' }
BaselineOfStaticCallExp >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages"
		spec
			baseline: 'SMark'
			with: [ spec repository: 'github://smarr/SMark' ];
			baseline: 'VMMaker' with: [
				spec repository:
						'github://fouziray/pharo-vm:staticSendFixTrampolineFromJitToInterpreter/smalltalksrc' ];
			baseline: 'ScopeoExecutionRecorder' with: [
				spec repository:
						'github://scopeo-project/scopeo-execution-recorder:main' ];
			baseline: 'VeritasHoneyGinger'
			with: [
				spec repository:
						'github://fouziray/PharoVeritasBenchSuite:main' ];
			baseline: 'VeritasBloc' with: [
				spec repository:
						'github://fouziray/PharoVeritasBenchSuite:main' ];
			baseline: 'VeritasDataFrame'
			with: [
				spec repository:
						'github://fouziray/PharoVeritasBenchSuite:main' ];
			package: 'StaticCallExp';
			package: 'StaticCallExpBuilder'
			with: [ spec requires: #( 'VMMaker' 'StaticCallExp' ) ];
			package: 'StaticCallExpBuilder-Tests'
			with: [ spec requires: #( 'StaticCallExpBuilder' ) ];
			package: 'StaticCallExpExample'
			with: [ spec requires: #( 'StaticCallExp' ) ];
			package: 'StaticCallExp-Tests'
			with: [ spec requires: #( 'StaticCallExp' ) ];
			package: 'PolymorphicCallSites'
			with: [ spec requires: #( 'ScopeoExecutionRecorder' ) ];
			package: 'StaticCallsFinder' with: [ spec requires: #( 'SMark' ) ].



		spec
			group: 'default'
			with:
			#( 'StaticCallExp' 'StaticCallExp-Tests' 'StaticCallsFinder' ).
		spec
			group: 'buildAVM'
			with: #( 'StaticCallExpBuilder-Tests' 'StaticCallExp-Tests' ).
		spec
			group: 'min'
			with: #( 'StaticCallExp-Tests' 'PolymorphicCallSites' ).
		spec
			group: 'mintracing'
			with: #( 'PolymorphicCallSites' 'HoneyGinger' ).
		spec
			group: 'mintracingveritas'
			with: #( 'PolymorphicCallSites' 'VeritasHoneyGinger' 'VeritasDataFrame' 'VeritasBloc' ).
		spec group: 'buildTests' with: #( 'StaticCallExpBuilder-Tests' ) ]
]
