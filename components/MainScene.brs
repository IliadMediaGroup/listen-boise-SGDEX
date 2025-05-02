sub init()
    print "MainScene init start"
    m.navMenu = m.top.findNode("menuList")
    print "navMenu: "; m.navMenu
    m.viewContainer = m.top.findNode("viewContainer")
    print "viewContainer: "; m.viewContainer
    m.playbackCard = m.top.findNode("playbackCard")
    print "playbackCard: "; m.playbackCard
    m.nowPlayingLabel = m.top.findNode("nowPlayingLabel")
    print "nowPlayingLabel: "; m.nowPlayingLabel
    m.playPauseButton = m.top.findNode("playPauseButton")
    print "playPauseButton: "; m.playPauseButton
    m.stopButton = m.top.findNode("stopButton")
    print "stopButton: "; m.stopButton
    
    ' Initialize global media player
    m.video = CreateObject("roSGNode", "Video")
    m.video.id = "globalVideo"
    m.video.translation = [0, 0]
    m.video.width = 1920
    m.video.height = 1080
    m.top.appendChild(m.video)
    m.video.observeField("state", "onPlaybackStateChange")
    print "video: "; m.video
    
    ' Initialize metadata task
    m.metadataTask = CreateObject("roSGNode", "MetadataTask")
    m.metadataTask.observeField("metadata", "onMetadataUpdate")
    print "metadataTask: "; m.metadataTask
    
    ' Set up observers
    m.navMenu.observeField("itemSelected", "onMenuItemSelected")
    m.playPauseButton.observeField("buttonSelected", "onPlayPauseButton")
    m.stopButton.observeField("buttonSelected", "onStopButton")
    
    ' Load initial view
    showListenLiveView()
    
    ' Initialize SGDEX with fallback
    print "Calling SGDEX_Init"
    if GetInterface(SGDEX_Init, "ifFunction") <> invalid
        SGDEX_Init()
        print "SGDEX_Init complete"
    else
        print "SGDEX_Init not available, skipping"
    end if
end sub

function GetSceneName() as String
    return "MainScene"
end function

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
        if m.video.state = "playing"
            m.playPauseButton.text = "Pause"
        else
            m.playPauseButton.text = "Play"
        end if
    end if
end sub