# frozen_string_literal: true

# Application base helper
module ApplicationHelper
  def menu_link(label, url, active = false, options = nil)
    content_tag :li, class: (active ? 'active' : '') do
      link_to label, url, options
    end
  end
end
