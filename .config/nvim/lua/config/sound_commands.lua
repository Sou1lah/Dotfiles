-- ============================================================================
-- SOUND MANAGEMENT COMMANDS
-- ============================================================================

local sounds = require("config.sounds")

-- Basic Commands
vim.api.nvim_create_user_command("PlaySound", function(opts)
  local sound_name = opts.args
  if sound_name == "" then
    local available = sounds.list_sounds()
    if #available > 0 then
      print("Available sounds: " .. table.concat(available, ", "))
    else
      print("No sound files found!")
    end
    return
  end
  
  if sounds.sound_exists(sound_name) then
    sounds.play_sound(sound_name)
    print("Playing sound: " .. sound_name)
  else
    print("Sound not found: " .. sound_name)
  end
end, {
  nargs = "?",
  complete = function() return sounds.list_sounds() end,
  desc = "Play a sound effect (or list available sounds)"
})

vim.api.nvim_create_user_command("ListSounds", function()
  local available = sounds.list_sounds()
  if #available > 0 then
    print("Available sound effects:")
    for _, sound in ipairs(available) do
      print("  - " .. sound)
    end
  else
    print("No sound files found!")
  end
end, { desc = "List all available sound effects" })

-- Enable delete sound mappings
vim.api.nvim_create_user_command("EnableDeleteSounds", function()
  sounds.setup_delete_mappings()
  print("Delete sound mappings enabled!")
  print("Try: dd (delete line), x (delete char), dw (delete word)")
end, { desc = "Enable delete key mappings with sound" })

-- Test commands
vim.api.nvim_create_user_command("TestCopySound", function()
  sounds.play_sound("copy")
  print("Testing copy sound...")
end, { desc = "Test the copy sound effect" })

vim.api.nvim_create_user_command("TestDeleteSound", function()
  sounds.play_sound("delete")
  print("Testing delete sound...")
end, { desc = "Test the delete sound effect" })

-- Complete test command
vim.api.nvim_create_user_command("TestAllSounds", function()
  print("🔊 Testing All Sounds...")
  print("========================")
  
  print("1. Testing copy sound...")
  sounds.play_sound("copy")
  vim.cmd("sleep 1")
  
  print("2. Testing delete sound...")
  sounds.play_sound("delete")
  vim.cmd("sleep 1")
  
  print("")
  print("Status:")
  print("✅ Copy sound: Always enabled")
  if sounds.are_delete_mappings_enabled() then
    print("✅ Delete mappings: Enabled")
  else
    print("🔴 Delete mappings: Run :EnableDeleteSounds")
  end
  
  print("")
  print("Test complete! Enable delete mappings if needed.")
end, { desc = "Test all sound effects" })

-- Status command
vim.api.nvim_create_user_command("SoundStatus", function()
  print("🔊 Sound Effects Status")
  print("=======================")
  print("")
  print("✅ Copy sound: Always enabled (automatic)")
  
  if sounds.are_delete_mappings_enabled() then
    print("✅ Delete sounds: Enabled")
  else
    print("🔴 Delete sounds: Use :EnableDeleteSounds to enable")
  end
  
  print("")
  local available = sounds.list_sounds()
  print("Available sound files: " .. table.concat(available, ", "))
end, { desc = "Show current sound effects status" })

-- Help command
vim.api.nvim_create_user_command("SoundHelp", function()
  print("🔊 Sound Effects Help")
  print("=====================")
  print("")
  print("Commands:")
  print("  :SoundStatus         - Show status")
  print("  :PlaySound <name>    - Play a sound")
  print("  :ListSounds          - List available sounds")
  print("  :EnableDeleteSounds  - Enable delete key sounds")
  print("  :TestCopySound       - Test copy sound")
  print("  :TestDeleteSound     - Test delete sound")
  print("")
  print("Available sounds:")
  local available = sounds.list_sounds()
  for _, sound in ipairs(available) do
    print("  • " .. sound)
  end
end, { desc = "Show sound effects help" })
