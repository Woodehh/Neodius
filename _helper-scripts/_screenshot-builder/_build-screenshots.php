#!/usr/bin/php
<?php
	chdir(__DIR__);
	
	require("./_dependencies/_functions.php");

	
	define("LOCALIZATION_DIR", "../../Neodius/Supporting Files/LocalizedData/");
	define("LOCALES","./_dependencies/Localizations.json");
	define("SCREENSHOT_DIR", "./_tmp_screenshots/");
	define("DEVICES_FILE","./_dependencies/devices.json");
	define("SCREENSHOT_CONFIGS","./_dependencies/screenshots.config.php");
	define("SCREENSHOT_TARGET_DIR","../../Artwork/Screenshots/");
	define("README_LOCATION","../../README.md");
	define("T", " 👍  ");
	define("F", " 😡  ");
	define("S", " 🔍  ");

	//////////////////////////////
	//DO NOT EDIT BELOW THIS LINE!
	//////////////////////////////
	
	//loading devices
	if (!$devices = loadDevices()) 
		die("Can't load Device file");

	//load up the available languages:
	$languages = parseLanguageFiles();
	
	//array for translation contributions
	$contributors = array();


	//loop the directory
	foreach ($languages as $language_identifier=>$l) {
		
		$array_screenshot_info = array();

		// language identifier (eg: nl_NL/en/es_CO)
		//if the languge identifier is two, we need to smallcase and then uppercase
		//combined with a dash: nl-NL		
		$id = $language_identifier;//((strlen($id=$language_identifier) == 2) ? strtolower($id)."-".strtoupper($id): $id);
		// Localized Language name: E.G. Deutschland, Nederland, Espana
		$n = $l['nameLocalized'];
		// English name: Nederlands, 中文（简体, 中文（繁體, etc
		$n_e = $l['nameEnglish'];
		
		//emoji
		$emoji = $l['emojiFlag'];
		
		// The strings file which we parse to get info from
		parseStringsFile($l['stringsFile']);
		//(re)load screenshot files	
		include(SCREENSHOT_CONFIGS);
		
		// ...
		echo "Processing: {$emoji}  {$id} - {$n_e} ({$n}): \n";
		
		$contributor = __("<Language> is translated by: <your (nick) name> (<e-mail>)");
		
		
		
		//try to find the files:
		if (is_dir($ld = SCREENSHOT_DIR.$id."/")) {
			echo T."Found screenshots, check for devices\n";
			$screenshot_files = glob($ld."/*.png");
			$doneDevices = array();
			
			foreach ($devices as $device => $file_identfier) {
				echo S."Scanning for {$device} files. \n";
				$screenshots_filtered = array();
				foreach ($screenshot_files as $f) {
					if (substr(basename($f), 0, strlen($file_identfier)) == $file_identfier ) {
						// realfile
						$target_file_name = str_replace($file_identfier."-", "", basename($f));
						//check for files
						if (array_key_exists($target_file_name, $array_screenshots)) {
							$screenshots_filtered[] = array(
								"realpath"			=> realpath($f),
								"target_file_name" 	=> $target_file_name,
								"description"		=> $array_screenshots[$target_file_name]
							);
						}
					}
				}
				
				$screenshot_count = count($screenshots_filtered);
				$array_screenshots_count = count($array_screenshots);
				
				echo sprintf("\tfound %s screenshots: ",count($screenshots_filtered));
				
				if ($screenshot_count != $array_screenshots_count) {
					echo "Not enough...skipping".F."\n";
					
				} else {
					
					$doneDevices[] = $device;
					
					$target_readme_md = slugify($l['nameEnglish'])."-screenshots.md";
										
					if (!is_writable(SCREENSHOT_TARGET_DIR))
						die("SCREENSHOT_TARGET_DIR NOT WRITABLE");
					
					//the basedir: targetdir/english-name/device-type/	
					$baseDir = SCREENSHOT_TARGET_DIR.$l['nameEnglish']."/{$device}/";
					
					@mkdir(SCREENSHOT_TARGET_DIR.$l['nameEnglish']);
					@mkdir($baseDir);
					

					$screenshot_html_code = array();
					foreach ($screenshots_filtered as $s) {
						$screenshot_html_code[] = sprintf('<img src="%s" width="200" alt="%s">',$s['target_file_name'],__($s['description']));
						copy($s['realpath'], $baseDir."/".$s['target_file_name']);
					}
						
					$template_file = file_get_contents("./_dependencies/screenshot-template.md");
					$readme_markdown = str_replace("%nameEnglish%", $emoji." ".$l['nameEnglish'], $template_file);										
					$readme_markdown = str_replace("%nameLocalized%", $l['nameLocalized'], $readme_markdown);

					if (strpos($contributor,"<e-mail>") === FALSE)
						$readme_markdown = str_replace("%creditLine%", "\n**{$contributor}**\n", $readme_markdown);	
					else
						$readme_markdown = str_replace("%creditLine%", "", $readme_markdown);	
						
					$readme_markdown = str_replace("%screenshots%", @implode(" ", $screenshot_html_code)	, $readme_markdown);
					

					
					$other_devices = array();
					
					//build the other screenshots
				
					foreach ($devices as $d => $i) {
						
						if ($device == $d)
							continue;
							
						$other_devices[] = "[**View {$d} screenshots**](../".rawurlencode($d)."/{$target_readme_md})";
						
					}
					
					$readme_markdown = str_replace("%otherDevice%", implode(" | ", $other_devices), $readme_markdown);
					
					file_put_contents($baseDir.$target_readme_md, $readme_markdown);
								
					echo "done processing".T."\n";
				}				
			}
			
			$done_languages[] = array(
				"emoji"=>$emoji,
				"name"=>$l['nameEnglish'],
				"readme"=>$target_readme_md,
				"devices"=>$doneDevices
			);
			
			if (strpos($contributor,"<e-mail>") === FALSE)
				$contributors[] = $contributor;
			
		} else {
			echo F."Can't find screenshots\n";
		}
	}
	
	echo "\n\nFixing readme.md...";


	if (count($done_languages)>0) {
		
		
		//sort the stuff
		usort($done_languages, function ($a, $b) {
			  return strcmp($a["readme"], $b["readme"]);
		});

		echo count($done_languages)." Found!\n\n";

		$screenshot_string="";

		foreach ($done_languages as $l) {
			$language_device = array();			
			foreach ($l['devices'] as $d) {
				$language_device[] = "[$d screenshots](Artwork/Screenshots/".rawurlencode($l['name'])."/".rawurlencode($d)."/{$l['readme']})";				
			}
			$screenshot_string .= "\t* {$l['emoji']}  {$l['name']} - ".implode(" | ", $language_device)."\n";			
		}

		if (!file_exists(README_LOCATION))
			die("Readme doesn't exists\n\n");
			
		$readme_line = "* Supported languages:";
		$readme = file_get_contents(README_LOCATION);
		$readme_new = preg_replace("/\* Supported languages:(.*?)\#/s", "$readme_line\n".$screenshot_string."\n#", $readme);


		foreach ($contributors as $k=>$c) {
			$contributors[$k] = "* {$c}\n";
		}
		
		
		$readme_new = preg_replace("/\### Translators(.*?)###/s", "### Translators\n".implode("", $contributors)."\n###", $readme_new);		
		
		file_put_contents(README_LOCATION, $readme_new);

		echo "I've build the README.MD file\n\n";
		@unlink(SCREENSHOT_DIR."/screenshots.html");
		
	} else {
		echo "nothing found!";
	}
	
	