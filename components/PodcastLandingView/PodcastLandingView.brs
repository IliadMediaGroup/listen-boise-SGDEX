Sub init()
    print "PodcastLandingView: Entering init"
    m.podcastList = m.top.findNode("podcastList")
    m.podcastList.observeField("rowItemSelected", "onItemSelected")
    m.componentController = m.top.findNode("componentController")
    m.podcastList.setFocus(true)
End Sub

Sub show(args as Object)
    print "PodcastLandingView: Showing view with args: "; args
    if args.content <> invalid
        m.top.content = args.content
    else
        loadContent()
    end if
End Sub

Sub loadContent()
    print "PodcastLandingView: Loading content"
    content = createObject("roSGNode", "ContentNode")
    ' Add podcast items here (replace with your feed or data source)
    podcastItem = content.createChild("ContentNode")
    podcastItem.title = "Sample Podcast"
    podcastItem.description = "A sample podcast description"
    podcastItem.url = "https://example.com/podcast.mp3"
    m.top.content = content
End Sub

Sub onContentSet()
    print "PodcastLandingView: Content set"
    m.podcastList.content = m.top.content
End Sub

Sub onItemSelected()
    selectedIndex = m.podcastList.rowItemSelected
    rowIndex = selectedIndex[0]
    itemIndex = selectedIndex[1]
    selectedItem = m.podcastList.content.getChild(rowIndex).getChild(itemIndex)
    if selectedItem <> invalid
        print "PodcastLandingView: Selected - "; selectedItem.title
        m.componentController.callFunc("showView", { view: "PodcastPlaybackView", args: { content: selectedItem } })
    end if
End Sub