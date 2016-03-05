class PrintMode

  INVERSE_MASK = (1 << 1)
  UPDOWN_MASK = (1 << 2)
  BOLD_MASK = (1 << 3)
  DOUBLE_HEIGHT_MASK = (1 << 4)
  DOUBLE_WIDTH_MASK = (1 << 5)
  STRIKE_MASK = (1 << 6)

  def initialize connection
    @print_mode = 0
    @connection = connection
  end

  def set_print_mode(mask)
    @print_mode |= mask
    write_print_mode
  end

  def unset_print_mode(mask)
    @print_mode &= ~mask
    write_print_mode
  end

  def write_print_mode
    bytes = [ESC_SEQUENCE, 33, @print_mode]
    @connection.write_bytes bytes
  end

  def normal
    write_print_mode
  end

  def inverse_on
    set_print_mode(INVERSE_MASK)
  end

  def inverse_off
    unset_print_mode(INVERSE_MASK)
  end

  def upside_down_on
    set_print_mode(UPDOWN_MASK);
  end

  def upside_down_off
    unset_print_mode(UPDOWN_MASK);
  end

  def double_height_on
    set_print_mode(DOUBLE_HEIGHT_MASK)
  end

  def double_height_off
    unset_print_mode(DOUBLE_HEIGHT_MASK)
  end

  def double_width_on
    set_print_mode(DOUBLE_WIDTH_MASK)
  end

  def double_width_off
    unset_print_mode(DOUBLE_WIDTH_MASK)
  end

  def strike_on
    set_print_mode(STRIKE_MASK)
  end

  def strike_off
    unset_print_mode(STRIKE_MASK)
  end

  def bold_on
    set_print_mode(BOLD_MASK)
  end

  def bold_off
    unset_print_mode(BOLD_MASK)
  end
end
