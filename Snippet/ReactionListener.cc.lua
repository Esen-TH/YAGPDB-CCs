{{/* Initialize Some Variables */}}
{{$PageNo := 0}}
{{$PageData := 0}}
{{$embed := ""}}
{{$MsgID := 0}}
 
{{/*Check if command is triggered by reaction or execCC and accordingly initialize variables*/}}
{{if .ExecData}}
     {{$PageData = .ExecData.Category}}
     {{$MsgID = .ExecData.ID}}
 {{else}}
     {{if .ReactionMessage.Embeds}}
          {{$embed = (index .ReactionMessage.Embeds 0)}}
          {{if and ($embed.Author) (ne .Reaction.UserID 204255221017214977) ($embed.Footer) }}
          {{if and ($embed.Author.Name) ($embed.Footer.Text) }}
          {{if (reFind "^(Page)" $embed.Footer.Text) }}
               {{$PageData = (dbGet 1234 (index (split $embed.Author.Name " ") 0 ) ).Value}}
               {{$PageNo = toInt (index (split $embed.Footer.Text " ") 1) }}
               {{$MsgID = .ReactionMessage.ID}}
          {{end}}
          {{end}}
          {{end}}
     {{end}}
{{end}}
 
{{/* if conditions are met for command to execute according to previously initialized variables , execute command depending on first run or Reaction (add/remove) Type */}}
{{if $PageData}}
{{$len := len $PageData}}
{{/* Code for displaying page 1 for first run */}}
{{if eq $PageNo 0}}
     {{addMessageReactions nil $MsgID "◀" "▶"}}
     {{editMessageNoEscape nil $MsgID (cembed (index $PageData "1") ) }}
{{/* Code to navigate through pages depending on reaction emoji type(name) */}}
{{else if and ( eq .Reaction.Emoji.Name "▶") (lt $PageNo $len) }}
     {{editMessageNoEscape nil $MsgID (cembed (index $PageData (toString (add $PageNo 1) ) ) ) }}
{{else if and ( eq .Reaction.Emoji.Name "◀") (gt $PageNo 1) }}
     {{editMessageNoEscape nil $MsgID (cembed (index $PageData (toString (add $PageNo -1) ) ) ) }}
{{end}}
{{end}}
 
 
 
{{/* SNIP MOBILE REACTION */}}
 
{{if .Reaction}}
{{if eq .ReactionAdded true}}
{{if eq .Reaction.Emoji.Name "📱"}}
{{if .ReactionMessage.Embeds}}
{{$embed = (index .ReactionMessage.Embeds 0)}}
{{if $embed.Footer}}
{{if $embed.Footer.Text}}
{{if (reFind "📱" $embed.Footer.Text)}}
{{if and $embed.Title $embed.Description}}
{{deleteAllMessageReactions nil .Reaction.MessageID}}{{addReactions "📱"}}
{{sendDM (joinStr "" "\n\n**" $embed.Title "**\n" $embed.Description)}}
{{else if  $embed.Title}}
{{sendDM (joinStr "" "\n\n**" $embed.Title "**")}}
{{else if $embed.Description}}
{{sendDM (joinStr "" "\n\n" $embed.Description)}}
{{end}}{{end}}{{end}}{{end}}{{end}}{{end}}{{end}}{{end}}
 
 
 
{{/* EMBED DELETE REACTION */}}
 
{{if .Reaction}}
{{if eq .Reaction.Emoji.Name "🗑"}}
{{if .ReactionMessage.Embeds}}
{{$embed = (index .ReactionMessage.Embeds 0)}}
{{if $embed.Footer}}
{{if $embed.Footer.Text}}
{{if (reFind "🗑" $embed.Footer.Text)}}
{{deleteAllMessageReactions nil .ReactionMessage.ID}}
{{deleteMessage nil .ReactionMessage.ID 1}}
{{end}}{{end}}{{end}}{{end}}{{end}}{{end}}
 
 
 
{{/* SNIP PAGINATION */}}
 
{{if .Reaction}}
{{if .ReactionMessage.Embeds}}
{{$embed = index .ReactionMessage.Embeds 0}}
{{if $embed.Footer}}
{{if $embed.Footer.Text}}
{{if reFind "Page: " $embed.Footer.Text}}
{{$PageNo = toInt (index (split $embed.Footer.Text "Page: ") 1)}}
{{$PageData = ""}}
{{$MsgID = .ReactionMessage.ID}}
{{if eq .Reaction.Emoji.Name "▶️"}}
{{range dbTopEntries "snippet_%" 10 (mult (add $PageNo 1) 10)}}
{{$PageData = joinStr "" $PageData "\n`" (slice .Key 8) "`"}}
{{end}}
{{if $PageData}}
{{editMessage nil $MsgID (cembed "title" "Snippet List:" "description" (joinStr "" $PageData "\n") "footer" (sdict "text" (joinStr "" "React with 🗑️ to delete this message.\nPage: " (add $PageNo 1))))}}
{{end}}
{{end}}
{{if and (eq .Reaction.Emoji.Name "◀️") (gt $PageNo 0)}}
{{range dbTopEntries "snippet_%" 10 (sub (mult $PageNo 10) 10)}}
{{$PageData = joinStr "" $PageData "\n`" (slice .Key 8) "`"}}
{{end}}
{{editMessage nil $MsgID (cembed "title" "Snippet List:" "description" (joinStr "" $PageData "\n") "footer" (sdict "text" (joinStr "" "React with 🗑️ to delete this message.\nPage: " (sub $PageNo 1))))}}
{{end}}
{{end}}
{{end}}
{{end}}
{{end}}
{{end}}
