-- Enable zoxide database updates when navigating
require("zoxide"):setup { update_db = true }

-- Enable git status indicators
require("git"):setup { order = 1500 }

require("full-border"):setup()
