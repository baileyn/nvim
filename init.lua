local ok = pcall(require, 'impatient')
require('config.packer_commands')

if not ok then
	require('config.plugins').sync()
end

require('config.general')
