class UserGroupWrapper
  def initialize( user_group )
    @user_group = user_group
  end

  def anonymous?
    return true;
  end

  def name
    return @user_group.lastname
  end

  def ==(other)
    @user_group.users.each do |user|
      if user == other
        return true #一人でも一致するユーザがいればtrue
      end
    end
    return false #一人も一致するユーザがいない
  end

  def id
    return @user_group.id #ユーザとグループのIDは被らない（共通の通し番号が振られる）
  end
end
