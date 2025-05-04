function ShowMainMenuView() as Object
    print "MainMenuLogic: Creating MainMenuView"
    mainMenu = CreateObject("roSGNode", "MainMenuView")
    mainMenu.ObserveField("selection", "OnMenuItemSelected")
    
    ' Static content for now; replace with HandlerConfig for dynamic content
    content = CreateObject("roSGNode", "ContentNode")
    radioRow1 = content.createChild("ContentNode")
    radioRow1.title = "Live Radio 1"
    addStation(radioRow1, "101.9 The Bull", "https://stream.radio.com/bull", "pkg:/images/bull.png")
    addStation(radioRow1, "K-Hits 107.5", "https://stream.radio.com/khits", "pkg:/images/khits.png")
    
    radioRow2 = content.createChild("ContentNode")
    radioRow2.title = "Live Radio 2"
    addStation(radioRow2, "Mix 106", "https://stream.radio.com/mix106", "pkg:/images/mix106.png")
    addStation(radioRow2, "Power 105.5", "https://stream.radio.com/power1055", "pkg:/images/power1055.png")
    
    podcastRow = content.createChild("ContentNode")
    podcastRow.title = "Podcasts"
    addPodcast(podcastRow, "Rick & Carly On Demand", "https://rss.feed.com/rickcarly", "pkg:/images/rick_carly.jpg")
    
    mainMenu.content = content
    
    m.top.ComponentController.callFunc("show", {
        view: mainMenu
    })
    print "MainMenuLogic: MainMenuView shown"
    return mainMenu
end function

sub addStation(row, title, url, poster)
    item = row.createChild("ContentNode")
    item.title = title
    item.streamUrl = url
    item.HDPosterUrl = getValidImage(poster, "pkg:/images/placeholder.png")
    item.addField("type", "string", false)
    item.type = "radio"
    print "MainMenuLogic: Adding station - "; title
end sub

sub addPodcast(row, title, url, poster)
    item = row.createChild("ContentNode")
    item.title = title
    item.feedUrl = url
    item.HDPosterUrl = getValidImage(poster, "pkg:/images/placeholder.png")
    item.addField("type", "string", false)
    item.type = "podcast"
    print "MainMenuLogic: Adding podcast - "; title
end sub

function getValidImage(poster, fallback)
    if poster <> invalid and poster <> ""
        return poster
    end if
    return fallback
end function

sub OnMenuItemSelected(event as Object)
    mainMenu = event.GetRoSGNode()
    selectedItem = event.GetData()
    if selectedItem <> invalid
        print "MainMenuLogic: Selected - "; selectedItem.title
        if selectedItem.type = "radio"
            view = CreateObject("roSGNode", "RadioPlaybackView")
            view.content = selectedItem
        else if selectedItem.type = "podcast"
            view = CreateObject("roSGNode", "PodcastLandingView")
            view.content = selectedItem
        else
            print "MainMenuLogic: Unknown item type: "; selectedItem.type
            return
        end if
        m.top.ComponentController.callFunc("show", {
            view: view
        })
        print "MainMenuLogic: Navigated to view for "; selectedItem.title
    end if
end sub