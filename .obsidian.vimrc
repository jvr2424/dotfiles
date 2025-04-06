set clipboard=unnamed
exmap back obcommand app:go-back
nmap <C-o> :back<CR>
exmap forward obcommand app:go-forward
nmap <C-i> :forward<CR>

exmap tabnext obcommand workspace:next-tab
nmap gt :tabnext<CR>
exmap tabprev obcommand workspace:previous-tab
nmap gT :tabprev<CR>

exmap open_new_tab obcommand editor:open-link-in-new-leaf
nmap gF :open_new_tab<CR>


unmap <Space>

exmap open_conext_menu obcommand editor:context-menu
nmap <Space>s :open_conext_menu<CR>



exmap toggle_checklist obcommand editor:toggle-checklist-status
nmap <Space>x :toggle_checklist<CR>


