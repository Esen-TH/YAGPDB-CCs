{{$staff := "Administrator"}}{{$list := ""}}{{$pageNo := 0}}
{{$args := parseArgs 0 "" (carg "string" "snipname") (carg "string" "") (carg "string" "") (carg "string" "")}}
 
 
{{if $args.IsSet 0}}
{{if and (eq ($args.Get 0) "admin") (hasRoleName $staff)}}
{{if not ($args.IsSet 1)}}
{{deleteResponse 3}}{{deleteTrigger 3}} `;admin "name" "image" "text"` Leave image as `""` for none leave text and image blank to delete
{{else if $args.IsSet 3}}
{{dbSet 0 (joinStr "" "snippet_" (lower ($args.Get 1))) (sdict "value" ($args.Get 3) "image" ($args.Get 2))}}Added/Edited
{{else}}
{{dbDel 0 (joinStr "" "snippet_" (lower ($args.Get 1)))}}Deleted
{{end}}
 
 
{{else if eq ($args.Get 0) "list"}}{{range dbTopEntries "snippet_%" 10 0}}{{$list = joinStr "" $list "\n`" (slice .Key 8) "`"}}
{{end}}
{{$msg := sendMessageRetID nil (cembed "title" "Snippet List:" "description" $list "footer" (sdict "text" (joinStr "" "React with 🗑️ to delete this message.\nPage: " $pageNo)))}}
{{if $msg}}
{{addMessageReactions nil $msg "◀️" "▶️" "🗑"}}{{end}}
 
 
{{else if and (eq ($args.Get 0) "search") ($args.IsSet 1)}}{{range dbTopEntries (joinStr "" "snippet_%" (lower ($args.Get 1)) "%") 100 0}}{{$list = joinStr "" $list " " (slice .Key 8)}}{{end}}
{{$r := reFindAll (joinStr `` `(?i)(\b|\S*\/)` (reReplace "[^\\w]" ($args.Get 1) "") `(/\S*|\S*)`) $list}}
{{$list = ""}}
{{range $r}}{{$list = joinStr "" $list "\n`" . "`"}}{{end}}
{{$msg := sendMessageRetID nil (cembed "title" "Search Results:" "description" $list "footer" (sdict "text" "React with 🗑️ to delete this message."))}}
{{if $msg}}
{{addMessageReactions nil $msg "🗑"}}{{end}}
 
 
{{else}}{{range dbTopEntries (joinStr "" "snippet_%" (lower ($args.Get 0)) "%") 100 0}}{{$list = joinStr "" $list " " (slice .Key 8)}}{{end}}
{{$r := reFind (joinStr `` `(?i)(\b|\S*\/)` (reReplace "[^\\w/]" ($args.Get 0) "") `(/\S*|\b|$)`) $list}}
{{if $r}}{{$snip := dbGet 0 (joinStr "" "snippet_" $r)}}
{{$msg := sendMessageRetID nil (cembed "description" (index $snip.Value "value") "image" (sdict "url" (index $snip.Value "image")) "title" (joinStr "" "Snippet: " (title (slice $snip.Key 8))) "footer" (sdict "text" "React with 📱 to be DMed a mobile version."))}}
{{if $msg}}
{{addMessageReactions nil $msg "📱"}}{{end}}
{{end}}{{end}}{{end}}
