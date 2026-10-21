Class {
	#name : 'DistributionCallsPlot',
	#superclass : 'Object',
	#category : 'PolymorphicCallSites-roassal plot',
	#package : 'PolymorphicCallSites',
	#tag : 'roassal plot'
}

{ #category : 'as yet unclassified' }
DistributionCallsPlot class >> dictionaryOfCallPerPackage: array [

	"array is a collection of call sites from the trace"
	| d |
	d := Dictionary new.
	array do: [ :callsite |
		[
		d
			at: callsite method package name
			ifPresent: [
			(d at: callsite method package name) + callsite numberOfCalls ]
			ifAbsentPut: [ callsite numberOfCalls ] ] onErrorDo: [  ] ].
	self plotfor: d.
	^ d
]

{ #category : 'as yet unclassified' }
DistributionCallsPlot class >> plotfor: aDictonary [
| totalCalls entries colors canvas center radius
  angle pointAt slicePoints legendX legendY rowH |


"
this is how data should look like
fakeData := Dictionary new
	at: 'Morphic-Core'    put:  1 ;
	yourself.
"
totalCalls := aDictonary values sum.

entries := (aDictonary associations
	sorted: [ :a :b | a value  > b value  ]) collect: [ :a |
		a key -> a value ].

canvas := RSCanvas new.
center := 0 @ 0.
radius := 190.
colors := OrderedCollection new.

pointAt := [ :deg :r :c |
	| rad |
	rad := deg * Float pi / 180.
	c + ((rad cos * r) @ (rad sin * r)) ].

slicePoints := [ :a0 :a1 :c :r |
	| pts |
	pts := OrderedCollection with: c.
	a0 to: a1 by: 3 do: [ :d | pts add: (pointAt value: d value: r value: c) ].
	pts add: (pointAt value: a1 value: r value: c).
	pts add: c.
	pts asArray ].

angle := -90. 
entries withIndexDo: [ :assoc :i |
	| calls  share sweep color poly |
	calls := assoc value.
	share := ((calls / totalCalls) asFloat round:2) max: 0.
	sweep := share * 360.
	color := Color h: (i - 1) * (360 / entries size) s: 0.55 v: 0.9.
	colors add: color.

	poly := RSPolygon new
		color: color;
		points: (slicePoints value: angle value: angle + sweep
			value: center value: radius);
		yourself.
	poly border: (RSBorder new color: Color white; width: 1).
	poly @ (RSPopup text: (assoc key, String cr,
		((share * 1000) rounded / 10) asString, '%    ',
		calls asString, ' calls ') asString) .
	canvas add: poly.

	"percentage inside the slice when the piece is big enough"
	share >= 0.04 ifTrue: [
		canvas add: (RSLabel new
			text: ((share * 1000) rounded / 10) asString, '%';
			color: Color white;
			fontSize: 13;
			position: (pointAt value: angle + (sweep / 2)
				value: radius * 0.63 value: center)) ].

	angle := angle + sweep ].

canvas add: (RSEllipse new color: Color white; extent: 150 @ 150; position: center).
canvas add: (RSLabel new text: totalCalls asString; fontSize: 16;
	color: Color black; position: center + (0 @ -10)).
canvas add: (RSLabel new text: 'sends'; fontSize: 10;
	color: Color gray; position: center + (0 @ 6)).

canvas add: (RSLabel new
	text: ' calls share by package';
	fontSize: 15; color: Color black;
	position: center + (0 @ radius negated - 40)).

legendX := center x + radius + 60.
legendY := center y - (entries size * 24 // 2).
rowH := 24.
entries withIndexDo: [ :assoc :i |
	| y labelTxt label |
	y := legendY + ((i - 1) * rowH).
	canvas add: (RSBox new size: 12; color: (colors at: i); position: legendX @ y).
	labelTxt := (assoc key, '  ',
		(((assoc value) / totalCalls * 1000) rounded / 10) asString,
		'%  ', (assoc value ) asString, ' calls') asString .
	label := RSLabel new text: labelTxt; fontSize: 12; color: Color black.
	canvas add: label.
	label position: (legendX + 14 + (label width / 2)) @ y ].


canvas @ RSZoomableCanvasInteraction.
canvas open.
]
