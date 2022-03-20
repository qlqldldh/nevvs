module rss

import strings


fn remove_cdata_exp(txt string) string {
	result := strings.find_between_pair_string(txt, "<![CDATA[", "]]>")
	if result == "" {
		return txt
	}

	return result
}

fn parse_xml_element(contents string, t string, rm_cdata bool) ?string {
	mut result := strings.find_between_pair_string(contents, "<$t>", "</$t>")
	if result == "" {
		return error("not existed xml element in text. [type: $t]")
	}
	if rm_cdata {
		result = remove_cdata_exp(result)
	}

	return result.replace("&quot;", "\"").replace("&apos;", "'")
}
