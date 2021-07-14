local function paste_handler(overridden)
  return function(lines, phase)
    if phase == -1 then
      -- non-streaming: all text is in a single call
      vim.call("hltermpaste#start_paste")
      overridden(lines, phase)
      vim.call("hltermpaste#finish_paste")
    elseif phase == 1 then
      -- starts the paste
      vim.call("hltermpaste#start_paste")
      overridden(lines, phase)
    elseif phase == 3 then
      -- ends the paste
      overridden(lines, phase)
      vim.call("hltermpaste#finish_paste")
    else
      overridden(lines, phase)
    end
  end
end

local function setup()
  vim.paste = paste_handler(vim.paste)
end

return {
  setup = setup,
}
