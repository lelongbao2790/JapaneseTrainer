//
//  CommonString.h
//  HDOnline
//
//  Created by Bao (Brian) L. LE on 5/6/16.
//  Copyright © 2016 LongBao. All rights reserved.
//

#ifndef CommonString_h
#define CommonString_h

// List Content
static NSString *kContentCellIdentifier = @"ContentCellIdentifier";
static NSString *kIdentifierGrammar = @"grammarIdentifier";
static NSString *kIdentifierListGrammar = @"listGrammarIdentifier";
static NSString *kVocabularyIdentifier = @"VocabularCellIdentifier";

// Vocabulary
static NSString *kVocabularyLevelN5 = @"JLPT Level N5";
static NSString *kVocabularyLevelN4 = @"JLPT Level N4";
static NSString *kVocabularyLevelN3 = @"JLPT Level N3";
static NSString *kVocabularyLevelN2 = @"JLPT Level N2";
static NSString *kVocabularyLevelN1 = @"JLPT Level N1";
static NSString *kSearchWord = @"Search word";

// PLIST
static NSString *kObjects = @"Objects";
static NSString *kName = @"Name";
static NSString *kGrammar = @"grammar";
static NSString *kVocabulary = @"vocabulary";
static NSString *kListening = @"listening";
static NSString *kWriting = @"writing";
static NSString *kNamePlist = @"listcontent";
static NSString *kPlist = @"plist";
static NSString *kNameDB = @"dbJapaneseTrainer";
static NSString *kLink = @"Link";
static NSString *kLoading = @"Loading";
static NSString *kEmpty = @"";
static NSString *kStringEmpty = @"emptyString";
static NSString *kHiragana = @"Hiragana";
static NSString *kKatagana = @"Katagana";
static NSString *kHiraganaKey = @"hiragana";
static NSString *kRomanjiKey = @"romanji";

// Fixed auto layout for multiple device
static NSString *kFixAutoLayoutForIp4 = @"fixAutolayoutFor35";
static NSString *kFixAutoLayoutForIp5 = @"fixAutolayoutFor40";
static NSString *kFixAutoLayoutForIp6 = @"fixAutolayoutFor47";
static NSString *kFixAutoLayoutForIp6Plus = @"fixAutolayoutFor55";
static NSString *kFixAutoLayoutForIpad = @"fixAutolayoutForIpad";

// Parse HTMl
static NSString *kHref = @"href";
static NSString *kQueryListGrammar = @"//a[@class='nounderline']";
static NSString *kQueryListVocabulary = @"//a[@class='nounderline']";
static NSString *kQueryDetailGrammar = @"//div[@id='contentright']/ul/li";
static NSString *kTagTdEmpty = @"<td></td>";
static NSString *kTagTdReplace = @"<td><a class=\"nounderline\" href=\"/jlpt/skills/vocab/sentences/?vocabid=77206\">emptyString</a></td>";

static NSString *kMeaningKanjiTag = @"//p[@class='k-meaning']";
static NSString *kReadingKanjiTag = @"//p[@class='k-readings']";
static NSString *kDrawKanjiTag = @"//div[@class='k-sod']";
static NSString *kExampleKanjiTag = @"//table[@class='k-compounds-table']";

//static NSString *kQuerySearch = @"//a[@class='btn btn-link entry-menu']";
static NSString *kQuerySearch = @"//div[@class='entry']";
static NSString *kFirstRawSearchReplace = @"<a class=\"btn btn-link entry-menu\" onclick=\"entryMenu(this,{";
static NSString *kSecondRawSearchReplace = @"},&#10;&#9;&#9;this);\"><i class=\"icon-plus-sign\"/></a>";
static NSString *kUnknownCharater1 = @"\n\t\t";
static NSString *kUnknownCharater2 = @"'";

// Regex
static NSString *kRegExAZ = @"()";

// Search Parse
static NSString *kW = @"w";
static NSString *kK = @"k";
static NSString *kM = @"m";
static NSString *kR = @"r";

#endif /* CommonString_h */
