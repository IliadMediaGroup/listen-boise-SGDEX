Sub init()
    print "RadioPlaybackView: Entering init"
    m.mediaView = m.top.findNode("mediaView")
    m.mediaView.observeField("state", "onMediaStateChange")
    m.componentController = m.top.findNode("componentController")
End Sub

Sub show(args as Object)
    print "RadioPlaybackView: Showing view with args: "; args
    if args.content <> invalid
        m.top.content = args.content
    end if
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "RadioPlaybackView: Playing - "; content.title
        contentNode = createObject("roSGNode", "ContentNode")
        contentNode.update({
            url: content.streamUrl,  ' Replace with your radio stream URL
            title: content.title,
            streamFormat: "mp3",    ' Adjust based on your stream format
            contentType: "live"
        })
        m.mediaView.content = contentNode
        m.mediaView.isAudioMode = true
        m.mediaView.control = "play"
    else
        print "RadioPlaybackView: ERROR - Invalid content"
    end if
End Sub

Sub onMediaStateChange()
    print "RadioPlaybackView: Media state - "; m.mediaView.state
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    if press and key = "back"
        m.componentController.callFunc("closeView")
        return true
    end if
    return false
End Function