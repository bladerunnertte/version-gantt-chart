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

  def id
    return 0 #DBで振られるユーザIDは1始まりなので0にした
  end
end
