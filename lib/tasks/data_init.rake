# Copyright 2007-2008 Justin Perkins
# The R32 registry is distributed under the GNU General Public Licens. See license.txt or http://www.gnu.org/

namespace :db do
  namespace :users do
    desc "Adds the latitude/longitude to all users"
    task :set_missing_coordinates => :environment do
      puts 'Looking for users that are missing their latitude/longitude'
      User.find(:all, :conditions => ["latitude IS NULL OR latitude = '0' OR longitude IS NULL OR longitude = '0'"]).each do |u|
        puts "Updating user: #{ u.id } (#{ u.city }, #{ u.state })"
        u.update_coordinates
        u.save
        puts "Updated to: #{ u.latitude }, #{ u.longitude } (lat/long)"
      end
      puts 'All done!'
    end
  end
end