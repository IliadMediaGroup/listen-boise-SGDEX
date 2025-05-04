Sub init()
    print "MainMenuView: Entering init"
    
    m.rowList = m.top.findNode("RowList")
    if m.rowList = invalid
        print "MainMenuView: ERROR - RowList node not found"
        return
    end if
    m.rowList.visible = true
    print "MainMenuView: RowList visibility set to true"
    
    m.componentController = m.top.findNode("componentController")
    if m.componentController = invalid
        ' Try to find ComponentController in parent scene
        m.componentController = m.top.getScene().findNode("componentController")
        if m.componentController = invalid
            print "MainMenuView: ERROR - ComponentController not found"
        end if
    end if
    
    configureGrid()
    m.rowList.observeField("rowItemSelected", "onItemSelected")
    m.rowList.setFocus(true)
    print "MainMenuView: Focus set to RowList"
End Sub

Sub show(args as Object)
    print "MainMenuView: Showing view with args: " + FormatJson(args)
    
    if m.rowList = invalid
        print "MainMenuView: ERROR - RowList is invalid in show"
        m.rowList = m.top.findNode("RowList")
        if m.rowList = invalid
            print "MainMenuView: ERROR - Failed to find RowList node"
            return
        end if
    end if
    
    loadContent()
    m.rowList.visible = true
    m.rowList.setFocus(true)
    print "MainMenuView: RowList set to visible and focused in show"
End Sub

Sub configureGrid()
    print "MainMenuView: Configuring grid"
    
    m.top.callFunc("sgdex_setStyle", "standard")
    m.rowList.numColumns = 4
    m.rowList.itemSize = [300, 200]
    m.rowList.rowHeights = [200, 200, 450]
    m.rowList.itemSpacing = [20, 20]
    m.rowList.rowSpacings = [20]
    m.rowList.numRows = 3
    m.rowList.visible = true
    print "MainMenuView: Grid configured"
End Sub

Sub loadContent()
    print "MainMenuView: Loading content"
    
    content = createObject("roSGNode", "ContentNode")
    
    ' Station Row 1
    stationRow1 = content.createChild("ContentNode")
    stationRow1.title = "Live Radio 1"
    addStation(stationRow1, "101.9 The Bull", getValidImage("bull.png"), "https://ice64.securenetsystems.net/KQBL", "station", "https://streamdb6web.securenetsystems.net/player_status_update/KQBL_history.txt")
    addStation(stationRow1, "My 102.7", getValidImage("my.png"), "https://ice9.securenetsystems.net/KZMG", "station", "https://streamdb6web.securenetsystems.net/player_status_update/KZMG_history.txt")
    addStation(stationRow1, "Bob FM 96.1", getValidImage("bob.png"), "https://ice64.securenetsystems.net/KSRV", "station", "https://streamdb6web.securenetsystems.net/player_status_update/KSRV_history.txt")
    addStation(stationRow1, "Wild 101.1", getValidImage("wild.png"), "https://ice9.securenetsystems.net/KWYD", "station", "https://streamdb6web.securenetsystems.net/player_status_update/KWYD_history.txt")
    
    ' Station Row 2
    stationRow2 = content.createChild("ContentNode")
    stationRow2.title = "Live Radio 2"
    addStation(stationRow2, "IRock 99.1 FM", getValidImage("irock.png"), "https://ice64.securenetsystems.net/KQBLHD2", "station", "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2_history.txt")
    addStation(stationRow2, "Fox Sports 99.9", getValidImage("fox.png"), "https://ice64.securenetsystems.net/KSRVHD2", "station", "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2_history.txt")
    addStation(stationRow2, "101.5 Kool FM", getValidImage("kool.png"), "https://ice5.securenetsystems.net/KKOO", "station", "https://streamdb6web.securenetsystems.net/player_status_update/KKOO_history.txt")
    addStation(stationRow2, "96.5 The Alternative", getValidImage("alt.png"), "https://ice9.securenetsystems.net/KQBLHD3", "station", "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3_history.txt")
    
    ' Podcast Row
    podcastRow = content.createChild("ContentNode")
    podcastRow.title = "Podcasts"
    addPodcast(podcastRow, "Rick & Carly On Demand", getValidImage("rick_carly.jpg"), "https://feeds.acast.com/public/shows/674e35774cf32e7b944eccd3", "podcast")
    addPodcast(podcastRow, "Joey & Lauren On Demand", getValidImage("joey_lauren.png"), "https://feeds.acast.com/public/shows/6750bbfe0ee2b79e33134fad", "podcast")
    addPodcast(podcastRow, "Hey Morton On Demand", getValidImage("hey_morton.png"), "https://feeds.acast.com/public/shows/675237266af55bd515d4d2d7", "podcast")
    addPodcast(podcastRow, "The Diabetes Oasis", getValidImage("diabetes_oasis.png"), "https://feeds.acast.com/public/shows/675236792dd88df1321d6b28", "podcast")
    addPodcast(podcastRow, "Up Next", getValidImage("up_next.jpg"), "https://feeds.acast.com/public/shows/675237e3d40c6cb2e0112347", "podcast")
    addPodcast(podcastRow, "The Marketing Expedition", getValidImage("marketing_expedition.jpg"), "https://static.adorilabs.com/feed/marketing-expedition-podcast-with-rhea-allen-peppershock-media-7682.xml", "podcast")
    addPodcast(podcastRow, "Brain Over Belly", getValidImage("brain_over_belly.jpg"), "https://feeds.acast.com/public/shows/6750f308f318f34867692de2", "podcast")
    addPodcast(podcastRow, "BoiseDev Podcast", getValidImage("boisedev.jpg"), "https://feeds.acast.com/public/shows/6750d305aeaa2d78dfb137bf", "podcast")
    
    m.top.content = content
    m.rowList.content = content
    print "MainMenuView: Content loaded, set to RowList"
End Sub

Function getValidImage(imageName as String) as String
    fileSystem = createObject("roFileSystem")
    basePath = "pkg:/images/"
    
    fullPath = basePath + imageName
    if fileSystem.exists(fullPath)
        print "MainMenuView: Image found - " + fullPath
        return fullPath
    end if
    
    altExtension = ifElse(imageName.endsWith(".png"), ".jpg", ".png")
    altImageName = left(imageName, len(imageName) - 4) + altExtension
    altFullPath = basePath + altImageName
    if fileSystem.exists(altFullPath)
        print "MainMenuView: Alternate image found - " + altFullPath
        return altFullPath
    end if
    
    print "MainMenuView: Image missing, using fallback - " + imageName
    return "pkg:/images/splash_screen_hd.png"
End Function

Sub addStation(row as Object, title as String, poster as String, streamUrl as String, contentType as String, metadataUrl as String)
    print "MainMenuView: Adding station - " + title
    item = row.createChild("ContentNode")
    item.title = title
    item.HDPosterUrl = poster
    item.url = streamUrl
    item.metadataUrl = metadataUrl
    item.contentType = contentType
End Sub

Sub addPodcast(row as Object, title as String, poster as String, rssUrl as String, contentType as String)
    print "MainMenuView: Adding podcast - " + title
    item = row.createChild("ContentNode")
    item.title = title
    item.HDPosterUrl = poster
    item.rssUrl = rssUrl
    item.contentType = contentType
End Sub

Sub onContentSet()
    print "MainMenuView: Content set"
    if m.rowList <> invalid
        m.rowList.content = m.top.content
        m.rowList.visible = true
        print "MainMenuView: RowList content updated and visible"
    else
        print "MainMenuView: ERROR - RowList invalid"
    end if
End Sub

Sub onItemSelected()
    print "MainMenuView: Item selected"
    if m.rowList = invalid or m.rowList.content = invalid
        print "MainMenuView: ERROR - Invalid RowList or content"
        return
    end if
    
    selectedRow = m.rowList.rowItemSelected[0]
    selectedCol = m.rowList.rowItemSelected[1]
    selectedItem = m.rowList.content.getChild(selectedRow).getChild(selectedCol)
    
    if selectedItem <> invalid
        print "MainMenuView: Selected - " + selectedItem.title
        if m.componentController <> invalid
            if selectedItem.contentType = "station"
                m.componentController.callFunc("showView", { view: "RadioPlaybackView", args: { content: selectedItem } })
            else if selectedItem.contentType = "podcast"
                m.componentController.callFunc("showView", { view: "PodcastLandingView", args: { content: selectedItem } })
            end if
        else
            print "MainMenuView: ERROR - ComponentController invalid"
        end if
        m.top.selection = selectedItem
    else
        print "MainMenuView: ERROR - Invalid selection"
    end if
End Sub

Function onKeyEvent(key as String, press as Boolean) as Boolean
    print "MainMenuView: Key event - " + key + ", press: " + press.toStr()
    return false
End Function

Function ifElse(condition as Boolean, trueValue as Dynamic, falseValue as Dynamic) as Dynamic
    if condition then return trueValue
    return falseValue
End Function