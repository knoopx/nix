{
  pkgs,
  colorScheme,
  ...
}:
pkgs.writeTextFile {
  name = "telegram.userstyle.css";
  text = with colorScheme; ''
    @-moz-document domain("web.telegram.org") {
      .page-chats {
        max-width: none;
      }
      .chat-background canvas {
        display: none;
      }

      :root {
        --surface-color: #${base00};
        --primary-color: #${base02};
        --secondary-color: #${base05};
        --primary-text-color: #${base05};
        --badge-text-color: #${base00};
        --secondary-text-color: #${base04};
      }

      .row:hover {
        --light-filled-secondary-text-color: #${base04};
        --secondary-text-color: #${base02};
      }

      .new-message-wrapper {
        --surface-color: #${base00};
      }

      .bubble {
        --message-background-color: #${base00};
      }

      .chat-input .btn-send {
        --primary-color: #${base07};
        color: #${base02};
      }

      .chat-background .is-pattern {
        background-color: #${base01};
      }

      #column-left {
        background-color: #${base00};
      }

      .topbar {
        background-color: #${base00};
      }
    }
  '';
}
