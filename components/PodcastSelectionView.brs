Sub init()
    print "PodcastPlaybackView: Entering init"
    
    m.mediaView = m.top.findNode("mediaView")
    m.buttonBar = m.top.findNode("buttonBar")
    
    if m.mediaView = invalid or m.buttonBar = invalid
        print "PodcastPlaybackView: ERROR - One or more nodes not found"
        return
    end if
    
    m.mediaView.observeField("state", "onMediaStateChange")
    m.buttonBar.observeField("buttonSelected", "onButtonSelected")
    
    configureButtonBar()
    if m.buttonBar <> invalid
        m.buttonBar.setFocus(true)
    else
        print "PodcastPlaybackView: ERROR - Cannot set focus, buttonBar invalid"
    end if
End Sub

Sub configureButtonBar()
    print "PodcastPlaybackView: Configuring ButtonBar"
    if m.buttonBar = invalid
        print "PodcastPlaybackView: ERROR - buttonBar is invalid"
        return
    end if
    
    buttons = []
    for each btn in [
        { title: "Play", id: "play" },
        { title: "Pause", id: "pause" },
        { title: "Next", id: "next" },
        { title: "Previous", id: "previous" }
    ]
        btnNode = createObject("roSGNode", "ContentNode")
        btnNode.title = btn.title
        btnNode.id = btn.id
        buttons.push(btnNode)
    end for
    m.buttonBar.buttons = buttons
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "PodcastPlaybackView: Playing - " + content.title
        contentNode = createObject("roSGNode", "ContentNode")
        contentNode.update({
            url: content.url,
            title: content.title,
            description: content.description,
            streamFormat: "mp3",
            contentType: "episode"
        })
        m.mediaView.content = contentNode
        m.mediaView.isAudioMode = true
        m.mediaView.control = "play"
        if m.buttonBar <> invalid
            m.buttonBar.setFocus(true)
        else
            print "PodcastPlaybackView: ERROR - Cannot set focus, buttonBar invalid"
        end if
    else
        print "PodcastPlaybackView: ERROR - Invalid content"
    end if
End Sub

Sub onMediaStateChange()
    print "PodcastPlaybackView: Media state - " + m.mediaView.state
End Sub

Sub onButtonSelected()
    if m.buttonBar = invalid or m.buttonBar.buttons = invalid
        print "PodcastPlaybackView: ERROR - Invalid buttonBar or buttons"
        return
    end if
    selectedButton = m.buttonBar.buttons[m.buttonBar.buttonSelected]
    if selectedButton <> invalid
        print "PodcastPlaybackView: Button selected - " + selectedButton.id
        if selectedButton.id = "play"
            m.mediaView.control = "play"
        else if selectedButton.id = "pause"
            m.mediaView.control = "pause"
        else if selectedButton.id = "next"
            print "PodcastPlaybackView: Next episode not implemented"
        else if selectedButton.id = "previous"
            print "PodcastPlaybackView: Previous episode not implemented"
        end if
    else
        print "PodcastPlaybackView: ERROR - Invalid button selection"
    end if
End Sub