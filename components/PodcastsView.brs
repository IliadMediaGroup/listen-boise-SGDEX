sub init()
    m.grid = m.top.findNode("podcastGrid")
    m.grid.observeField("itemSelected", "onGridItemSelected")
    loadPodcasts()
end sub

sub loadPodcasts()
    content = CreateObject("roSGNode", "ContentNode")
    podcasts = [
        {title: "Rick & Carly On Demand", rssUrl: "https://feeds.acast.com/public/shows/674e35774cf32e7b944eccd3", poster: "pkg:/images/rick_carly.jpg"},
        {title: "Joey & Lauren On Demand", rssUrl: "https://feeds.acast.com/public/shows/6750bbfe0ee2b79e33134fad", poster: "pkg:/images/joey_lauren.png"},
        {title: "Hey Morton On Demand", rssUrl: "https://feeds.acast.com/public/shows/675237266af55bd515d4d2d7", poster: "pkg:/images/hey_morton.png"},
        {title: "Diabetes Oasis", rssUrl: "https://feeds.acast.com/public/shows/675236792dd88df1321d6b28", poster: "pkg:/images/diabetes_oasis.png"},
        {title: "Up Next", rssUrl: "https://feeds.acast.com/public/shows/675237e3d40c6cb2e0112347", poster: "pkg:/images/up_next.jpg"},
        {title: "The Marketing Expedition", rssUrl: "https://static.adorilabs.com/feed/marketing-expedition-podcast-with-rhea-allen-peppershock-media-7682.xml", poster: "pkg:/images/marketing_expedition.jpg"},
        {title: "Brain Over Belly", rssUrl: "https://feeds.acast.com/public/shows/6750f308f318f34867692de2", poster: "pkg:/images/brain_over_belly.jpg"},
        {title: "BoiseDev Podcast", rssUrl: "https://feeds.acast.com/public/shows/6750d305aeaa2d78dfb137bf", poster: "pkg:/images/boisedev.jpg"}
    ]
    
    for each podcast in podcasts
        item = content.CreateChild("ContentNode")
        item.title = podcast.title
        item.HDPosterUrl = podcast.poster
        item.addFields({rssUrl: podcast.rssUrl})
    end for
    
    m.grid.content = content
end sub

sub onGridItemSelected()
    selectedIndex = m.grid.itemSelected
    item = m.grid.content.getChild(selectedIndex)
    
    ' Create EpisodePickerView
    episodeView = CreateObject("roSGNode", "EpisodePickerView")
    episodeView.contentUri = item.rssUrl
    episodeView.observeField("selectedItem", "onEpisodeSelected")
    
    ' Replace current view with EpisodePickerView
    m.top.getScene().findNode("viewContainer").removeChildrenIndex(-1, 0)
    m.top.getScene().findNode("viewContainer").appendChild(episodeView)
end sub

sub onEpisodeSelected()
    episodeView = m.top.getScene().findNode("viewContainer").getChild(0)
    selectedItem = episodeView.selectedItem
    
    if selectedItem <> invalid
        content = CreateObject("roSGNode", "ContentNode")
        content.url = selectedItem.stream
        content.streamFormat = "mp4"
        content.addFields({isVideo: true})
        
        ' Play episode
        m.top.getScene().findNode("globalVideo").content = content
        m.top.getScene().findNode("globalVideo").control = "play"
        
        ' Show playback card
        playbackCard = m.top.getScene().findNode("playbackCard")
        playbackCard.visible = true
        nowPlayingLabel = m.top.getScene().findNode("nowPlayingLabel")
        nowPlayingLabel.text = "Now Playing: " + selectedItem.title
        controlButton = m.top.getScene().findNode("playPauseButton")
        controlButton.text = "Pause"
    end if
end sub