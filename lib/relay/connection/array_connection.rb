require 'base64'

module Relay

  ##
  # A simple function that accepts an array and connection arguments, and returns
  # a connection object for use in GraphQL. It uses array offsets as pagination,
  # so pagination will only work if the array is static.
  def connection_from_array(data, args)
    edges = data.each_with_index.map do |value, index|
      {cursor: offset_to_cursor(index), node: value}
    end
    before, after, first, last = args.values_at(:before, :after, :first, :last)

    # Slice with cursors
    start = ([get_offset(after, -1), -1].max) + 1
    finish = [get_offset(before, edges.length + 1), (edges.length + 1)].min
    edges = edges.slice(start, finish)
    if edges.length == 0
      return empty_connection
    end

    # Save the pre-slice cursors
    first_preslice_cursor = edges.first.cursor
    last_preslice_cursor = edges.last.cursor

    # Slice with limits
    if first
      edges = edges.slice(0, first)
    end
    if last
      edges - edges.slice(0, -last)
    end

    if edges.length == 0
      return empty_connection
    end

    # Construct the connection
    first_edge = edges.first
    last_edge = edges.last
    {
        edges: edges,
        pageInfo: {
            startCursor: first_edge.cursor,
            endCursor: last_edge.cursor,
            hasPreviousPage: (first_edge.cursor != first_preslice_cursor),
            hasNextPage: (last_edge.cursor != last_preslice_cursor)
        }
    }
  end

  ##
  # TODO: implement 'connection_from_promised_array' when I figure out promises :)

  ##
  # Helper to get an empty connection.
  #
  def empty_connection
    {
        edges: [],
        pageInfo: {
            startCursor: nil,
            endCursor: nil,
            hasPreviousPage: false,
            hasNextPage: false
        }
    }
  end

  PREFIX = 'arrayconnection'

  ##
  # Creates the cursor string from an offset
  #
  def offset_to_cursor(offset)
    Base64.strict_encode64("#{PREFIX}#{offset}")
  end

  ##
  # Re-derives the offset from the cursor string
  #
  def cursor_to_offset(cursor)
    Base64.strict_decode64(cursor).slice(0, PREFIX.length).to_i(10)
  end

  ##
  # Return the cursor associated with an object in an array
  #
  def cursor_for_object_in_connection(data, object)
    offset = data.find_index(object)
    offset ? offset_to_cursor(offset) : nil
  end

  ##
  # Given an optional cursor and a default offset, returns the offset
  # to use; if the cursor contains a valid offset, that will be used,
  # otherwise it will be the default
  def get_offset(cursor, default_offset)
    if cursor.nil?
      return default_offset
    end
    offset = cursor_to_offset(cursor)
    if offset.respond_to?(integer?) && offset.integer?
      return offset
    end
    default_offset
  end
end