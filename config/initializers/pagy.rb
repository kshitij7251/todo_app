# frozen_string_literal: true

require 'pagy/extras/overflow'
require 'pagy/extras/items'  # Allow users to change items per page
require 'pagy/extras/trim'   # Remove empty pages from the extremes

# Pagy configuration
Pagy::DEFAULT[:items] = 15        # Items per page
Pagy::DEFAULT[:size]  = [1,4,4,1] # Navigation bar links
Pagy::DEFAULT[:overflow] = :last_page # What to do when requesting a page too high