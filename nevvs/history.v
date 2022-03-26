module main

import os
import rss

const article_history_file = "articles"

fn load_article_history() []string {
	article_history := os.read_lines(article_history_file) or {panic(err)}

	return article_history
}

pub fn filter_old_articles(items []rss.Item) []rss.Item {
	article_history := load_article_history()
	new_articles := items.filter(!(it.link in article_history))

	return new_articles
}

pub fn update_article_history(items []rss.Item) ? {
	mut article_history := os.open_append(article_history_file)?
	defer {
		article_history.close()
	}

	for new_article in filter_old_articles(items) {
		article_history.write("$new_article.link\n".bytes()) or {panic(err)}
	}
}
