return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = {
      "CodeCompanion",
      "CodeCompanionChat",
      "CodeCompanionCmd",
      "CodeCompanionActions",
      "CodeCompanionCLI",
    },
    keys = {
      {
        "<leader>aa",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "AI Actions",
      },
      {
        "<leader>ac",
        "<cmd>CodeCompanionChat Toggle<cr>",
        mode = { "n", "v" },
        desc = "AI Chat Toggle",
      },
      {
        "<leader>aA",
        "<cmd>CodeCompanionChat Add<cr>",
        mode = "v",
        desc = "AI Add Selection to Chat",
      },
      {
        "<leader>ai",
        ":CodeCompanion ",
        mode = { "n", "v" },
        desc = "AI Inline Prompt",
      },
    },
    opts = {
      opts = {
        language = "Traditional Chinese",
        log_level = "ERROR",
      },

      display = {
        chat = {
          show_token_count = true,
          show_context = true,
          token_count = function(tokens, adapter)
            local context_window = adapter.model and adapter.model.meta and adapter.model.meta.context_window
            if context_window then
              local pct = math.floor((tokens / context_window) * 100)
              return string.format(" (%d / %d  tokens, %d%%)", tokens, context_window, pct)
            end
            return string.format(" (%d tokens)", tokens)
          end,
        },
      },

      adapters = {
        http = {
          my_openai_compatible = function()
            return require("codecompanion.adapters").extend("openai_compatible", {
              env = {
                -- 注意：這裡是 base URL，不是完整 chat completions URL
                -- 例如：
                --   http://127.0.0.1:8080
                --   https://api.example.com
                url = os.getenv("OPENAI_COMPAT_BASE_URL") or "http://127.0.0.1:8080",

                -- 如果你的服務不用 API key，先給 dummy；有些相容服務會直接忽略 Authorization
                api_key = function()
                  return os.getenv("OPENAI_COMPAT_API_KEY") or "dummy"
                end,

                -- 如果你的服務只實作 chat completions，這條通常就是重點
                chat_url = "/v1/chat/completions",
              },
              schema = {
                model = {
                  default = os.getenv("OPENAI_COMPAT_MODEL") or "gpt-4o-mini",
                },
              },
            })
          end,
        },
      },

      interactions = {
        chat = {
          adapter = "opencode",
        },
        inline = {
          adapter = "opencode",
        },
        cmd = {
          adapter = "opencode",
        },
      },
    },
  },

  -- 可選：讓 CodeCompanion chat buffer 的 Markdown 比較像樣
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" },
  },
}
