module TasksHelper
  def highlight_search_term(text, search_term)
    return text if search_term.blank? || text.blank?
    
    highlighted = text.gsub(/(#{Regexp.escape(search_term)})/i) do |match|
      "<mark class='bg-yellow-200 px-1 rounded'>#{match}</mark>"
    end
    
    highlighted.html_safe
  end
  
  def filter_badge_class(param_key, param_value, current_value)
    if current_value == param_value
      case param_key
      when 'priority'
        case param_value
        when 'high' then 'bg-red-50 border-red-300 text-red-700'
        when 'medium' then 'bg-yellow-50 border-yellow-300 text-yellow-700'
        when 'low' then 'bg-green-50 border-green-300 text-green-700'
        end
      else
        'bg-blue-50 border-blue-300 text-blue-700'
      end
    else
      'text-gray-700 bg-white hover:bg-gray-50'
    end
  end
end
