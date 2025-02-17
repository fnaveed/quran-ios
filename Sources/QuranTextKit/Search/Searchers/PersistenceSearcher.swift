//
//  PersistenceSearcher..swift
//
//
//  Created by Mohamed Afifi on 2021-11-16.
//

import Foundation
import QuranKit

struct PersistenceSearcher: Searcher {
    let versePersistence: SearchableTextPersistence
    let source: SearchResult.Source

    private let termProcessor = SearchTermProcessor()
    private let resultsProcessor = SearchResultsProcessor()

    func autocomplete(term: String, quran: Quran) throws -> [SearchAutocompletion] {
        let processedTerm = termProcessor.prepareSearchTermForAutocompletion(term)
        if processedTerm.isEmpty {
            return []
        }
        let matches = try versePersistence.autocomplete(term: processedTerm)
        return resultsProcessor.buildAutocompletions(searchResults: matches, term: processedTerm)
    }

    func search(for term: String, quran: Quran) throws -> [SearchResults] {
        let processedTerm = termProcessor.prepareSearchTermForSearching(term)
        if processedTerm.searchTerm.isEmpty {
            return []
        }
        let matches = try versePersistence.search(for: processedTerm.searchTerm, quran: quran)
        let items = resultsProcessor.buildSearchResults(searchRegex: processedTerm.pattern, verses: matches)
        return [SearchResults(source: source, items: items)]
    }
}
