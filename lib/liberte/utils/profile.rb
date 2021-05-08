unless $liberteprofile
  def _profile(s = nil)
  end
else
  $profile_timer_initial = nil
  $profile_timer = nil
  def _profile(s = nil)
    unless $profile_timer
      $profile_timer = $profile_timer_initial = Time.now
    else
      now = Time.now
      str = "#{now - $profile_timer_initial}, #{now - $profile_timer}, #{caller_locations[0]}"
      str += ", " + s if s
      puts str
      $profile_timer = now
    end
    return nil
  end
  def _get(a)
    _profile
    puts get(a).status
    _profile
    $profile_timer = $profile_timer_initial = nil
  end
  def _post(a,b)
    _profile
    puts post(a,b).status
    _profile
    $profile_timer = $profile_timer_initial = nil
  end
end
