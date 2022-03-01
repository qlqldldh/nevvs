module rss

import strings


fn remove_cdata_exp(txt string) string {
	result := strings.find_between_pair_string(txt, "<![CDATA[ ", " ]]>")
	if result == "" {
		return txt
	}

	return result
}

fn parse_xml_element(contents string, t string) ?string {
	result := strings.find_between_pair_string(contents, "<$t>", "</$t>")
	if result == "" {
		return error("not existed xml element in text. [type: $t]")
	}

	return result
}
