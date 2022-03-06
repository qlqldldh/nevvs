module history

import os
import rss

const article_history_file = "articles"

fn load_article_history() []string {
	article_history := $embed_file(article_history_file)

	return article_history.split("\n")
}

pub fn filter_old_articles(items rss.Item) []string {
	article_history := load_article_history()
	new_articles := items.filter(!(it.link in article_history))

	return new_articles
}

pub fn update_article_history(items rss.Item) ? {
	article_history := os.open_append(article_history_file)?
	defer {
		article_history.close()
	}

	for new_article in filter_old_articles(items) {
		article_history.write("$new_article.link\n")
	}
}
