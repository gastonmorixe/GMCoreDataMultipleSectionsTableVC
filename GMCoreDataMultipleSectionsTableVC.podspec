Pod::Spec.new do |s|
  s.name             = "GMCoreDataMultipleSectionsTableVC"
  s.version          = "0.1.0"
  s.summary          = "UITableViewController subclass backed by multiple NSFetchedResultsControllers"
  s.description  = <<-DESC
	UITableViewControllers are backed most of the time with only one NSFetchedResultsController. This subclass allows you to have multiple NSFetchedResultsControllers, each under a section with a custom title.
                   DESC
  s.homepage     = "https://github.com/imton/GMCoreDataMultipleSectionsTableVC/"
  
  s.license          = 'MIT'
  s.author           = { "Gaston Morixe" => "gaston@black.uy" }
  s.source           = { :git => "https://github.com/imton/GMCoreDataMultipleSectionsTableVC.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/imton'

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.frameworks = 'CoreData'

  s.source_files = '*.{h,m}'

  s.public_header_files = '*.h'
end
