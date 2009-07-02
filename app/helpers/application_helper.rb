# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Replacement for Rails' default Markdown helper which uses RDiscount instead
  # of BlueCloth.
  def markdown(text)
    text.blank? ? "" : RDiscount.new(text, :filter_html).to_html
  end
  
  def nice_date(date)
    date.strftime("%H:%M %d.%m.%Y") # %Y.%m.%d %H:%M
  end
  
  def menu_items
    [ 
      ["заметки", root_path], 
      ["написать", new_post_path], 
      ["комментарии", comments_path], 
      ["что это?", about_path],
      [image_tag("feed.png"), "http://feeds.rubyk.ru/rubyk"],
      [image_tag("twitter.png"), "http://twitter.com/rubyk_ru"] 
    ]
  end
end
