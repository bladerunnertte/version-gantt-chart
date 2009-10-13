class NobodyUser
  def anonymous?
    return true;
  end

  def name
    return "anonymous"
  end

  def ==(other)
    if equal?(other)
      return true 
    elsif other.nil?
      return true
    else
      return false
    end
  end
end
