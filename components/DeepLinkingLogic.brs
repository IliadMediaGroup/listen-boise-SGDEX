function IsDeepLinking(args as Object) as Boolean
    print "DeepLinkingLogic: Checking deep linking args: "; args
    return args <> invalid and args.mediaType <> invalid and args.mediaType <> "" and args.contentId <> invalid and args.contentId <> ""
end function

sub PerformDeepLinking(args as Object)
    print "DeepLinkingLogic: Performing deep linking with args: "; args
    if not IsDeepLinking(args)
        print "DeepLinkingLogic: Invalid deep linking args"
        return
    end if

    ' Example: Navigate to RadioPlaybackView or PodcastPlaybackView based on mediaType
    content = CreateObject("roSGNode", "ContentNode")
    if args.mediaType = "radio"
        content.title = "Deep Linked Radio"
        content.streamUrl = args.contentId ' Assume contentId is a stream URL
        content.type = "radio"
        view = CreateObject("roSGNode", "RadioPlaybackView")
        view.content = content
    else if args.mediaType = "podcast"
        content.title = "Deep Linked Podcast"
        content.url = args.contentId ' Assume contentId is a podcast URL
        content.type = "podcast"
        view = CreateObject("roSGNode", "PodcastPlaybackView")
        view.content = content
    else
        print "DeepLinkingLogic: Unsupported mediaType: "; args.mediaType
        return
    end if

    m.top.ComponentController.callFunc("show", {
        view: view
    })
    print "DeepLinkingLogic: Deep linking view shown"
end sub