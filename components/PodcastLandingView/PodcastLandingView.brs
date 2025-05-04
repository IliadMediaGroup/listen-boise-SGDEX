Sub init()
    print "PodcastLandingView: Entering init"
    
    m.description = m.top.findNode("description")
    m.description.font = m.top.findNode("font")
    m.buttons = m.top.findNode("buttons")
    
    if m.description = invalid or m.buttons = invalid
        print "PodcastLandingView: ERROR - One or more nodes not found"
        return
    end if
    
    m.buttons.observeField("buttonSelected", "onButtonSelected")
    
    ' Initialize ContentManager
    m.contentManager = createObject("roSGNode", "ContentManager")
    if m.contentManager = invalid
        print "PodcastLandingView: ERROR - ContentManager creation failed"
        return
    end if
    m.contentManager.callFunc("initializeContentManager", { view: m.top })
    
    m.buttons.setFocus(true)
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "PodcastLandingView: Content set - " + content.title
        m.description.text = "Loading description..."
        
        ' Fetch RSS description
        m.rssHandler = createObject("roSGNode", "PodcastContentHandler")
        if m.rssHandler = invalid
            print "PodcastLandingView: ERROR - Failed to create PodcastContentHandler"
            return
        end if
        m.rssHandler.observeField("content", "onRSSContentFetched")
        handlerConfig = {
            name: "PodcastContentHandler",
            fields: { url: content.rssUrl }
        }
        m.contentManager.callFunc("loadContent", { handlerConfig: handlerConfig })
    else
        print "PodcastLandingView: ERROR - Invalid content"
        m.description.text = "No description available"
    end if
End Sub

Sub onRSSContentFetched()
    content = m.rssHandler.content
    if content <> invalid and content.getChildCount() > 0
        channel = content.getChild(0)
        if channel.description <> invalid
            m.description.text = channel.description
            print "PodcastLandingView: Description set - " + channel.description
        else
            m.description.text = "No description available"
        end if
    else
        m.description.text = "No description available"
        print "PodcastLandingView: ERROR - No RSS content"
    end if
End Sub

Sub onButtonSelected()
    selected = m.buttons.buttonSelected
    content = m.top.content
    if selected = invalid or content = invalid
        print "PodcastLandingView: ERROR - Invalid button selection or content"
        return
    end if
    print "PodcastLandingView: Button selected - " + m.buttons.buttons[selected].text
    
    if selected = 0
        m.top.action = { type: "playLatest", content: content }
    else if selected = 1
        m.top.action = { type: "browse", content: content }
    end if
End Sub