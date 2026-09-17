/*
 * References:
 * - Config: https://github.com/artemsen/swayimg/blob/master/CONFIG.md
 * - API: https://github.com/artemsen/swayimg/blob/master/extra/swayimg.lua
 */
{ config
, nixosConfig
, ...
}:
let
  p = nixosConfig.defaults.colorScheme.palette;
in
{
  xdg.configFile."swayimg/init.lua".text = ''
    swayimg.mode = "viewer"
    swayimg.antialiasing = true
    swayimg.decoration = true
    swayimg.overlay = false
    swayimg.exif_orientation = true
    swayimg.dnd_button = "MouseRight"

    swayimg.set_format_params('raw', { camera_wb = true })

    swayimg.imagelist.order = "numeric"
    swayimg.imagelist.reverse = true
    swayimg.imagelist.recursive = true
    swayimg.imagelist.adjacent = true
    swayimg.imagelist.fsmon = true

    swayimg.text.font = "monospace"
    swayimg.text.size = 13
    swayimg.text.spacing = 0
    swayimg.text.padding = 4
    swayimg.text.color = 0xff${p.base05}
    swayimg.text.background = 0x00000000
    swayimg.text.shadow = 0x0d${p.base00}
    swayimg.text.timeout = 5
    swayimg.text.status_timeout = 3

    swayimg.viewer.default_scale = "optimal"
    swayimg.viewer.default_position = "center"
    swayimg.viewer.drag_button = "MouseLeft"
    swayimg.viewer.set_window_background(0xff${p.base00})
    swayimg.viewer.set_image_chessboard(20, 0xff${p.base00}, 0xff${p.base01})
    swayimg.viewer.autocenter = true
    swayimg.viewer.loop = true
    swayimg.viewer.preload = 1
    swayimg.viewer.history = 1
    swayimg.viewer.mark_color = 0xff${p.base0D}
    swayimg.viewer.pinch_factor = 1.0

    swayimg.slideshow.timeout = 5
    swayimg.slideshow.default_scale = "fit"
    swayimg.slideshow.set_window_background("auto")
    swayimg.slideshow.history = 0
    swayimg.slideshow.set_text("topleft", { "{name}" })

    swayimg.gallery.aspect = "fill"
    swayimg.gallery.thumb_size = 380
    swayimg.gallery.padding_size = 5
    swayimg.gallery.border_size = 5
    swayimg.gallery.border_color = 0xff${p.base0D}
    swayimg.gallery.selected_scale = 1.15
    swayimg.gallery.selected_color = 0xff${p.base02}
    swayimg.gallery.unselected_color = 0xff${p.base01}
    swayimg.gallery.window_color = 0xff${p.base00}
    swayimg.gallery.pinch_factor = 100.0
    swayimg.gallery.hover = true
    swayimg.gallery.cache = 100
    swayimg.gallery.embedded_thumb = true
    swayimg.gallery.preload = false
    swayimg.gallery.pstore = false

    swayimg.viewer.set_text("topleft", {
      "File: {name}",
      "Format: {format}",
      "File size: {sizehr}",
      "File time: {time}",
      "EXIF date: {meta.Exif.Photo.DateTimeOriginal}",
      "EXIF camera: {meta.Exif.Image.Model}"
    })

    swayimg.viewer.set_text("topright", {
      "Image: {list.index} of {list.total}",
      "Frame: {frame.index} of {frame.total}",
      "Size: {frame.width}x{frame.height}"
    })

    swayimg.viewer.set_text("bottomleft", {
      "Scale: {scale}"
    })

    swayimg.viewer.on_key("R", function()
      local image = swayimg.viewer.get_image()
      os.execute("magick " .. image.path .. " -rotate 90 " .. image.path)
    end)

    swayimg.viewer.on_key("Shift+R", function()
      local image = swayimg.viewer.get_image()
      os.execute("magick " .. image.path .. " -rotate -90 " .. image.path)
    end)

    swayimg.viewer.on_key("Left", function()
      local wnd = swayimg.get_window_size()
      local pos = swayimg.viewer.get_position()
      swayimg.viewer.set_abs_position(math.floor(pos.x + wnd.width / 10), pos.y);
    end)

    swayimg.viewer.on_mouse("Ctrl-ScrollUp", function()
      local pos = swayimg.get_mouse_pos()
      local scale = swayimg.viewer.get_scale()
      scale = scale + scale / 10
      swayimg.viewer.set_abs_scale(scale, pos.x, pos.y);
    end)


    swayimg.gallery.set_text("topleft", {
      "File: {name}"
    })
    swayimg.gallery.set_text("topright", {
      "{list.index} of {list.total}"
    })

    swayimg.gallery.on_key("Return", function()
      swayimg.mode = "viewer"
    end)

    swayimg.gallery.on_key("o", function()
      local image = swayimg.gallery.get_image()
      os.execute("xdg-open " .. image.path .. " &")
    end)

    swayimg.gallery.on_key("delete", function()
      local image = swayimg.gallery.get_image()
      os.execute("trash " .. image.path)
      swayimg.imagelist.remove(image.path)
    end)

    swayimg.gallery.on_key("Left", function()
      swayimg.gallery.select("left")
    end)

    swayimg.gallery.on_key("Space", function()
      swayimg.gallery.mark_image()
    end)

    swayimg.on_window_resize(function()
      if swayimg.mode == "viewer" then
        swayimg.viewer.set_fix_scale("optimal")
      end
    end)

    local orders = { "none", "alpha", "numeric", "mtime", "size", "random" }
    local order_idx = 3

    local shared_keys = {
      q = function()
        swayimg.exit()
      end,
      ["/"] = function()
        order_idx = order_idx % #orders + 1
        swayimg.imagelist.order = orders[order_idx]
        swayimg.text.set_status("Sort: " .. orders[order_idx])
      end,
      ["Ctrl+R"] = function()
        swayimg.viewer.reload()
      end,
    }

    for key, handler in pairs(shared_keys) do
      swayimg.viewer.on_key(key, handler)
      swayimg.gallery.on_key(key, handler)
    end
   
    swayimg.viewer.on_key("Escape", function()
      swayimg.mode = "gallery"
    end)

    swayimg.gallery.on_key("Escape", function()
        swayimg.exit()      
    end)
  '';
}
