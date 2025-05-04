Sub init()
    print "PodcastSelectionView: Entering init"
    
    m.seasonList = m.top.findNode("seasonList")
    m.episodeGrid = m.top.findNode("episodeGrid")
    
    m.seasonList.observeField("itemSelected", "onSeasonSelected")
    m.episodeGrid.observeField("itemSelected", "onEpisodeSelected")
    
    m.rssTask = createObject("roSGNode", "RSSTask")
    m.rssTask.observeField("content", "onRSSContentFetched")
    
    m.seasonList.setFocus(true)
    print "PodcastSelectionView: Focus set to seasonList"
End Sub

Sub onContentSet()
    content = m.top.content
    if content <> invalid
        print "PodcastSelectionView: Content set - " + content.title
        if content.rssUrl <> "" and content.rssUrl <> invalid
            m.rssTask.url = content.rssUrl
            m.rssTask.control = "RUN"
            print "PodcastSelectionView: Started RSSTask for " + content.rssUrl
        else
            print "PodcastSelectionView: ERROR - Invalid rssUrl"
        end if
    else
        print "PodcastSelectionView: ERROR - Invalid content"
    end if
End Sub

Sub onRSSContentFetched()
    print "PodcastSelectionView: RSS content fetched"
    content = m.rssTask.content
    if content <> invalid
        m.seasonList.content = content
        m.episodeGrid.content = content.getChild(0) ' Select first season
        print "PodcastSelectionView: Loaded " + content.getChildCount().toStr() + " seasons"
    else
        print "PodcastSelectionView: ERROR - No RSS content"
    end if
End Sub

Sub onSeasonSelected()
    selected = m.seasonList.itemSelected
    season = m.seasonList.content.getChild(selected)
    if season <> invalid
        print "PodcastSelectionView: Season selected - " + season.title
        m.episodeGrid.content = season
    else
        print "PodcastSelectionView: ERROR - Invalid season"
    end if
End Sub

Sub onEpisodeSelected()
    selectedRow = m.episodeGrid.rowItemSelected[0]
    selectedCol = m.episodeGrid.rowItemSelected[1]
    episode = m.episodeGrid.content.getChild(selectedRow * m.episodeGrid.numColumns + selectedCol)
    if episode <> invalid
        print "PodcastSelectionView: Episode selected - " + episode.title
        m.top.episodeSelected = episode
    else
        print "PodcastSelectionView: ERROR - Invalid episode"
    end if
End Sub