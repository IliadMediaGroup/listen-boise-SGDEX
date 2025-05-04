Sub init()
    print "PodcastContentHandler: Entering init"
    m.top.functionName = "GetContent"
End Sub

Sub GetContent()
    print "PodcastContentHandler: Fetching RSS"
    config = m.top.HandlerConfig
    if config = invalid or config.fields = invalid or config.fields.url = invalid or config.fields.url = ""
        print "PodcastContentHandler: ERROR - Invalid HandlerConfig or URL"
        m.top.content = invalid
        m.top.failed = true
        return
    end if
    url = config.fields.url
    print "PodcastContentHandler: Fetching RSS from " + url

    ' Fetch RSS feed using roUrlTransfer
    urlTransfer = createObject("roUrlTransfer")
    urlTransfer.setUrl(url)
    urlTransfer.setCertificatesFile("common:/certs/ca-bundle.crt")
    urlTransfer.initClientCertificates()
    xmlString = urlTransfer.getToString()
    
    if xmlString = ""
        print "PodcastContentHandler: ERROR - Failed to fetch RSS feed"
        m.top.content = invalid
        m.top.failed = true
        return
    end if

    ' Parse RSS XML
    xml = createObject("roXMLElement")
    if not xml.parse(xmlString)
        print "PodcastContentHandler: ERROR - Failed to parse RSS XML"
        m.top.content = invalid
        m.top.failed = true
        return
    end if

    ' Create ContentNode for seasons and episodes
    content = createObject("roSGNode", "ContentNode")
    
    ' Assume single season for simplicity
    season = content.createChild("ContentNode")
    season.title = "Season 1"
    season.contentType = "section"
    
    ' Process RSS items (episodes)
    items = xml.getChildElements()
    for each item in items
        if item.getName() = "channel"
            for each subItem in item.getChildElements()
                if subItem.getName() = "item"
                    episode = season.createChild("ContentNode")
                    title = subItem.getChildElementsByName("title")
                    if title <> invalid and title.getText() <> ""
                        episode.title = title.getText()
                    else
                        episode.title = "Untitled Episode"
                    end if
                    enclosure = subItem.getChildElementsByName("enclosure")
                    if enclosure <> invalid
                        episode.url = enclosure@url ' For MediaView
                        episode.streamUrl = enclosure@url ' For consistency
                    end if
                    description = subItem.getChildElementsByName("description")
                    if description <> invalid and description.getText() <> ""
                        episode.description = description.getText()
                    end if
                    pubDate = subItem.getChildElementsByName("pubDate")
                    if pubDate <> invalid and pubDate.getText() <> ""
                        episode.releaseDate = pubDate.getText()
                    end if
                    episode.contentType = "episode"
                    episode.hdPosterUrl = "pkg:/images/default_podcast.png" ' Placeholder
                    print "PodcastContentHandler: Added episode - " + episode.title
                end if
            end for
        end if
    end for

    if content.getChildCount() = 0
        print "PodcastContentHandler: ERROR - No episodes found in RSS feed"
        m.top.content = invalid
        m.top.failed = true
        return
    end if

    m.top.content = content
    m.top.failed = false
    print "PodcastContentHandler: RSS content set with " + content.getChildCount().toStr() + " seasons"
End Sub