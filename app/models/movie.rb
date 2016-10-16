class Movie < ActiveRecord::Base
    def self.all_ratings
        Movie.select(:rating).map{ |r| r.rating }.uniq
    end
    
end
