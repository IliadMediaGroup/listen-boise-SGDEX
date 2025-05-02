sub init()
    m.navMenu = m.top.findNode("menuList")
    m.viewContainer = m.top.findNode("viewContainer")
    m.playbackCard = m.top.findNode("playbackCard")
    m.nowPlayingLabel = m.top.findNode("nowPlayingLabel")
    m.controlButton = m.top.findNode("controlButton")
    
    ' Initialize global media player
    m.video = CreateObject("roSGNode", "Video")
    m.video.id = "globalVideo"
    m.video.translation = [0, 0]
    m.video.width = 1920
    m.video.height = 1080
    m.top.appendChild(m.video)
    
    ' Set up navigation menu observer
    m.navMenu.observeField("itemSelected", "onMenuItemSelected")
    
    ' Initialize SGDEX
    SGDEX_Init()
    
    ' Load initial view (Listen Live)
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
    ' Placeholder for Listen Live view
    clearViewContainer()
    view = CreateObject("roSGNode", "Group")
    view.id = "listenLiveView"
    label = CreateObject("roSGNode", "Label")
    label.text = "Listen Live Placeholder"
    label.translation = [0, 0]
    view.appendChild(label)
    m.viewContainer.appendChild(view)
end sub

sub showPodcastsView()
    ' Placeholder for Podcasts view
    clearViewContainer()
    view = CreateObject("roSGNode", "Group")
    view.id = "podcastsView"
    label = CreateObject("roSGNode", "Label")
    label.text = "Podcasts Placeholder"
    label.translation = [0, 0]
    view.appendChild(label)
    m.viewContainer.appendChild(view)
end sub

sub showNowPlayingView()
    ' Placeholder for Now Playing view
    clearViewContainer()
    view = CreateObject("roSGNode", "Group")
    view.id = "nowPlayingView"
    label = CreateObject("roSGNode", "Label")
    label.text = "Now Playing Placeholder"
    label.translation = [0, 0]
    view.appendChild(label)
    m.viewContainer.appendChild(view)
end sub

sub clearViewContainer()
    ' Remove existing view from container
    children = m.viewContainer.getChildren(-1, 0)
    for each child in children
        m.viewContainer.removeChild(child)
    end for
end sub