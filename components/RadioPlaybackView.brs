Sub init()
    print "RadioPlaybackView: Entering init"
    
    m.poster = m.top.findNode("poster")
    m.title = m.top.findNode("title")
    m.title.font = m.top.findNode("font")
    m.metadata = m.top.findNode("metadata")
    m.metadata.font = m.top.findNode("metadataFont")
    m.mediaView = m.top.findNode("mediaView")
    m.buttonBar = m.top.findNode("buttonBar")
    
    if m.poster = invalid or m.title = invalid or m.metadata = invalid or m.mediaView = invalid or m.buttonBar = invalid
        print "RadioPlaybackView: ERROR - One or more nodes not found"
        return
    end if
    
    m.mediaView.observeField("state", "onMediaStateChange")
    m.buttonBar.observeField("buttonSelected", "onButtonSelected")
    
    ' Initialize ContentManager
    m.contentManager = createObject("roSGNode", "ContentManager")
    if m.contentManager = invalid
        print "RadioPlaybackView: ERROR - ContentManager creation failed"
        return
    end if
    m.contentManager.callFunc("initializeContentManager", { view: m.top })
    
    configureButtonBar()
    m.buttonBar.setFocus(true)
End Sub

Sub configureButtonBar()
    print "RadioPlaybackView: Configuring ButtonBar"
    btnsContent = createObject("roSGNode", "ContentNode")
    btnsContent.update({ children: [
        { title: "Play", id: "play" },
        { title: "Pause", id: "pause" }
    ]})
    m.buttonBar.buttons = btnsContent
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "RadioPlaybackView: Playing - " + content.title
        m.poster.uri = content.HDPosterUrl
        m.title.text = content.title
        m.metadata.text = "Loading metadata..."
        
        contentNode = createObject("roSGNode", "ContentNode")
        contentNode.update({
            url: content.url,
            title: content.title,
            streamFormat: "mp3",
            contentType: "station"
        })
        m.mediaView.content = contentNode
        m.mediaView.isAudioMode = true
        m.mediaView.control = "play"
        
        fetchMetadata(content.metadataUrl)
        m.buttonBar.setFocus(true)
    else
        print "RadioPlaybackView: ERROR - Invalid content"
        m.metadata.text = "No metadata available"
    end if
End Sub

Sub fetchMetadata(url as String)
    print "RadioPlaybackView: Fetching metadata from " + url
    m.metadataHandler = createObject("roSGNode", "MetadataContentHandler")
    if m.metadataHandler = invalid
        print "RadioPlaybackView: ERROR - Failed to create MetadataContentHandler"
        m.metadata.text = "Metadata unavailable"
        return
    end if
    m.metadataHandler.observeField("content", "onMetadataFetched")
    handlerConfig = {
        name: "MetadataContentHandler",
        fields: { url: url }
    }
    m.contentManager.callFunc("loadContent", { handlerConfig: handlerConfig })
End Sub

Sub onMetadataFetched()
    content = m.metadataHandler.content
    if content <> invalid and content.description <> invalid
        m.metadata.text = content.description
        print "RadioPlaybackView: Metadata set - " + content.description
    else
        m.metadata.text = "No metadata available"
        print "RadioPlaybackView: ERROR - No metadata content"
    end if
End Sub

Sub onMediaStateChange()
    print "RadioPlaybackView: Media state - " + m.mediaView.state
End Sub

Sub onButtonSelected()
    selectedButton = m.buttonBar.buttons.getChild(m.buttonBar.buttonSelected)
    if selectedButton <> invalid
        print "RadioPlaybackView: Button selected - " + selectedButton.id
        if selectedButton.id = "play"
            m.mediaView.control = "play"
        else if selectedButton.id = "pause"
            m.mediaView.control = "pause"
        end if
    end if
End Sub