Prerequisites for Ubuntu:
```bash
# Neovim (get a recent version, Ubuntu's apt is often outdated)
sudo snap install nvim --classic

# tree-sitter CLI
npm install -g tree-sitter-cli  # or cargo install tree-sitter-cli

# For render-markdown latex support
pip install pylatexenc
```
Then 
```bash
# On the Ubuntu office PC
git clone https://github.com/you/nvim-config ~/.config/nvim
nvim
```
