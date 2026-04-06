# Simple Neovim Sound Effects

A clean, minimal sound effects system for Neovim with copy and delete sounds.

## Current Setup

✅ **Copy Sound**: Plays automatically when you copy text (y, yy, etc.)  
✅ **Delete Sound**: Available - enable with `:EnableDeleteSounds`

## Available Commands

- `:PlaySound <name>` - Play a specific sound
- `:ListSounds` - List available sounds  
- `:EnableDeleteSounds` - Enable delete key mappings
- `:TestCopySound` - Test copy sound
- `:TestDeleteSound` - Test delete sound
- `:SoundHelp` - Show help

## Quick Setup

1. **Test copy sound**: Copy some text in Neovim (should hear sound)
2. **Enable delete sounds**: `:EnableDeleteSounds`
3. **Test delete**: Try `dd` to delete a line

## Sound Files

Location: `/home/wael/Music/sound board/`
- `copy.wav` ✅ (working automatically)
- `delete.wav` ✅ (enable with command)

## Adding Future Sounds

1. **Add sound files** to `/home/wael/Music/sound board/`
2. **Update sounds.lua**: Uncomment lines in the sounds table
3. **Add autocmds**: Uncomment relevant sections in autocommands.lua

### Example - Adding Save Sound:

1. Add `save.wav` to sound board folder
2. In `sounds.lua`, uncomment:
   ```lua
   save = sound_dir .. "save.wav",
   ```
3. In `autocommands.lua`, uncomment:
   ```lua
   vim.api.nvim_create_autocmd("BufWritePost", {
     callback = function()
       sounds.play_sound("save")
     end,
   })
   ```

## Testing

1. **Copy sound**: Copy some text - should hear sound automatically
2. **Delete sound**: Run `:EnableDeleteSounds`, then try `dd`  
3. **List sounds**: `:ListSounds`
4. **Test specific**: `:PlaySound copy` or `:PlaySound delete`

## Troubleshooting  

**No sound?** Test audio directly:
```bash
aplay "/home/wael/Music/sound board/copy.wav"
```

**File not found?** Check:
```bash
ls -la "/home/wael/Music/sound board/"
```
