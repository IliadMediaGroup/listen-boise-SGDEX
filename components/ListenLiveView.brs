sub init()
    m.grid = m.top.findNode("stationGrid")
    m.grid.observeField("itemSelected", "onGridItemSelected")
    m.metadataTask = CreateObject("roSGNode", "MetadataTask")
    m.metadataTask.observeField("metadata", "onMetadataUpdate")
    loadStations()
end sub

sub loadStations()
    content = CreateObject("roSGNode", "ContentNode")
    stations = [
        {url: "https://ice64.securenetsystems.net/KQBL", name: "101.9 The Bull", format: "aac", title: "101.9 The Bull", poster: "pkg:/images/bull.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBL_history.txt"},
        {url: "https://ice9.securenetsystems.net/KZMG", name: "My 102.7", format: "aac", title: "My 102.7", poster: "pkg:/images/my.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KZMG_history.txt"},
        {url: "https://ice64.securenetsystems.net/KSRV", name: "Bob FM 96.1", format: "aac", title: "Bob FM 96.1", poster: "pkg:/images/bob.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KSRV_history.txt"},
        {url: "https://ice9.securenetsystems.net/KWYD", name: "Wild 101.1", format: "aac", title: "Wild 101.1", poster: "pkg:/images/wild.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KWYD_history.txt"},
        {url: "https://ice64.securenetsystems.net/KQBLHD2", name: "IRock 99.1 FM", format: "aac", title: "IRock 99.1 FM", poster: "pkg:/images/irock.png", jsonUrl: "https://streamdb9web.securenetsystems.net/player_status_update/KQBLHD2_history.txt"},
        {url: "https://ice64.securenetsystems.net/KSRVHD2", name: "Fox Sports 99.9", format: "aac", title: "Fox Sports 99.9", poster: "pkg:/images/fox.png", jsonUrl: "https://streamdb8web.securenetsystems.net/player_status_update/KSRVHD2_history.txt"},
        {url: "https://ice5.securenetsystems.net/KKOO", name: "101.5 Kool FM", format: "aac", title: "101.5 Kool FM", poster: "pkg:/images/kool.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KKOO_history.txt"},
        {url: "https://ice9.securenetsystems.net/KQBLHD3", name: "96.5 The Alternative", format: "aac", title: "96.5 The Alternative", poster: "pkg:/images/alt.png", jsonUrl: "https://streamdb6web.securenetsystems.net/player_status_update/KQBLHD3_history.txt"}
    ]
    
    for each station in stations
        item = content.CreateChild("ContentNode")
        item.title = station.title
        item.HDPosterUrl = station.poster
        item.addFields({stationUrl: station.url, format: station.format, jsonUrl: station.jsonUrl})
    end for
    
    m.grid.content = content
end sub

sub onGridItemSelected()
    selectedIndex = m.grid.itemSelected
    item = m.grid.content.getChild(selectedIndex)
    
    ' Set up video node content
    content = CreateObject("roSGNode", "ContentNode")
    content.url = item.stationUrl
    content.streamFormat = item.format
    content.addFields({jsonUrl: item.jsonUrl, isVideo: false})
    
    ' Play stream
    m.top.getScene().findNode("globalVideo").content = content
    m.top.getScene().findNode("globalVideo").control = "play"
    
    ' Start metadata task
    m.metadataTask.jsonUrl = item.jsonUrl
    m.metadataTask.control = "RUN"
    
    ' Show playback card
    playbackCard = m.top.getScene().findNode("playbackCard")
    playbackCard.visible = true
    nowPlayingLabel = m.top.getScene().findNode("nowPlayingLabel")
    nowPlayingLabel.text = "Now Playing: " + item.title
    controlButton = m.top.getScene().findNode("stopButton")
    controlButton.text = "Stop"
end sub

sub onMetadataUpdate()
    metadata = m.metadataTask.metadata
    if metadata <> invalid
        nowPlayingLabel = m.top.getScene().findNode("nowPlayingLabel")
        nowPlayingLabel.text = "Now Playing: " + metadata.artist + " - " + metadata.song
    end if
end sub