Sub init()
    print "PodcastPlaybackView: Entering init"
    m.mediaView = m.top.findNode("mediaView")
    m.mediaView.observeField("state", "onMediaStateChange")
    m.componentController = m.top.findNode("componentController")
End Sub

Sub show(args as Object)
    print "PodcastPlaybackView: Showing view with args: "; args
    if args.content <> invalid
        m.top.content = args.content
    end if
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "PodcastPlaybackView: Playing - "; content.title
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
    else
        print "PodcastPlaybackView: ERROR - Invalid content"
    end if
End Sub

Sub onMediaStateChange()
    print "PodcastPlaybackView: Media state - "; m.mediaView.state
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    if press and key = "back"
        m.componentController.callFunc("closeView")
        return true
    end if
    return false
End Function