# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.new { |m|
      m.title = movie[:title]
      m.rating = movie[:rating]
      m.release_date = movie[:release_date]
      m.director = movie[:director]
    }.save!
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  assert(page.body =~ /#{e1}.*#{e2}/m, "ERROR: #{e1} not before #{e2}")
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  check_type = uncheck ? "uncheck" : "check"
  rating_list.gsub!(' ', '')
  ratings = rating_list.split(',')
  ratings.each do |rating|
    step "I #{check_type} \"ratings_#{rating}\""
  end
end

Then /I should see all the movies$/ do
  # Make sure that all the movies in the app are visible in the table
  shown_movies = page.all('table#movies tr').count - 1 # -1 for headers
  assert shown_movies == Movie.all.count
end

Then /I should see all the movies sorted by release date$/ do
  sorted_release_dates = Movie.all.map { |m| m.release_date }.sort
  (sorted_release_dates.count - 1).times do |i|
    release_dates = sorted_release_dates[i..i+1]
    step "I should see \"#{release_dates[0]}\" before \"#{release_dates[1]}\""
  end
end

Then /I should see all the movies sorted by title$/ do
  sorted_titles = Movie.all.map { |m| m.title }.sort
  (sorted_titles.count - 1).times do |i|
    titles = sorted_titles[i..i+1]
    step "I should see \"#{titles[0]}\" before \"#{titles[1]}\""
  end
end

Then /^I should (not)? see movies with the following ratings: (.*)$/ do |absent, rating_list|
  rating_list.gsub!(' ', '')
  ratings = rating_list.split(',')
  movies_with_ratings = Movie.where(:rating => ratings)
  shown_movies = page.all('table#movies tr').count
  if not absent
    shown_movies.should == movies_with_ratings.count
  else
    shown_movies.should == Movie.all.count - movies_with_ratings.count
  end
end
    
Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  m = Movie.find_by_title(arg1)
  m.director.should == arg2
#step %Q{I should see "#{arg1}"}
#step %Q{I should see "#{arg2}"}
end
