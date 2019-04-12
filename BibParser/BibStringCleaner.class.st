Class {
	#name : #BibStringCleaner,
	#superclass : #Object,
	#category : #BibParser
}

{ #category : #cleaning }
BibStringCleaner >> cleanup: aString [
	| cleanString |
	cleanString := self removeEmptyLinesAndComments: aString.
	cleanString := self cleanupSpaces: cleanString.
	^ cleanString
]

{ #category : #parsing }
BibStringCleaner >> cleanupSpaces: aString [
	"Replaces multiple spaces, tabulations, and newlines with a single space"
	^ ('\s+' asRegex copy: aString replacingMatchesWith: ' ') trimBoth.
]

{ #category : #parsing }
BibStringCleaner >> removeEmptyLinesAndComments: aString [
	"Removes empty lines and comments from aString"
	| lines |
	lines := aString lines.
	lines := lines reject: [ :each | each trimLeft isEmpty ].
	lines := lines reject: [ :each | each trimLeft first = $% ].
	^ ' ' join: lines.
]
