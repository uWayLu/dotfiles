-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 啟用 Tailwind CSS LSP
vim.lsp.enable("tailwindcss")

-- 關閉多 LSP 並存時（如 astro + tailwindcss）其中一方無資料彈出的空通知
pcall(function()
  require("noice.config").options.lsp.hover.silent = true
end)

-- 快捷鍵：<leader>uk 切換「游標停駐自動彈出程式碼/Class 說明」
local auto_hover_enabled = false
local auto_hover_group = vim.api.nvim_create_augroup("AutoLspHover", { clear = true })

vim.keymap.set("n", "<leader>uk", function()
  auto_hover_enabled = not auto_hover_enabled
  vim.api.nvim_clear_autocmds({ group = auto_hover_group })

  if auto_hover_enabled then
    pcall(function()
      require("noice.config").options.lsp.hover.silent = true
    end)
    vim.api.nvim_create_autocmd("CursorHold", {
      group = auto_hover_group,
      callback = function()
        if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
          vim.lsp.buf.hover({ silent = true, focusable = false })
        end
      end,
    })
    vim.notify("已開啟：游標停駐自動顯示說明 (Auto Hover)", vim.log.levels.INFO)
  else
    vim.notify("已關閉：游標停駐自動顯示說明", vim.log.levels.WARN)
  end
end, { desc = "Toggle Auto Hover (K)" })
