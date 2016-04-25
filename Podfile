case ENV['PODFILE_TYPE']
	when 'release'
	puts '=====================release======================='
		target 'IMUI', :exclusive => true do
            #		 	pod "HYPhotoBrowser", :git => "git@gittest.58corp.com:ios_huangye_team/HYPhotoBrowser.git"
 			pod "HYCoreFramework", :git => "git@gitlab.58corp.com:ios_huangye_team/HYCoreFramework.git"
 			pod "IMSDK", :git => "git@gitlab.58corp.com:ios_huangye_team/IMSDK.git"
            pod "HYPhotoBrowser", :git => "git@gitlab.58corp.com:ios_huangye_team/HYPhotoBrowser.git", :branch => "1.0"
			pod "HYPOPView", :git => "git@gitlab.58corp.com:ios_huangye_team/HYPOPView.git"
            pod 'ReactiveCocoa', '~> 2.5'
            pod 'Aspects', '~> 1.4.1'
            pod 'SDWebImage', '~> 3.7.3'
            pod 'pop'
            pod 'FIR.im'
		end
	when 'development'
	puts '=====================development======================='
		target 'IMUI', :exclusive => true do
       		 	pod "HYPhotoBrowser", :path => "~/huangye_ios_lib/HYPhotoBrowser"
 			pod "HYCoreFramework", :path => "~/huangye_ios_lib/HYCoreFramework"
 			pod "IMSDK", :path => "~/huangye_ios_lib/IMSDK"
            pod 'ReactiveCocoa', '~> 2.5'
            pod 'Aspects', '~> 1.4.1'
            pod 'SDWebImage', '~> 3.7.3'
            pod 'pop'
            pod 'HYPOPView', :path => "~/huangye_ios_lib/HYPOPView"
            pod 'FIR.im'
		end
end
