module rss

import net.http

pub struct RSSChannel {
pub:
	title string
	link string
	description string
	language string
	copyright string
	last_build_date string
	items []Item
}

fn get_channel(txt string) ?RSSChannel {
	contents := parse_xml_element(txt, "channel")?

	return RSSChannel {
		title: parse_xml_element(contents, "title")?,
		link: parse_xml_element(contents, "link")?,
		description: parse_xml_element(contents, "description")?,
		language: parse_xml_element(contents, "language")?,
		copyright: parse_xml_element(contents, "copyright")?,
		last_build_date: parse_xml_element(contents, "lastBuildDate")?,
		items: get_items(contents.split("</lastBuildDate>")[1])?,
	}
}

pub fn fetch_channel(url string) ?RSSChannel{
	resp := http.get(url) or {panic(err)}

	return get_channel(resp.text)
}
