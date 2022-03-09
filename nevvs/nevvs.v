module main

import os
import net.http

import history as hist
import messenger as msgr
import conf
import rss

pub fn notify_news() {
	conf.set_env_cfg(os.getenv("STAGE")) or {panic(err)}

	channel := rss.fetch_channel(os.getenv("RSS_URL")) or {panic(err)}

	web_hook_form := msgr.webhook_from_channel(channel)
	resp := web_hook_form.post()

	if http.status_from_int(resp.status_code) != http.Status.ok {
		eprintln(resp.text)
		return
	}
	hist.update_article_history(channel.items) or {panic(err)}

	println("Success to notify updated news.")
}

fn main() {
	notify_news()
}
