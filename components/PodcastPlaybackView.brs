Sub init()
    print "PodcastPlaybackView: Entering init"
    
    m.video = m.top.findNode("video")
    m.video.observeField("state", "onVideoStateChange")
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "PodcastPlaybackView: Playing - " + content.title
        m.video.content = createObject("roSGNode", "ContentNode")
        m.video.content.url = content.url
        m.video.control = "play"
    end if
End Sub

Sub onVideoStateChange()
    print "PodcastPlaybackView: Video state - " + m.video.state
End Sub