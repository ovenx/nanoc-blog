module PaginationHelper
  def generate_pages(articles, base_url='')
    articles_to_paginate = articles
    #pages = (articles.size - 1) / @config[:page_size] + 1
    article_groups = []
    until articles_to_paginate.empty?
      article_groups << articles_to_paginate.slice!(0..@config[:page_size]-1)
    end
    article_groups.each_with_index do |subarticles, i|
        first = i*@config[:page_size] + 1
        last = (i+1)*@config[:page_size]
        title = "#{@config[:meta][:title]}"
        if i == 0
            id = "/index.html"
        else
            title = "#{title} (posts #{first} to #{last})"
            id = "/page/#{i+1}"
        end
        @items.create("== render '/index.*', :item_id=>#{i+1}", {
            title: title,
            created_at: DateTime.now,
            paged: true,
            extension: "slim",
        }, id)
    end

  end

end

include PaginationHelper
