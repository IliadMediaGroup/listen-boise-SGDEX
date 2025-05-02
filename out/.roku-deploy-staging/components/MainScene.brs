sub init()
    m.navMenu = m.top.findNode("menuList")
    m.viewContainer = m.top.findNode("viewContainer")
    m.playbackCard = m.top.findNode("playbackCard")
    m.nowPlayingLabel = m.top.findNode("nowPlayingLabel")
    m.playPauseButton = m.top.findNode("playPauseButton")
    m.stopButton = m.top.findNode("stopButton")
    
    ' Initialize global media player
    m.video = CreateObject("roSGNode", "Video")
    m.video.id = "globalVideo"
    m.video.translation = [0, 0]
    m.video.width = 1920
    m.video.height = 1080
    m.top.appendChild(m.video)
    m.video.observeField("state", "onPlaybackStateChange")
    
    ' Initialize metadata task
    m.metadataTask = CreateObject("roSGNode", "MetadataTask")
    m.metadataTask.observeField("metadata", "onMetadataUpdate")
    
    ' Set up observers
    m.navMenu.observeField("itemSelected", "onMenuItemSelected")
    m.playPauseButton.observeField("buttonSelected", "onPlayPauseButton")
    m.stopButton.observeField("buttonSelected", "onStopButton")
    
    ' Initialize SGDEX
    SGDEX_Init()
    
    ' Load initial view
    showListenLiveView()
end sub

sub onMenuItemSelected()
    selectedIndex = m.navMenu.itemSelected
    if selectedIndex = 0
        showListenLiveView()
    else if selectedIndex = 1
        showPodcastsView()
    else if selectedIndex = 2
        showNowPlayingView()
    end if
end sub

sub showListenLiveView()
    clearViewContainer()
    view = CreateObject("roSGNode", "ListenLiveView")
    view.id = "listenLiveView"
    m.viewContainer.appendChild(view)
    updatePlaybackCard()
end sub

sub showPodcastsView()
    clearViewContainer()
    view = CreateObject("roSGNode", "PodcastsView")
    view.id = "podcastsView"
    m.viewContainer.appendChild(view)
    updatePlaybackCard()
end sub

sub showNowPlayingView()
    clearViewContainer()
    view = CreateObject("roSGNode", "NowPlayingView")
    view.id = "nowPlayingView"
    m.viewContainer.appendChild(view)
    updatePlaybackCard()
end sub

sub clearViewContainer()
    children = m.viewContainer.getChildren(-1, 0)
    for each child in children
        m.viewContainer.removeChild(child)
    end for
end sub

sub onPlaybackStateChange()
    if m.video.state = "stopped"
        m.playbackCard.visible = false
        m.metadataTask.control = "stop"
        m.nowPlayingLabel.text = "Now Playing: "
    else if m.video.state = "playing" or m.video.state = "paused"
        m.playbackCard.visible = true
        updatePlaybackCard()
        if m.playPauseButton.visible
            m.playPauseButton.setFocus(true)
        else
            m.stopButton.setFocus(true)
        end if
    end if
end sub

sub onPlayPauseButton()
    if m.video.state = "playing"
        m.video.control = "pause"
        m.playPauseButton.text = "Play"
    else if m.video.state = "paused"
        m.video.control = "play"
        m.playPauseButton.text = "Pause"
    end if
end sub

sub onStopButton()
    m.video.control = "stop"
    m.playbackCard.visible = false
    m.metadataTask.control = "stop"
end sub

sub onMetadataUpdate()
    metadata = m.metadataTask.metadata
    if metadata <> invalid
        m.nowPlayingLabel.text = "Now Playing: " + metadata.artist + " - " + metadata.song
        nowPlayingView = m.viewContainer.getChild(0)
        if nowPlayingView <> invalid and nowPlayingView.subType() = "NowPlayingView"
            nowPlayingView.callFunc("updateMetadata", metadata)
        end if
    end if
end sub

sub updatePlaybackCard()
    content = m.video.content
    if content <> invalid
        isVideo = content.getFields().isVideo = true
        m.playPauseButton.visible = isVideo
        m.playPauseButton.text = m.video.state = "playing" ? "Pause" : "Play"
    end if
end sub