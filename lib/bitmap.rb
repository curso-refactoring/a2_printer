class Bitmap
  MAX_CHUNK_SIZE = 255

  class << self
    def from_source connection, source
      data = obtain_data source
      width = obtain_width data
      height = obtain_heigth data
      new(connection, width, height, source)
    end

    private

    def obtain_data source
      if source.respond_to?(:getbyte)
        source
      else
        StringIO.new(source.map(&:chr).join)
      end
    end

    def obtain_heigth data
      obtain_value data
    end

    def obtain_width data
      obtain_value data
    end

    def obtain_value data
      tmp = data.getbyte
      (data.getbyte << 8) + tmp
    end
  end

  def initialize(connection, width, height, source)
    set_source(source)
    @width = width
    @height = height
    @connection = connection
  end

  def wider_than? width
    @width > width
  end

  def print
    row_init = 0
    width_in_bytes = to_bytes @width

    (row_init...@height).step(MAX_CHUNK_SIZE) do |row_start|
      chunk_height = calculate_chunk_height row_start
      bytes = prepare_image width_in_bytes, chunk_height

      print_chunk chunk_height, width_in_bytes, *bytes
    end
  end

  private

  def print_chunk height, width, *bytes
    start_print
    set_size height, width
    print_image *bytes
  end

  def to_bytes width
    width / 8
  end

  def prepare_image width, height
    (0...(width * height)).map { @data.getbyte }
  end

  def calculate_chunk_height row_start
    chunk_height = @height - row_start
    sanitize chunk_height
  end

  def sanitize height
    [height, MAX_CHUNK_SIZE].min
  end

  def start_print
    @connection.write_bytes(18, 42)
  end

  def set_size height, width
    @connection.write_bytes(height, width)
  end

  def print_image *bytes
    @connection.write_bytes(*bytes)
  end

  def set_source(source)
    if source.respond_to?(:getbyte)
      @data = source
    else
      @data = StringIO.new(source.map(&:chr).join)
    end
  end

  def extract_width_and_height_from_data
    tmp = @data.getbyte
    @width = (@data.getbyte << 8) + tmp
    tmp = @data.getbyte
    @height = (@data.getbyte << 8) + tmp
  end
end
