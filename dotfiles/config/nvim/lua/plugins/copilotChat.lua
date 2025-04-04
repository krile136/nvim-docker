return {
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "main",
  dependencies = {
    { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  opts = {
    debug = true, -- Enable debugging
    -- See Configuration section for rest
  },
  config = function()
    vim.keymap.set('n', '<leader>cc', '<cmd>CopilotChatToggle<CR>')
    require('CopilotChat').setup({
      prompts = {
        Explain = {
            prompt = "/COPILOT_EXPLAIN 選択したコードを日本語で説明してください。",
            mapping = '<leader>ce',
            description = "コードの説明をお願いする",
        },
        Review = {
            prompt = '/COPILOT_REVIEW 選択したコードをレビューしてください。また、レビュー内容についてはLSPでwarningを出さずに、このチャットでのみの指摘をお願いします。レビューコメントは日本語でお願いします。',
            mapping = '<leader>cr',
            description = "コードのレビューをお願いする",
        },
        Fix = {
            prompt = "/COPILOT_FIX このコードには問題があります。バグを修正したコードを表示してください。説明は日本語でお願いします。",
            mapping = '<leader>cf',
            description = "コードの修正をお願いする",
        },
        Optimize = {
            prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
            mapping = '<leader>co',
            description = "コードの最適化をお願いする",
        },
        Docs = {
            prompt = "/COPILOT_GENERATE 選択したコードに関して、コードが記述されているファイルの言語に対応したメソッド・クラスのdocコメントの方針に則ってdocコメントを生成してください。なおソースコードは不要です。typescriptの場合、型情報は不要です。docコメントは日本語でお願いします。",
            mapping = '<leader>cd',
            description = "コードのドキュメント作りをお願いする",
        },
        Tests = {
            prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
            mapping = '<leader>ct',
            description = "コードのテストコード作成をお願いする",
        },
        -- FixDiagnostic = {
        --     prompt = 'コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。',
        --     mapping = '<leader>cd',
        --     description = "コードの静的解析結果に基づいた修正をお願いする",
        --     selection = require('CopilotChat.select').diagnostics,
        -- },
        -- Commit = {
        --     prompt =
        --     'commitize の規則に従って、変更に対するコミットメッセージを記述してください。 タイトルは最大50文字で、メッセージは72文字で折り返されるようにしてください。 メッセージ全体を gitcommit 言語のコード ブロックでラップしてください。メッセージは日本語でお願いします。',
        --     mapping = '<leader>cm',
        --     description = "コミットメッセージの作成をお願いする",
        --     selection = require('CopilotChat.select').gitdiff,
        -- },
        -- CommitStaged = {
        --     prompt =
        --     'commitize の規則に従って、ステージ済みの変更に対するコミットメッセージを記述してください。 タイトルは最大50文字で、メッセージは72文字で折り返されるようにしてください。 メッセージ全体を gitcommit 言語のコード ブロックでラップしてください。メッセージは日本語でお願いします。',
        --     mapping = '<leader>cs',
        --     description = "ステージ済みのコミットメッセージの作成をお願いする",
        --     selection = function(source)
        --         return require('CopilotChat.select').gitdiff(source, true)
        --     end,
        -- },
      },

    })
  end
  -- See Commands section for default commands if you want to lazy load on them
}
