return {
  "jonathanmorris180/salesforce.nvim",
  lazy = false,
  config = function()
    local M = require("salesforce")

    require("salesforce").setup {
      popup = {
        width = 200,
        height = 40,
      },
    }

    vim.api.nvim_create_user_command('SfPush', function()
      vim.cmd('SalesforcePushToOrg')
    end, {})

    vim.api.nvim_create_user_command('SfCreateApex', function()
      vim.cmd('SalesforceCreateApex')
    end, {})

    vim.api.nvim_create_user_command('SFTM', function()
      vim.cmd('SalesforceExecuteCurrentMethod')
    end, {})

    vim.api.nvim_create_user_command('SFTC', function()
      vim.cmd('SalesforceExecuteCurrentClass')
    end, {})


    vim.api.nvim_create_user_command('SfTestMethod', function()
      vim.cmd('SalesforceExecuteCurrentMethod')
    end, {})

    vim.api.nvim_create_user_command('SfTestClass', function()
      vim.cmd('SalesforceExecuteCurrentClass')
    end, {})

    vim.api.nvim_create_user_command('SfRefreshOrg', function()
      vim.cmd('SalesforceRefreshOrgInfo')
    end, {})

    vim.api.nvim_create_user_command('SfExecute', function()
      vim.cmd('SalesforceExecuteFile')
    end, {})

  end,
}
