vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.swapfile = false

local function setup_mise_integration()
  local mise_shims_path = vim.env.HOME .. "/.local/share/mise/shims"

  if vim.fn.isdirectory(mise_shims_path) == 1 then
    vim.env.PATH = mise_shims_path .. ":" .. vim.env.PATH

    vim.env.MISE_DATA_DIR = vim.env.HOME .. "/.local/share/mise"

    print("✓ MISE integração configurada com sucesso")
  else
    print("⚠ Diretório de shims do MISE não encontrado: " .. mise_shims_path)
    print("Certifique-se de que o MISE está instalado e configurado")
  end
end

local function run_mise_command(cmd)
  local result = vim.fn.system("mise " .. cmd)
  return vim.trim(result)
end

local function show_mise_versions()
  local versions = run_mise_command("current")
  print("Versões ativas do MISE:")
  print(versions)
end

setup_mise_integration()

vim.api.nvim_create_user_command("MiseVersions", show_mise_versions, {
  desc = "Mostra as versões ativas do MISE",
})

vim.api.nvim_create_user_command("MiseReload", function()
  setup_mise_integration()
end, {
  desc = "Recarrega a integração com o MISE",
})

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>", { desc = "Ir para painel acima" })
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>", { desc = "Ir para painel abaixo" })
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>", { desc = "Ir para painel esquerda" })
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>", { desc = "Ir para painel direita" })
-- MISE
vim.keymap.set("n", "<leader>mv", ":MiseVersions<CR>", { desc = "Mostrar versões do MISE" })
vim.keymap.set("n", "<leader>mr", ":MiseReload<CR>", { desc = "Recarregar MISE" })

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    setup_mise_integration()
  end,
  desc = "Recarrega MISE ao mudar de diretório",
})
