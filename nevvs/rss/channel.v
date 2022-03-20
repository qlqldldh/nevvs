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
	contents := parse_xml_element(txt, "channel", false)?

	return RSSChannel {
		title: parse_xml_element(contents, "title", true)?,
		link: parse_xml_element(contents, "link", true)?,
		description: parse_xml_element(contents, "description", true)?,
		language: parse_xml_element(contents, "language", true)?,
		copyright: parse_xml_element(contents, "copyright", true)?,
		last_build_date: parse_xml_element(contents, "lastBuildDate", true)?,
		items: get_items(contents.split("</lastBuildDate>")[1])?,
	}
}

pub fn fetch_channel(url string) ?RSSChannel{
	resp := http.get(url) or {panic(err)}

	return get_channel(resp.text)
}
