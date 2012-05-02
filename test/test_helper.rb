require 'test/unit'
require 'active_record'
require 'sluggy'

ActiveRecord::Base.establish_connection({
  :adapter  => 'sqlite3',
  :database => ':memory:'
})

ActiveRecord::Schema.define do
  create_table :posts do |t|
    t.string  :title, :permalink
  end

  create_table :users do |t|
    t.string  :name, :handle
    t.integer :account_id
  end
end

class Post < ActiveRecord::Base
end

class User < ActiveRecord::Base
end
