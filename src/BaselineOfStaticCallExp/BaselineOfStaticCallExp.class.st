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
			baseline: 'VMMaker' with: [
				spec repository:
						'github://fouziray/pharo-vm:staticSendFixTrampolineFromJitToInterpreter/smalltalksrc' ];
			package: 'StaticCallExp';
			package: 'StaticCallExpBuilder'
			with: [ spec requires: #( 'VMMaker' 'StaticCallExp' ) ];
			package: 'StaticCallExpBuilder-Tests'
			with: [ spec requires: #( 'StaticCallExpBuilder' ) ];
			package: 'StaticCallExpExample'
			with: [ spec requires: #( 'StaticCallExp' ) ];
			package: 'StaticCallExp-Tests'
			with: [ spec requires: #( 'StaticCallExp' ) ];
			package: 'PolymorphicCallSites' with: [
				spec repository:
				'github://scopeo-project/scopeo' ].
			
		spec
			group: 'default'
			with:
			#( 'StaticCallExp' 'StaticCallExp-Tests' 'StaticCallsFinder' ).
		spec
			group: 'buildAVM'
			with: #( 'StaticCallExpBuilder-Tests' 'StaticCallExp-Tests' ).
		spec
			group: 'min'
			with: #(  'StaticCallExp-Tests' ).
		spec group: 'buildTests' with: #( 'StaticCallExpBuilder-Tests' ) ]
]
