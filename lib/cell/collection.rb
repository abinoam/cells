module Cell
  class Collection
    def initialize(ary, options, cell_class)
      @method = options.delete(:method) # TODO: deprecate :method.
      @join   = options.delete(:collection_join)

      @ary = ary
      @options = options
      @cell_class = cell_class
    end

    def call(state=:show)
      join(@join) { |cell, i| cell.(@method || state) }.
        html_safe
    end

    alias to_s call

    # Iterate collection and build a cell for each item.
    # The passed block receives that cell and the index.
    # Its return value is captured and joined.
    def join(separator="", &block)
      @ary.each_with_index.collect do |model, i|
        yield @cell_class.build(model, @options), i
      end.
        join(separator)
    end
  end
end