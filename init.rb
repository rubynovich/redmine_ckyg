Redmine::Plugin.register :redmine_ckyg do
  name 'Ckyg'
  author 'Roman Shipiev'
  description 'Importing information about workplace time'
  version '0.0.1'
  url 'https://bitbucket.org/rubynovich/redmine_ckyg.git'
  author_url 'http://roman.shipiev.me'
end

Rails.configuration.to_prepare do

  [
   :user,
  ].each do |cl|
    require "ckyg_#{cl}_patch"
  end

  [
    [User,  CkygPlugin::UserPatch],
  ].each do |cl, patch|
    cl.send(:include, patch) unless cl.included_modules.include? patch
  end


end
