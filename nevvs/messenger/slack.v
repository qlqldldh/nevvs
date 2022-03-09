module messenger

import os
import json
import net.http
import rss
import history as hist


pub struct WebHookForm {
	channel string
	attachments []Attachment
}

pub struct Attachment {
	fallback string
	pretext string
	color string
	author_name string
	title string
	title_link string
	text string
	footer string
}

fn item_to_attachment(item rss.Item, copyright string) Attachment {
	return Attachment {
		fallback: "New IT News",
		pretext: item.pub_date,
		color: "#f542f2",
		author_name: item.author,
		title: item.title,
		title_link: item.link,
		text: item.description,
		footer: copyright,
	}
}

fn (wb WebHookForm) to_json() string {
	return json.encode(wb)
}

pub fn webhook_from_channel(channel rss.Channel) WebHookForm {
	items := hist.filter_old_articles(channel.items)

	return WebHookForm {
		channel: os.getenv("SLACK_CHANNEL"),
		attachments: items.map(item_to_attachment(it, channel.copyright)),
	}
}

pub fn (wb WebHookForm) post() http.Response {
	slack_url := os.getenv("SLACK_URL")
	resp := http.post_json(slack_url, wb.to_json()) or {panic(err)}

	return resp
}
