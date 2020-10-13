# AFK System
These commands are not standalone. AFK and MentionListener are needed for this system to work. LeaveFeed is an optional template that goes in the leave feed. These CCs allow you to create an AFK message with a duration for when you are away from your keyboard.

# Functionality
- Set AFK with an optional duration
- Notify users who have mentioned someone AFK with message and ETA if they have set it

# Description
## AFK.cc.lua
### This command allows users to set an AFK message with optional duration.
   
   > **Usage:**
   >> -afk \<message>   
   >> -afk \<message> -d \<duration>
   
   > **Trigger**: Command trigger with trigger `afk`

## MentionListener.cc.lua
### This command manages mentioning of users who are AFK.

   > **Trigger**: Regex trigger with trigger `<@!?\d+>`

## LeaveFeed.cc.lua
### This code is supposed to be put in the leave feed. It removes the AFK messages of users who have left the server. It is optional, meaning that the other CCs in this system will work fine without it.
