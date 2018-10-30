module Pageable
  PerPageDefault = 10

  module ClassMethods
    def paginate_array(flat_array, per_page = PerPageDefault)
        paginated_array = []
        while flat_array.size > per_page
          new_page = []
          per_page.times do
            new_page << flat_array.shift
          end
          paginated_array << new_page
        end
        paginated_array << flat_array
    end
  end

  module InstanceMethods
    attr_reader :curr_page_num, :pages, :single_page, :total_pages

    def initialize(flat_data, per_page = PerPageDefault)
      @single_page = flat_data
      @pages = self.class.paginate_array(flat_data.dup, per_page)
      @curr_page_num = 1
      @total_pages = pages.size
    end

    def next_page
      turn_to(curr_page_num + 1)
    end

    def prev_page
      turn_to(curr_page_num - 1)
    end

    def turn_to(page_num)
      return nil unless page_num >= 1 && page_num <= total_pages

      @curr_page_num = page_num
      current_page
    end

    def current_page
      pages[@curr_page_num - 1]
    end
  end
end
