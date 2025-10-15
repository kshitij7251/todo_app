class ThemeController < ApplicationController
  def toggle
    current_user.update(dark_mode: !current_user.dark_mode)
    redirect_back(fallback_location: root_path)
  end
end