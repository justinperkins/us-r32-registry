require File.dirname(__FILE__) + '/../test_helper'

class R32Test < Test::Unit::TestCase
  fixtures :r32s, :users, :posts

  def test_create_mkiv_r32
    r = R32.new :chassis => 'mkiv', :color => 'dbp', :interior => 'leather', :purchased_on => 5.days.ago, :vin => '98765432123456789'
    assert r.save
  end

  def test_create_mkiv_r32_with_duplicate_vin
    r = r32s(:mkiv)
    r = R32.new :chassis => 'mkiv', :color => 'dbp', :interior => 'leather', :purchased_on => 5.days.ago, :vin => r.vin
    assert !r.save
    assert r.errors[:vin]
    r.vin = '98765432123456789'
    assert r.save
  end

  def test_core_validation_with_r32
    r = R32.new
    assert !r.save
    assert r.errors[:chassis]
    assert r.errors[:color]
    assert r.errors[:interior]
  end
  
  def test_extra_validation_if_r32_purchased
    r = R32.new :chassis => 'mkiv', :color => 'dbp', :interior => 'leather'
    assert !r.save
    assert r.errors[:purchased_on]
    assert r.errors[:vin]
  end
  
  def test_vin_format_validation
    r = R32.new :chassis => 'mkiv', :color => 'dbp', :interior => 'leather', :purchased_on => 5.days.ago, :vin => 'f'
    assert !r.save
    assert r.errors[:vin]
    r.vin = '98765432123456789'
    assert r.save
  end
  
  def test_required_fields_when_preorded
    r = R32.new :chassis => 'mkv', :color => 'dbp', :interior => 'leather'
    assert !r.save
    assert r.errors[:purchased_on]
    assert r.errors[:vin]
    r.preordered = true
    assert r.save
  end
  
  def test_edition_number_required_where_applicable
    r = R32.new :chassis => 'mkv', :color => 'dbp', :interior => 'leather', :purchased_on => 5.days.ago, :vin => '98765432123456789'
    assert !r.save
    assert r.errors[:edition_number]
    r.edition_number = '1'
    assert r.save
  end
  
  def test_picture_url_format_validation
    r = R32.new :chassis => 'mkv', :color => 'dbp', :interior => 'leather', :purchased_on => 5.days.ago, :vin => '98765432123456789', :edition_number => '1', :picture_url => 'foo'
    assert !r.save
    assert r.errors[:picture_url]
    r.picture_url = 'http://www.foo.com'
    assert r.save
  end
  
  def test_owner_name
    r = r32s(:mkiv)
    u = users(:admin)
    assert_equal r.owner, "#{u.first_name} #{u.last_name}"
  end
  
  def test_active_logs_size
    logs = R32.active_logs
    assert_equal logs.size, 2
  end

  def test_active_logs_order
    logs = R32.active_logs
    puts logs.first.posts.first.inspect
  end
end
