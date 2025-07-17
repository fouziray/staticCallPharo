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
						'github://pharo-project/pharo-vm:pharo-10/smalltalksrc' ];
			package: 'StaticCallExp';
			package: 'StaticCallExpBuilder' with: [ spec requires: #( 'VMMaker' 'StaticCallExp') ];
			package: 'StaticCallExpBuilder-Tests' with: [ spec requires: #( 'StaticCallExpBuilder') ];		
		"	package: 'StaticCallExpExample' with:[ spec requires: #( 'StaticCallExp') ] ;"
		package: 'StaticCallExp-Tests' with: [ spec requires: #( 'StaticCallExp') ].

		spec group: 'default' with: #('StaticCallExp' 'StaticCallExp-Tests').
		spec group: 'buildAVM' with:  #('StaticCAllExpBuilder' 'StaticCallExpBuilder-Tests' 'StaticCallExp-Tests').
		 ].
]
