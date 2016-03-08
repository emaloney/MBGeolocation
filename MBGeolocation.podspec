#####################################################################
#
# Mockingbird Geolocation -- CocoaPod Specification
#
# Created by Evan Coyne Maloney on 10/1/14.
# Copyright (c) 2014 Gilt Groupe. All rights reserved.
#
#####################################################################

Pod::Spec.new do |s|

	s.name                  = "MBGeolocation"
	s.version               = "0.12.1"
	s.summary               = "Mockingbird Geolocation Extensions"
	s.description		= "Provides a geolocation service that simplifies the use of CoreLocation."
	s.homepage		= "https://github.com/emaloney/MBGeolocation"
	s.license               = { :type => 'MIT', :file => 'LICENSE' }
	s.author                = { "Evan Coyne Maloney" => "emaloney@gilt.com" }
	s.platform              = :ios, '9.0'
	s.ios.deployment_target = '8.0'
	s.requires_arc          = true

	s.source = {
		:git => 'https://github.com/emaloney/MBGeolocation.git',
		:tag => s.version.to_s
	}

	s.source_files		= 'Code/**/*.{h,m}'
	s.public_header_files	= 'Code/**/*.h'

	s.resource_bundle	= { 'MBGeolocation' => 'Resources/*.xml' }

	#----------------------------------------------------------------
	# Dependencies
	#----------------------------------------------------------------

	s.dependency 'MBToolbox', '~> 1.2.0'
	s.dependency 'MBDataEnvironment', '~> 1.3.2'

end
