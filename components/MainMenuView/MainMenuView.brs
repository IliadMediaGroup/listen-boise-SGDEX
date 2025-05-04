Sub init()
    print "MainMenuView: Entering init"
    m.rowList = m.top.findNode("RowList")
    m.rowList.visible = true
    print "MainMenuView: RowList visibility set to true"
    configureGrid()
    m.rowList.observeField("rowItemSelected", "onItemSelected")
    m.top.observeField("content", "onContentSet")
    m.rowList.setFocus(true)
    print "MainMenuView: Focus set to RowList"
End Sub

Sub configureGrid()
    m.rowList.numColumns = 4
    m.rowList.itemSize = [400, 300]
    m.rowList.rowHeights = [300]
    m.rowList.itemSpacing = [20, 20]
    m.rowList.focusBitmapUri = "pkg:/images/focus_grid.9.png"
    print "MainMenuView: Grid configured"
End Sub

Sub show(args as Object)
    print "MainMenuView: Showing view with args: "; args
    loadContent()
    m.rowList.visible = true
    m.rowList.setFocus(true)
    print "MainMenuView: RowList set to visible and focused in show"
End Sub

Sub loadContent()
    print "MainMenuView: Loading content"
    content = createObject("roSGNode", "ContentNode")
    
    ' Live Radio 1 Row
    radioRow1 = content.createChild("ContentNode")
    radioRow1.title = "Live Radio 1"
    addStation(radioRow1, "101.9 The Bull", "https://stream.radio.com/bull", "pkg:/images/bull.png")
    addStation(radioRow1, "K-Hits 107.5", "https://stream.radio.com/khits", "pkg:/images/khits.png")
    
    ' Live Radio 2 Row
    radioRow2 = content.createChild("ContentNode")
    radioRow2.title = "Live Radio 2"
    addStation(radioRow2, "Mix 106", "https://stream.radio.com/mix106", "pkg:/images/mix106.png")
    addStation(radioRow2, "Power 105.5", "https://stream.radio.com/power1055", "pkg:/images/power1055.png")
    
    ' Podcasts Row
    podcastRow = content.createChild("ContentNode")
    podcastRow.title = "Podcasts"
    addPodcast(podcastRow, "Rick & Carly On Demand", "https://rss.feed.com/rickcarly", "pkg:/images/rick_carly.jpg")
    
    m.top.content = content
    print "MainMenuView: Content loaded, set to RowList"
End Sub

Sub addStation(row, title, url, poster)
    item = row.createChild("ContentNode")
    item.title = title
    item.streamUrl = url
    item.HDPosterUrl = getValidImage(poster, "pkg:/images/placeholder.png")
    item.addField("type", "string", false)
    item.type = "radio"
    print "MainMenuView: Adding station - "; title
End Sub

Sub addPodcast(row, title, url, poster)
    item = row.createChild("ContentNode")
    item.title = title
    item.feedUrl = url
    item.HDPosterUrl = getValidImage(poster, "pkg:/images/placeholder.png")
    item.addField("type", "string", false)
    item.type = "podcast"
    print "MainMenuView: Adding podcast - "; title
End Sub

Function getValidImage(poster, fallback)
    if poster <> invalid and poster <> ""
        return poster
    end if
    return fallback
End Function

Sub onContentSet()
    print "MainMenuView: Content set on top.content"
    m.rowList.content = m.top.content
    m.rowList.setFocus(true)
End Sub

Sub onItemSelected()
    print "MainMenuView: Item selected"
    selectedIndex = m.rowList.rowItemSelected
    rowIndex = selectedIndex[0]
    itemIndex = selectedIndex[1]
    selectedItem = m.rowList.content.getChild(rowIndex).getChild(itemIndex)
    
    if selectedItem <> invalid
        print "MainMenuView: Selected - "; selectedItem.title
        m.top.selection = selectedItem
        if selectedItem.type = "radio"
            m.componentController.callFunc("showView", { view: "RadioPlaybackView", args: { content: selectedItem } })
        else if selectedItem.type = "podcast"
            m.componentController.callFunc("showView", { view: "PodcastLandingView", args: { content: selectedItem } })
        end if
    end if
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    print "MainMenuView: Key event - "; key; " Press: "; press
    if press and key = "back"
        return false
    end if
    return true
End Function