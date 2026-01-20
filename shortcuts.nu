#!/usr/bin/env nu

let shortcuts = [
  {
    "name": "Slack",
    "icon": "icon://omnicast/globe?fill=primary-text",
    "url": "https://app.slack.com/client/T069GEHD6AC/C09JKJ3HL4X",
    "app": "firefox.desktop"
  },
  {
    "name": "Home Assistant",
    "icon": "icon://omnicast/house?fill=primary-text",
    "url": "https://home.knoopx.net/lovelace",
    "app": "firefox.desktop"
  },
  {
    "name": "Android Phone",
    "icon": "icon://omnicast/tablet",
    "url": "",
    "app": "scrcpy.desktop"
  },
  {
    "name": "Gmail - Personal",
    "icon": "icon://omnicast/gmail",
    "url": "https://mail.google.com/mail/u/0/",
    "app": "firefox.desktop"
  },
  {
    "name": "Gmail - Work",
    "icon": "icon://omnicast/gmail",
    "url": "https://mail.google.com/mail/u/1/",
    "app": "firefox.desktop"
  },
  {
    "name": "Calendar - Work",
    "icon": "icon://omnicast/gmail",
    "url": "https://calendar.google.com/calendar/u/1/",
    "app": "firefox.desktop"
  },
  {
    "name": "Telegram",
    "icon": "icon://omnicast/telegram",
    "url": "https://web.telegram.org/k/",
    "app": "firefox.desktop"
  },
  {
    "name": "Discord",
    "icon": "icon://omnicast/discord",
    "url": "https://discord.com/channels/",
    "app": "firefox.desktop"
  },
  {
    "name": "Youtube",
    "icon": "icon://omnicast/youtube",
    "url": "https://www.youtube.com/",
    "app": "firefox.desktop"
  },
  {
    "name": "Reddit",
    "icon": "icon://omnicast/reddit",
    "url": "https://www.reddit.com/",
    "app": "firefox.desktop"
  },
  {
    "name": "WhatsApp",
    "icon": "icon://omnicast/whatsapp",
    "url": "https://web.whatsapp.com/",
    "app": "firefox.desktop"
  },
  {
    "name": "Spotify",
    "icon": "icon://omnicast/spotify",
    "url": "https://open.spotify.com/",
    "app": "firefox.desktop"
  },
  {
    "name": "Plex Web",
    "icon": "icon://omnicast/plex",
    "url": "https://app.plex.tv/desktop/",
    "app": "webkit.desktop"
  },
  {
    "name": "Webull",
    "icon": "icon://omnicast/webull",
    "url": "https://app.webull.com/stocks",
    "app": "firefox.desktop"
  },
  {
    "name": "Wiki",
    "icon": "icon://omnicast/wiki",
    "url": "https://wiki.knoopx.net/",
    "app": "webkit.desktop"
  }
]

systemctl stop --user vicinae.service

let vicinaedb = (realpath ~/.local/share/vicinae/vicinae.db)
sqlite3 $vicinaedb "DELETE FROM shortcut;"
echo $shortcuts | each {
   $in | merge ({id: (random uuid), created_at: (date now), updated_at: (date now) })  | into sqlite $vicinaedb -t shortcut
}
systemctl start --user vicinae.service
