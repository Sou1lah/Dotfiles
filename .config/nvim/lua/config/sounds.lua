-- ============================================================================
-- SOUND EFFECTS MODULE
-- ============================================================================

local M = {}

-- Sound file paths
local sound_dir = "/home/wael/Music/sound board/"
local sounds = {
  copy = sound_dir .. "copy.wav",
  delete = sound_dir .. "delete.wav",
  -- Add more sound files here as needed:
  -- save = sound_dir .. "save.wav",
  -- paste = sound_dir .. "paste.wav",
  -- undo = sound_dir .. "undo.wav",
  -- redo = sound_dir .. "redo.wav",
}

-- Track if delete mappings are enabled
local delete_mappings_enabled = false

-- Function to play sound
function M.play_sound(sound_name)
  local sound_file = sounds[sound_name]
  if sound_file and vim.fn.filereadable(sound_file) == 1 then
    -- Play sound using available audio command
    if vim.fn.executable("aplay") == 1 then
      os.execute(string.format("aplay '%s' >/dev/null 2>&1 &", sound_file))
    elseif vim.fn.executable("paplay") == 1 then
      os.execute(string.format("paplay '%s' >/dev/null 2>&1 &", sound_file))
    else
      os.execute(string.format("play '%s' >/dev/null 2>&1 &", sound_file))
    end
  end
end

-- Function to add a new sound
function M.add_sound(name, filepath)
  sounds[name] = filepath
end

-- Function to check if sound exists
function M.sound_exists(name)
  local sound_file = sounds[name]
  return sound_file and vim.fn.filereadable(sound_file) == 1
end

-- List all available sounds
function M.list_sounds()
  local available = {}
  for name, path in pairs(sounds) do
    if vim.fn.filereadable(path) == 1 then
      table.insert(available, name)
    end
  end
  return available
end

-- Enable delete key mappings
function M.setup_delete_mappings()
  -- Common delete operations with sound
  vim.keymap.set("n", "dd", function()
    vim.cmd('normal! dd')
    M.play_sound("delete")
  end, { desc = "Delete line with sound" })
  
  vim.keymap.set("n", "x", function()
    vim.cmd('normal! x')
    M.play_sound("delete")
  end, { desc = "Delete character with sound" })
  
  vim.keymap.set("n", "dw", function()
    vim.cmd('normal! dw')
    M.play_sound("delete")
  end, { desc = "Delete word with sound" })
  
  vim.keymap.set("v", "d", function()
    vim.cmd('normal! d')
    M.play_sound("delete")
  end, { desc = "Delete selection with sound" })
  
  delete_mappings_enabled = true
end

-- Check if delete mappings are enabled
function M.are_delete_mappings_enabled()
  return delete_mappings_enabled
end

-- Setup all sound mappings (for future expansion)
function M.setup_sound_mappings()
  M.setup_delete_mappings()
  
  -- Future sound mappings can be added here:
  -- M.setup_undo_mappings()
  -- M.setup_paste_mappings()
  -- etc.
end

return M