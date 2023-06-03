# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Munchkin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit', '~> 5.0.0'
  
  post_install do |installer|
   installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
   end
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        if config.build_settings['WRAPPER_EXTENSION'] == 'bundle'
          config.build_settings['DEVELOPMENT_TEAM'] = '9486727C5W'
        end
      end
    end
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      if target.name == 'Realm'
        create_symlink_phase = target.shell_script_build_phases.find { |x| x.name == 'Create Symlinks to Header Folders' }
        create_symlink_phase.always_out_of_date = "1"
      end
    end
  end

end
