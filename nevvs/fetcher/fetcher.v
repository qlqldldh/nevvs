module fetcher

import net.http
import rss

pub fn fetch_channel(url string) ?rss.Channel{
	resp := http.get(url) or {panic(err)}

	return rss.get_channel(resp.text)
}
