module rss


pub struct Item {
pub:
	title string
	link string
	description string
	author string
	pub_date string
}

fn get_item(txt string) ?Item {
	contents := parse_xml_element(txt, "item")?

	return Item {
		title: parse_xml_element(contents, "title")?,
		link: parse_xml_element(contents, "link")?,
		description: remove_cdata_exp(parse_xml_element(contents, "description")?),
		author: remove_cdata_exp(parse_xml_element(contents, "author")?),
		pub_date: parse_xml_element(contents, "pubDate")?,
	}
}

fn get_items(txt string) ?[]Item {
	delimiter := "</item>"
	item_strs := txt.split(delimiter).map(it.trim("\n\r\t")).filter(it != "")

	return item_strs.map(get_item(it + delimiter)?)
}
