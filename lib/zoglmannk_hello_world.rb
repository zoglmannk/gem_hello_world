class Hello
  def self.hi(to_who = "world")
    msg = "Hello #{to_who}!"
    puts msg
    msg
  end
end
