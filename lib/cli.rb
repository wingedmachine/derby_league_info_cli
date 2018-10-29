class Cli
  def start
    greet
    load_initial
    load_complete
    main_loop
    goodbye
  end

  def greet
    puts "Welcome to thing, wait for load..."
  end

  def load_initial
  end

  def load_complete
    puts "Load done thins will start"
  end

  def main_loop
    input = nil
    until input == "exit"
      puts "Waht do?"
      input = gets.downcase.strip
    end
  end

  def goodbye
    puts "fuck outta here"
  end
end
