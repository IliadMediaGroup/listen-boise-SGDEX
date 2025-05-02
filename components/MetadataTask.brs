sub init()
    m.top.functionName = "fetchMetadata"
end sub

sub fetchMetadata()
    while true
        if m.top.jsonUrl <> ""
            http = CreateObject("roUrlTransfer")
            http.SetUrl(m.top.jsonUrl)
            http.SetCertificatesFile("common:/certs/ca-bundle.crt")
            http.InitClientCertificates()
            response = http.GetToString()
            
            if response = invalid
                m.top.metadata = {artist: "Network Error", song: "Unknown", album: "Unknown", albumArt: ""}
            else
                json = ParseJson(response)
                if json <> invalid and json.playHistory <> invalid and json.playHistory.song <> invalid
                    metadata = {}
                    ' Find the most recent non-promo song
                    for each song in json.playHistory.song
                        if song.artist <> invalid and song.artist <> "99.1 IRock" and song.artist <> "101.9 The Bull" and song.artist <> "My 102.7" and song.artist <> "Bob FM 96.1" and song.artist <> "Wild 101.1" and song.artist <> "Fox Sports 99.9" and song.artist <> "101.5 Kool FM" and song.artist <> "96.5 The Alternative"
                            metadata.artist = song.artist
                            metadata.song = song.title
                            metadata.album = song.album
                            metadata.albumArt = song.cover
                            exit for
                        end if
                    end for
                    
                    ' Set defaults if metadata is incomplete
                    if metadata.artist = invalid or metadata.artist = "" then metadata.artist = "Unknown Artist"
                    if metadata.song = invalid or metadata.song = "" then metadata.song = "Unknown Song"
                    if metadata.album = invalid or metadata.album = "" then metadata.album = "Unknown Album"
                    if metadata.albumArt = invalid or metadata.albumArt = "" then metadata.albumArt = ""
                    
                    m.top.metadata = metadata
                else
                    m.top.metadata = {artist: "Unknown", song: "Unknown", album: "Unknown", albumArt: ""}
                end if
            end if
        end if
        sleep(5000)
    end while
end sub