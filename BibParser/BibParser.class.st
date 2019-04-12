Class {
	#name : #BibParser,
	#superclass : #Object,
	#category : #BibParser
}

{ #category : #'as yet unclassified' }
BibParser >> extractEntryId: aString [
	| begin end |
	begin := (aString indexOf: ${) + 1.
	end := aString size.
	^ aString copyFrom: begin to: end
]

{ #category : #'as yet unclassified' }
BibParser >> extractEntryType: aString [
	| begin end |
	begin := 2.
	end := (aString indexOf: ${) - 1.
	^ aString copyFrom: begin to: end
]

{ #category : #'as yet unclassified' }
BibParser >> handleDuplicateFields: anArrayOfAssociations [
	| keys values |
	keys := anArrayOfAssociations collect: [ :assoc | assoc key ].
	keys := keys asBag.
	
	keys doWithOccurrences: [ :key :count |
		(count > 1)
			ifTrue: [ 
				values := anArrayOfAssociations
					select: [ :assoc | assoc key = key ]
					thenCollect: [ :assoc | assoc value ].
					
				(values asSet size > 1)
					ifTrue: [ Error signal: ('Field ''', key, ''' has different values.') ] ] ].
			
		^ keys asSet collect: [ :key |
			anArrayOfAssociations detect: [ :assoc | assoc key = key ] ].
]

{ #category : #parsing }
BibParser >> parse: aFileReference [
	| stream contents cleaner records |
	stream := aFileReference readStream.
	contents := stream upToEnd.
	
	cleaner := BibStringCleaner new.
	contents := cleaner cleanup: contents.
	records := self splitBibEntries: contents.
	
	^ records collect: [ :each | self parseBibEntry: each ].
	
]

{ #category : #'as yet unclassified' }
BibParser >> parseBibEntry: aString [ 
	| re opening entryType entryId fieldsStr entryFields |
	
	re := self regexForEntryOpening.
	opening := (re matchesIn: aString) first.
	
	entryType := self extractEntryType: opening.
	entryId := self extractEntryId: opening.
	
	fieldsStr := (aString copyFrom: opening size + 1 to: aString size - 1) trimBoth.
	entryFields := self parseBibFields: fieldsStr.
	
	^ BibEntry
		type: entryType
		id: entryId
		fields: entryFields.
]

{ #category : #'as yet unclassified' }
BibParser >> parseBibField: aString [ 
	| eqIndex key value |
	eqIndex := aString indexOf: $=.
	key := (aString copyFrom: 1 to: eqIndex - 1) trimRight.
	value := (((aString copyFrom: eqIndex + 1 to: aString size)
		trimLeft
		trimLeft: [ :c | c = ${ ])
		trimRight: [ :c | c = $} ])
		trimBoth.
	^ key -> value
]

{ #category : #'as yet unclassified' }
BibParser >> parseBibFields: aString [
	| arrayOfFieldStrings arrayOfAssociations |
	arrayOfFieldStrings := self splitBibFields: aString.
	arrayOfAssociations := arrayOfFieldStrings collect: [ :each | self parseBibField: each ].
	^ self handleDuplicateFields: arrayOfAssociations.
]

{ #category : #'as yet unclassified' }
BibParser >> regexForBibField [
	^ '[^(=|,|\s)]+(\s+)?\=(\s+)?\{[^}]+\}' asRegex
]

{ #category : #'as yet unclassified' }
BibParser >> regexForEntryOpening [
	^ '\@\w+\s?{\s?\w+' asRegex
]

{ #category : #'as yet unclassified' }
BibParser >> splitBibEntries: aString [ 
	| re entryOpenings stringWithSeparators entries |
	re := self regexForEntryOpening.
	entryOpenings := re matchesIn: aString.
	stringWithSeparators := re copy: aString replacingMatchesWith: String cr.
	entries := stringWithSeparators lines copyWithoutFirst.
	^ entries withIndexCollect: [ :each :i |
		(entryOpenings at: i), each trimRight ].
]

{ #category : #'as yet unclassified' }
BibParser >> splitBibFields: aString [
	| re |
	re := self regexForBibField.
	^ (re matchesIn: aString trimBoth) asArray.
]
