local dap = require("dap")
local dapui = require("dapui")
dapui.setup({})
require("nvim-dap-virtual-text").setup({
    commented = true, -- Show virtual text alongside comment
})

vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
})

vim.fn.sign_define("DapBreakpointRejected", {
    text = "", -- or "❌"
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = "",
})

vim.fn.sign_define("DapStopped", {
    text = "", -- or "→"
    texthl = "DiagnosticSignWarn",
    linehl = "Visual",
    numhl = "DiagnosticSignWarn",
})

-- Automatically open/close DAP UI
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

--~-~-~-~- Keymaps -~-~-~-~--
local opts = { noremap = true, silent = true }

-- Toggle breakpoint
vim.keymap.set("n", "<leader>dt", function()
    dap.toggle_breakpoint()
end, opts)

-- Clear breakpoint
vim.keymap.set("n", "<leader>dx", function()
    dap.clear_breakpoints()
end, opts)

-- List breakpoints
vim.keymap.set("n", "<leader>dl", function()
    dap.list_breakpoints()
end, opts)

-- Continue / Start
vim.keymap.set("n", "<leader>dc", function()
    dap.continue()
end, opts)

-- Step Over
vim.keymap.set("n", "<leader>do", function()
    dap.step_over()
end, opts)

-- Step Into
vim.keymap.set("n", "<leader>di", function()
    dap.step_into()
end, opts)

-- Step Out
vim.keymap.set("n", "<leader>dO", function()
    dap.step_out()
end, opts)

-- Run to Cursor
vim.keymap.set("n", "<leader>d.", function()
    dap.run_to_cursor()
end, opts)

-- Keymap to terminate debugging
vim.keymap.set("n", "<leader>dq", function()
    require("dap").terminate()
end, opts)

-- Toggle DAP UI
vim.keymap.set("n", "<leader>du", function()
    dapui.toggle()
end, opts)

--~-~-~-~- Language Adapters -~-~-~-~--
require("dap-python").setup("python3")

dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = "codelldb",
    args = { "--port", "${port}" },
  },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.c = dap.configurations.cpp

