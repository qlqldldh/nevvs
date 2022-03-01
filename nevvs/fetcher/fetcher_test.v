import os
import conf
import fetcher

fn test_fetch_channel_return_channel() {
	res_code := conf.set_env_cfg("test") or {panic(err)}

	assert res_code == 0

	url := os.getenv("RSS_URL")
	channel := fetcher.fetch_channel(url) or {panic(err)}

	assert channel.title != ""
	assert channel.link != ""
	assert channel.description != ""
	assert channel.language != ""
	assert channel.copyright != ""
	assert channel.last_build_date != ""
}
