module ApplicationHelper

  def back_button props
     link_to "<i class='fas fa-undo'></i>Back".html_safe, (props[:path] == nil) ? root_path : props[:path], class: 'green-button'
  end
end
