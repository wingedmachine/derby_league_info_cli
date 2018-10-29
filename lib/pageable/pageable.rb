module Pageable
  module ClassMethods
    def paginate_array(flat_array, per_page = 10)
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
  end
end
