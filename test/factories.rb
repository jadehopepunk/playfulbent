Factory.define :user do |f|
  f.nick {|n| "user#{n}"}
  f.email {|n| "user#{n}@craigambrose.com"}
end

Factory.define :story_subscription do |f|
  f.association :story
  f.association :user
end

Factory.define :story do |f|
  f.title "some story"
  f.first_page_text "once upon a time"
  f.association :author, :factory => :user
end