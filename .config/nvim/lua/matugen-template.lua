local M = {}

function M.setup()
  require('base16-colorscheme').setup {
    base00 = '{{colors.surface.default.hex}}',
    base01 = '{{colors.surface_variant.default.hex}}',
    base02 = '{{colors.secondary_container.default.hex}}',
    base03 = '{{colors.outline.default.hex}}',
    base04 = '{{colors.on_surface_variant.default.hex}}',
    base05 = '{{colors.on_surface.default.hex}}',
    base06 = '{{colors.on_surface.default.hex}}',
    base07 = '{{colors.on_background.default.hex}}',
    base08 = '{{colors.error.default.hex}}',
    base09 = '{{colors.tertiary.default.hex}}',
    base0A = '{{colors.secondary.default.hex}}',
    base0B = '{{colors.primary.default.hex}}',
    base0C = '{{colors.tertiary_container.default.hex}}',
    base0D = '{{colors.primary.default.hex}}',
    base0E = '{{colors.secondary.default.hex}}',
    base0F = '{{colors.error.default.hex}}',
  }
end

return M
