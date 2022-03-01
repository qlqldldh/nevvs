import rss

const rss_sample = "
<channel>
    <title>테크데일리(TechDaily) - 컴퓨팅</title>
    <link>http://www.techdaily.co.kr</link>
    <description>테크데일리(TechDaily)</description>
    <language>ko</language>
    <copyright>Copyright (c) www.techdaily.co.kr All rights reserved</copyright>
    <lastBuildDate>2022-03-01 11:26:21</lastBuildDate>
    <item>
        <title>“아시아, 작년 한 해 사이버 공격 가장 많이 받아”</title>
        <link>http://www.techdaily.co.kr/news/articleView.html?idxno=20486</link>
        <description>
            <![CDATA[ 작년 한 해 사이버 공격의 26%가 아시아에 있는 표적을 조준하며 한국을 포함한 아시아가 전 세계에서 가장 많은 사이버 공격을 받은 것으로 나타났다.IBM 시큐리티(IBM Security)는 이 같은 내용이 담긴 연례 보고서 ‘엑스포스 위협 인텔리전스 인덱스 보고서(X-Force Threat Intelligence Index)’를 28일 발표했다.보고서에 따르면 산업별로는 제조업이 전체의 23%로 가장 많은 공격을 받았으며, 특히 랜섬웨어 및 소프트웨어 취약점을 활용한 사이버 공격 비중이 전년 대비 크게 증가한 것으로 나타났다.엑스 ]]>
        </description>
        <author>
            <![CDATA[ 김태훈 기자 ]]>
        </author>
        <pubDate>2022-02-28 19:17:53</pubDate>
    </item>
</channel>
"

fn test_get_channel_reutrn_channel_object() {
	channel := rss.get_channel(rss_sample) or {panic(err)}

	assert channel.title == "테크데일리(TechDaily) - 컴퓨팅"
	assert channel.link == "http://www.techdaily.co.kr"
	assert channel.description == "테크데일리(TechDaily)"
	assert channel.language == "ko"
	assert channel.copyright == "Copyright (c) www.techdaily.co.kr All rights reserved"
	assert channel.last_build_date == "2022-03-01 11:26:21"	
}

fn test_get_channel_with_invalid_tag_raise_exception() {
	tags_in_rss := ["channel", "link", "description", "title", "item", "author"]
	invalid_tag := "invalid"

	for tag in tags_in_rss {
		invalid_rss := rss_sample.replace(tag, invalid_tag)
		invalid_channel := rss.get_channel(invalid_rss) or {rss.Channel {}}

		assert invalid_channel.title == ""
		assert invalid_channel.link == ""
		assert invalid_channel.description == ""
		assert invalid_channel.language == ""
		assert invalid_channel.copyright == ""
		assert invalid_channel.last_build_date == ""
	}
}
