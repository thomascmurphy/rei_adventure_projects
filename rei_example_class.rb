class SlotsControl

  INIT_WARNING = "You must run the size(n) command first to create your slots"

  def initialize
    @states = []
  end

  def states
    @states
  end

  def check_slots
    if @states.length == 0
      return false
    else
      return true
    end
  end

  def return_value
    slots = @states.last
    slots.each_with_index do |value, slot|
      slot_display = "#{slot + 1}: "
      (1..value).each do |i|
        slot_display << "X"
      end
      puts slot_display
    end
    return true
  end

  def save_action (state)
    @states << state
  end

  def size (n)
    slots = Array.new(n, 0)
    @states = [slots]
    return return_value
  end

  def add (slot)
    return INIT_WARNING unless check_slots
    result = add_to_slot(@states.last.clone, slot)
    if result
      save_action(result)
      return return_value
    else
      return parameter_bounds_warning("slot")
    end
  end

  def rm (slot)
    return INIT_WARNING unless check_slots
    result = remove_from_slot(@states.last.clone, slot)
    if result
      save_action(result)
      return return_value
    elsif slot > @states.last.length || slot <= 0
      return parameter_bounds_warning("slot")
    else
      return "INVALID slot: please choose a slot that contains blocks."
    end
  end

  def mv (slot1, slot2)
    return INIT_WARNING unless check_slots
    remove_result = remove_from_slot(@states.last.clone, slot1)
    add_result = add_to_slot(remove_result, slot2)
    if remove_result && add_result
      save_action(add_result)
      return return_value
    elsif !remove_result
      if slot1 > @states.last.length || slot1 <= 0
        return parameter_bounds_warning("slot1")
      else
        return "INVALID slot1: please choose a slot that contains blocks."
      end
    else
      return parameter_bounds_warning("slot2")
    end
  end

  def replay (n=1)
    if (n.is_a? Integer) && n > 0 && n < @states.length
      states = @states.clone
      last_n = states.last(n+1)
      diffs = []
      last_n.last(n).each_with_index do |state, index|
        start_state = last_n[index]
        end_state = state
        diff = end_state.each_with_index.map{|slot, position| slot - start_state[position]}
        diffs << diff
      end
      diffs.each do |diff|
        current_state = @states.last
        new_state = current_state.each_with_index.map{|slot, position| slot + diff[position]}
        save_action(new_state)
      end
      return return_value
    elsif (n.is_a? Integer) && n >= @states.length
      return "INVALID n: please choose a positive integer less than #{@states.length}."
    else
      return parameter_bounds_warning("n", false)
    end
  end

  def undo (n=1)
    if (n.is_a? Integer) && n > 0
      if @states.length > n
        @states.pop(n)
      else
        #Didn't validate this state, seemed a little clearer than replay that you could expect it to just undo to the beginning
        @states.pop(@states.length - 1)
      end
      return return_value
    else
      return parameter_bounds_warning("n", false)
    end
  end

  def run_tests
    passed_tests = []
    failed_tests = []

    init_test = "Creates a set of slots."
    slots_test = "Creates the correct set of slots."
    puts "size(3)"
    size(3)
    @states.length == 1 ? passed_tests << init_test : failed_tests << init_test
    @states.last == [0,0,0] ? passed_tests << slots_test : failed_tests << slots_test

    add_test = "Adds properly"
    puts "add(2)"
    add(2)
    puts "add(3)"
    add(3)
    @states.last == [0,1,1] ? passed_tests << add_test : failed_tests << add_test

    mv_test = "Moves properly"
    puts "mv(3, 2)"
    mv(3, 2)
    @states.last == [0,2,0] ? passed_tests << mv_test : failed_tests << mv_test

    rm_test = "Removes properly"
    puts "rm(2)"
    rm(2)
    @states.last == [0,1,0] ? passed_tests << rm_test : failed_tests << rm_test

    undo_test = "Undoes properly"
    puts "undo(2)"
    undo(2)
    @states.last == [0,1,1] ? passed_tests << undo_test : failed_tests << undo_test

    replay_test = "Replays properly"
    puts "replay(2)"
    replay(2)
    @states.last == [0,2,2] ? passed_tests << replay_test : failed_tests << replay_test

    if failed_tests.length > 0
      return "Failed #{failed_tests.length} tests: #{failed_tests.join(', ')}"
    else
      return "Everything checks out."
    end

  end

  private

  def add_to_slot(state, slot)
    if state != false && (slot.is_a? Integer) && slot > 0 && slot <= state.length
      state[slot-1] += 1
      state
    else
      return false
    end
  end

  def remove_from_slot(state, slot)
    if state != false && (slot.is_a? Integer) && slot > 0 && slot <= state.length && state[slot-1] > 0
      state[slot-1] -= 1
      state
    else
      return false
    end
  end

  def parameter_bounds_warning(param, slots_length=true)
    if slots_length
      return "INVALID #{param}: please choose a positive integer less than or equal to #{@states.last.length}."
    else
      return "INVALID #{param}: please choose a positive integer."
    end
  end

end
