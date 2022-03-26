module main

import os
import net.http

import rss

pub fn notify_news() {
	channel := rss.fetch_channel(os.getenv("RSS_URL")) or {panic(err)}

	web_hook_form := webhook_from_channel(channel, os.getenv("SLACK_CHANNEL"))
	if web_hook_form.attachments.len == 0 {
		println("Already up to date.")
		return
	}
	resp := web_hook_form.post(os.getenv("SLACK_URL"))

	if http.status_from_int(resp.status_code) != http.Status.ok {
		eprintln(resp.text)
		return
	}
	update_article_history(channel.items) or {panic(err)}

	println("Success to notify updated news.")
}

fn main() {
	set_env_cfg(os.getenv("ENV_NAME")) or {panic(err)}
	notify_news()
}
