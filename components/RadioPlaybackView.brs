Sub init()
    print "RadioPlaybackView: Entering init"
    
    m.poster = m.top.findNode("poster")
    m.title = m.top.findNode("title")
    m.title.font = m.top.findNode("font")
    m.metadata = m.top.findNode("metadata")
    m.metadata.font = m.top.findNode("metadataFont")
    
    m.audio = createObject("roSGNode", "Audio")
    m.audio.observeField("state", "onAudioStateChange")
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "RadioPlaybackView: Playing - " + content.title
        m.poster.uri = content.HDPosterUrl
        m.title.text = content.title
        m.metadata.text = "Loading metadata..."
        
        m.audio.content = createObject("roSGNode", "ContentNode")
        m.audio.content.url = content.streamUrl
        m.audio.control = "play"
        
        fetchMetadata(content.metadataUrl)
    end if
End Sub

Sub fetchMetadata(url as String)
    ' Placeholder: Implement Task node to fetch metadata
    print "RadioPlaybackView: Fetching metadata from " + url
    m.metadata.text = "Sample metadata" ' Replace with actual fetching
End Sub

Sub onAudioStateChange()
    print "RadioPlaybackView: Audio state - " + m.audio.state
End Sub