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
                ' Adjust parsing based on actual XML structure
                if xml.nowPlaying <> invalid
                    metadata.artist = xml.nowPlaying.artist.GetText()
                    metadata.song = xml.nowPlaying.song.GetText()
                    metadata.album = xml.nowPlaying.album.GetText()
                end if
                m.top.metadata = metadata
            end if
        end if
        sleep(5000) ' Fetch every 5 seconds
    end while
end sub