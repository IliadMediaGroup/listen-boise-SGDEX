sub init()
    m.videoPlayer = m.top.findNode("videoPlayer")
    m.metadataGroup = m.top.findNode("metadataGroup")
    m.albumArt = m.top.findNode("albumArt")
    m.titleLabel = m.top.findNode("titleLabel")
    m.artistLabel = m.top.findNode("artistLabel")
    m.albumLabel = m.top.findNode("albumLabel")
    
    globalVideo = m.top.getScene().findNode("globalVideo")
    globalVideo.observeField("content", "onContentChange")
    globalVideo.observeField("state", "onPlaybackStateChange")
    
    onContentChange()
end sub

sub onContentChange()
    globalVideo = m.top.getScene().findNode("globalVideo")
    content = globalVideo.content
    
    if content <> invalid
        isVideo = content.getFields().isVideo = true
        m.videoPlayer.visible = isVideo
        m.metadataGroup.visible = not isVideo
        
        if isVideo
            m.videoPlayer.content = content
            m.videoPlayer.control = globalVideo.control
        else
            m.titleLabel.text = content.title
        end if
    end if
end sub

sub onPlaybackStateChange()
    globalVideo = m.top.getScene().findNode("globalVideo")
    playbackCard = m.top.getScene().findNode("playbackCard")
    
    if globalVideo.state = "stopped"
        playbackCard.visible = false
    else if globalVideo.state = "playing" or globalVideo.state = "paused"
        playbackCard.visible = true
    end if
end sub

sub updateMetadata(metadata as object)
    if m.metadataGroup.visible
        m.titleLabel.text = metadata.song
        m.artistLabel.text = metadata.artist
        m.albumLabel.text = metadata.album
        if metadata.albumArt <> "" then m.albumArt.uri = metadata.albumArt
    end if
end sub