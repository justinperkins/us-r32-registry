# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

namespace :db do
  namespace :users do
    desc "Adds the latitude/longitude to all users"
    task :set_latitude_and_longitude => :environment do
      puts 'Looking for users that are missing their latitude/longitude'
      User.find( :all ).select { |u| u.latitude.blank? || u.longitude.blank? || u.latitude == '0' || u.longitude == '0' }.each do |u|
        # the save action triggers an update of the lat/long
        puts "Updating user: #{ u.id }"
        u.save
      end
      puts 'All done!'
    end
  end
end