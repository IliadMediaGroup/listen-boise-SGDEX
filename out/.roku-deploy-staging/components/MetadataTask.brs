sub init()
    m.top.functionName = "fetchMetadata"
end sub

sub fetchMetadata()
    while true
        if m.top.xmlUrl <> ""
            http = CreateObject("roUrlTransfer")
            http.SetUrl(m.top.xmlUrl)
            http.SetCertificatesFile("common:/certs/ca-bundle.crt")
            http.InitClientCertificates()
            response = http.GetToString()
            
            xml = CreateObject("roXMLElement")
            if xml.Parse(response)
                metadata = {}
                nowPlaying = xml.GetNamedElements("nowplaying")
                if nowPlaying.Count() > 0
                    metadata.artist = nowPlaying[0].GetNamedElements("artist").GetText()
                    metadata.song = nowPlaying[0].GetNamedElements("song").GetText()
                    metadata.album = nowPlaying[0].GetNamedElements("album").GetText()
                    metadata.albumArt = nowPlaying[0].GetNamedElements("albumart").GetText()
                else
                    metadata.artist = xml.GetChildElements().GetNamedElements("artist").GetText()
                    metadata.song = xml.GetChildElements().GetNamedElements("title").GetText()
                    metadata.album = xml.GetChildElements().GetNamedElements("album").GetText()
                    metadata.albumArt = xml.GetChildElements().GetNamedElements("image").GetText()
                end if
                if metadata.artist = "" then metadata.artist = "Unknown Artist"
                if metadata.song = "" then metadata.song = "Unknown Song"
                if metadata.album = "" then metadata.album = "Unknown Album"
                if metadata.albumArt = "" then metadata.albumArt = ""
                m.top.metadata = metadata
            else
                m.top.metadata = {artist: "Unknown", song: "Unknown", album: "Unknown", albumArt: ""}
            end if
        end if
        sleep(5000)
    end while
end sub