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
    swayimg.set_mode("viewer")
    swayimg.enable_antialiasing(true)
    swayimg.enable_decoration(true)
    swayimg.enable_overlay(false)
    swayimg.enable_exif_orientation(true)
    swayimg.set_dnd_button("MouseRight")

    swayimg.set_format_params('raw', { camera_wb = true })

    swayimg.imagelist.set_order("numeric")
    swayimg.imagelist.enable_reverse(true)
    swayimg.imagelist.enable_recursive(true)
    swayimg.imagelist.enable_adjacent(true)
    swayimg.imagelist.enable_fsmon(true)

    swayimg.text.set_font("monospace")
    swayimg.text.set_size(13)
    swayimg.text.set_spacing(0)
    swayimg.text.set_padding(4)
    swayimg.text.set_foreground(0xff${p.base05})
    swayimg.text.set_background(0x00000000)
    swayimg.text.set_shadow(0x0d${p.base00})
    swayimg.text.set_timeout(5)
    swayimg.text.set_status_timeout(3)

    swayimg.viewer.set_default_scale("optimal")
    swayimg.viewer.set_default_position("center")
    swayimg.viewer.set_drag_button("MouseLeft")
    swayimg.viewer.set_window_background(0xff${p.base00})
    swayimg.viewer.set_image_chessboard(20, 0xff${p.base00}, 0xff${p.base01})
    swayimg.viewer.enable_centering(true)
    swayimg.viewer.enable_loop(true)
    swayimg.viewer.limit_preload(1)
    swayimg.viewer.limit_history(1)
    swayimg.viewer.set_mark_color(0xff${p.base0D})
    swayimg.viewer.set_pinch_factor(1.0)

    swayimg.slideshow.set_timeout(5)
    swayimg.slideshow.set_default_scale("fit")
    swayimg.slideshow.set_window_background("auto")
    swayimg.slideshow.limit_history(0)
    swayimg.slideshow.set_text("topleft", { "{name}" })

    swayimg.gallery.set_aspect("fill")
    swayimg.gallery.set_thumb_size(380)
    swayimg.gallery.set_padding_size(5)
    swayimg.gallery.set_border_size(5)
    swayimg.gallery.set_border_color(0xff${p.base0D})
    swayimg.gallery.set_selected_scale(1.15)
    swayimg.gallery.set_selected_color(0xff${p.base02})
    swayimg.gallery.set_unselected_color(0xff${p.base01})
    swayimg.gallery.set_window_color(0xff${p.base00})
    swayimg.gallery.set_pinch_factor(100.0)
    swayimg.gallery.enable_hover(true)
    swayimg.gallery.limit_cache(100)
    swayimg.gallery.enable_embedded_thumb(true)
    swayimg.gallery.enable_preload(false)
    swayimg.gallery.enable_pstore(false)

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
      swayimg.set_mode("viewer")
    end)

    swayimg.gallery.on_key("o", function()
      local image = swayimg.gallery.get_image()
      os.execute("xdg-open " .. image.path .. " &")
    end)

    swayimg.gallery.on_key("d", function()
      local image = swayimg.gallery.get_image()
      os.execute("trash " .. image.path)
      swayimg.imagelist.remove(image.path)
    end)

    swayimg.gallery.on_key("Left", function()
      swayimg.gallery.switch_image("left")
    end)

    swayimg.gallery.on_key("Space", function()
      swayimg.gallery.mark_image()
    end)

    swayimg.on_window_resize(function()
      if swayimg.get_mode() == "viewer" then
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
        swayimg.imagelist.set_order(orders[order_idx])
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
      swayimg.set_mode("gallery")
    end)

    swayimg.gallery.on_key("Escape", function()
    end)
  '';
}
