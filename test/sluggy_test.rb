require 'test_helper'

class SluggyDefaultsTest < Test::Unit::TestCase
  class Post < ActiveRecord::Base
    slug_for :title
  end

  def setup
    Post.delete_all
    Post.create!(:title => 'First Post')
  end

  def test_with_new_title
    post = Post.create!(:title => 'Second Post')
    assert_equal('second-post', post.permalink)
  end

  def test_with_same_title
    post = Post.create!(:title => 'First Post')
    assert_equal('first-post--1', post.permalink)
  end

  def test_with_two_same_title
    post_1 = Post.create!(:title => 'First Post')
    post_2 = Post.create!(:title => 'First Post')
    assert_equal('first-post--1', post_1.permalink)
    assert_equal('first-post--2', post_2.permalink)
  end

  def test_slug_should_be_clean
    post = Post.create!(:title => ' Third   Post\'s! is-good_now!?? ')
    assert_equal('third-posts-is-good_now', post.permalink)
  end
  
  def test_should_validate_when_updating_slug
    post = Post.create!(:title => 'First Post')
    assert_equal('first-post--1', post.permalink)
    post.update_attributes(:permalink => '')
    assert_equal('first-post--1', post.permalink)
    post.update_attributes(:permalink => 'first-post!! iji@@')
    assert_equal('first-post--1', post.reload.permalink)
    post.update_attributes(:permalink => 'first-post')
    assert_equal('first-post--1', post.reload.permalink)
  end
end

class SluggyWithOptionsTest < Test::Unit::TestCase
  class User < ActiveRecord::Base
    slug_for :name, {:column => :handle, :scope => :account_id}
  end

  def setup
    User.delete_all
    User.create!(:name => 'Ary Djmal', :account_id => 1)
  end

  def test_with_new_title
    user = User.create!(:name => 'Nati Djmal', :account_id => 1)
    assert_equal('nati-djmal', user.handle)
  end

  def test_with_same_name
    user = User.create!(:name => 'Ary Djmal', :account_id => 1)
    assert_equal('ary-djmal--1', user.handle)
  end

  def test_with_two_same_title
    user_1 = User.create!(:name => 'Ary Djmal', :account_id => 1)
    user_2 = User.create!(:name => 'Ary Djmal', :account_id => 1)
    assert_equal('ary-djmal--1', user_1.handle)
    assert_equal('ary-djmal--2', user_2.handle)
  end

  def test_with_same_title_but_not_in_scope
    user = User.create!(:name => 'Ary Djmal', :account_id => 2)
    assert_equal('ary-djmal', user.handle)
  end

  def test_should_validate_when_updating_slug
    user = User.create!(:name => 'Ary Djmal', :account_id => 1)
    assert_equal('ary-djmal--1', user.handle)
    user.update_attributes(:handle => '')
    assert_equal('ary-djmal--1', user.handle)
    user.update_attributes(:handle => 'ary-djmal!! iji@@')
    assert_equal('ary-djmal--1', user.reload.handle)
    user.update_attributes(:handle => 'ary-djmal')
    assert_equal('ary-djmal--1', user.reload.handle)
  end
end

class SluggyWithScopeArrayTest < Test::Unit::TestCase
  class User < ActiveRecord::Base
    slug_for :name, {:column => :handle, :scope => [:account_id, :deleted]}
  end

  def setup
    User.delete_all
    User.create!(:name => 'Ary Djmal', :account_id => 1)
  end

  def test_with_same_name
    user = User.create!(:name => 'Ary Djmal', :account_id => 1)
    assert_equal('ary-djmal--1', user.handle)
    user = User.create!(:name => 'Ary Djmal', :account_id => 1, :deleted => true)
    assert_equal('ary-djmal', user.handle)
  end
end
