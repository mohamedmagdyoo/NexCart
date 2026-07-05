require 'xcodeproj'
project_path = 'NexCart.xcodeproj'
project = Xcodeproj::Project.open(project_path)

target = project.targets.first

# Add SettingsView and UpdateProfileView
view_group = project.main_group.find_subpath(File.join('NexCart', 'Modules', 'Profile', 'Presentation', 'View'), true)
view_group.set_source_tree('<group>')
view_group.set_path('NexCart/Modules/Profile/Presentation/View')
ref1 = view_group.new_file('NexCart/Modules/Profile/Presentation/View/SettingsView.swift')
ref2 = view_group.new_file('NexCart/Modules/Profile/Presentation/View/UpdateProfileView.swift')
target.add_file_references([ref1, ref2])

# Add AppSettings
utils_group = project.main_group.find_subpath(File.join('NexCart', 'Core', 'Utils'), true)
utils_group.set_source_tree('<group>')
utils_group.set_path('NexCart/Core/Utils')
ref3 = utils_group.new_file('NexCart/Core/Utils/AppSettings.swift')
target.add_file_references([ref3])

project.save
