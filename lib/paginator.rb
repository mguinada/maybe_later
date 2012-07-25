module Mongoid
  #The Paginator module adds pagination to Mogoid modules
  module Paginator
    def self.included(a_class)
      a_class.extend ClassMethods
    end

    module ClassMethods
      def page_size; 10; end

      def page(page)
        page = page.to_i
        offset = page > 1 ? (page - 1) * page_size : 0

        scoped.limit(page_size).offset(offset)
      end
    end
  end
end

module Mongoid
  module Paginator
    #Mixin for Mongoid::Criteria
    module Page
      #Total items through out all the scope
      def total_items
        count
      end

      def offset_value
        options[:skip]
      end

      def page_size
        options[:limit]
      end

      def per_page(value)
        options[:limit] = value
        self
      end

      def page_number
        page_number = offset_value / page_size + 1

        return total_page_count if page_number > total_page_count
        page_number
      end

      def previous_page_count
        page_number - 1
      end
      alias :previous_pages_count :previous_page_count

      def previous_page?
        previous_page_count > 0
      end

      def following_page?
        following_pages_count > 0
      end
      alias :next_page? :following_page?

      def following_pages_count
        total_page_count - page_number
      end
      alias :following_page_count :following_pages_count

      def total_page_count
        (total_items.to_f / (page_size.zero? ? 1 : page_size)).ceil
      end
    end
  end
end

#Include Mongoid::Paginator::Page in Mongoid::Criteria
Mongoid::Criteria.send :include, Mongoid::Paginator::Page

#Sinatra helper for page links
module Sinatra
  module Paginator
    def paginate(scope, opts = {})
      return "" if scope.total_page_count < 2

      links = []
      neighbor_links = opts.fetch(:neighbor_links) { 2 }
      first_page_link = opts.fetch(:first_page_link) { false }
      last_page_link = opts.fetch(:first_page_link) { false }

      if scope.previous_page?
        links << page_link(scope.page_number - 1, ' < ', class: 'previous-page-link')
        links << page_link(1, :first, class: 'first-page-link') if first_page_link
      end

      [scope.previous_page_count, neighbor_links].min.downto(1) do |i|
        links << page_link(page_num = scope.page_number - i, page_num, class: 'page-link')
      end

      links << "<em class='current-page'>#{scope.page_number}</em>"

      [scope.following_pages_count, neighbor_links].min.times do |i|
        links << page_link(page_num = scope.page_number + i + 1, page_num, class: 'page-link')
      end

      if scope.next_page?
        links << page_link(scope.total_page_count, :last, class: 'last-page-link') if last_page_link
        links << page_link(scope.page_number + 1, ' > ', class: 'next-page-link')
      end

      links.join(opts.fetch(:separator) { ' | ' })
    end

    private
    def page_link(page_num, text, attrs = {})
      link("?page=#{page_num}", text, attrs)
    end

    def link(href, text, attrs = {})
      html = "<a href='#{href}'"
      tag_attrs = attrs.reduce('') { |out, pair| out << "#{pair.first}='#{pair.last}' " }.rstrip
      html += " #{tag_attrs}" unless tag_attrs.empty?
      html += ">#{text}</a>"
    end
  end
end